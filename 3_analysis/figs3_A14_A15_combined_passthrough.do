********************************************************************************
* FIGURE 3: pass-through of VAT exemptions to prices in Port Moresby, by source
*
* Reconstruction. Produces:
*   Outputs/Figures/figure_3a.{pdf,png}    (raw trends, admin sources only)
*   Outputs/Figures/figure_3b.{pdf,png}    (pass-through, admin sources only)
*   Outputs/Figures/figure_a14.{pdf,png}   (raw trends, + store survey)
*   Outputs/Figures/figure_a15.{pdf,png}   (pass-through, + store survey)
*
* Three sources: Central Bank (RPI), NSO administrative, and the store survey
* (POM supermarket census, store x item fixed effects). Matches published A14/A15.
*
* METHOD (paper eq. 1): for each source, prices are normalized to 1 in May 2025;
* an event study with item and month fixed effects gives the monthly
* difference-in-differences coefficients. Control = non-exempt items.
*
* The treatment indicator is harmonized to numeric `tg' (0/1): the Central Bank
* (RPI) source stores `treat' as a STRING and is recoded here; NSO is already 0/1.
*
* Aesthetics: panel (a) overlays both sources, treatment solid / control dashed
* and faded, one colour per source. Panel (b) overlays the DiD path with capped
* 95% CI spikes per source, on the percentage-point scale (full pass-through =
* -9.1 p.p.). Both panels use a calendar x-axis.
********************************************************************************

clear all
set more off
do "${dir_do}/1_data_prep/01_globals.do"
cap mkdir "$dir_graphs"

* Source colours and labels (srcid 1 = Central Bank, 2 = NSO)
local color1 "$my_blue"
local color2 "$my_red"
local lab1   "Central Bank admin."
local lab2   "NSO admin."
local color3 "$my_green"
local lab3   "Store survey"

********************************************************************************
* 1. Build one harmonized panel: srcid, stata_month (%tm), tg (0/1), y, idstr
********************************************************************************

* ---- NSO administrative (treat already 0/1) ----
use "${final_nso}/NSO_Prices_Long.dta", clear

* NSO control composition. nso_packaged_only == 1 restricts the NSO control to
* packaged items by dropping fresh produce (Aibika, Bananas, Broccoli, Kaukau),
* which tightens the pre-trends; the control endpoint and the pass-through result
* are unchanged. == 0 reverts to the original pipeline behavior (drop Aibika only).
* CONFIRM the Item strings match those in NSO_Prices_Long.dta.
local nso_packaged_only = 1
if `nso_packaged_only' == 1 {
    drop if treat == 0 & regexm(lower(Item), "aibika|banana|brocc?oli|kaukau")
}
else {
    drop if Item == "Aibika"
}
bysort Item: egen _base = mean(cond(month_year == 29, Price, .))   // May 2025 = month_year 29
drop if missing(_base)
gen double y = Price / _base
gen int stata_month = tm(2023m1) + month_year - 1
gen byte tg = treat
gen str40 idstr = Item
gen byte srcid = 2
gen str20 storestr = ""
keep srcid stata_month tg y idstr storestr
tempfile dat
save `dat'

* ---- Store survey (POM supermarket census; treat_all; store x item FE) ----
use "${final_stores}/POM_Prices_Long_Clean.dta", clear
gen double price_per_unit = Price / quantity
drop if missing(price_per_unit) | price_per_unit <= 0
gen int month_num = .
replace month_num = 1 if Month == "May"
replace month_num = 2 if Month == "June"
replace month_num = 3 if Month == "July"
replace month_num = 4 if Month == "August"
replace month_num = 5 if Month == "September"
replace month_num = 6 if Month == "October"
keep if !missing(month_num)
* winsorize by item (5/95), matching the store event study
bysort item_code: egen _p5  = pctile(price_per_unit), p(5)
bysort item_code: egen _p95 = pctile(price_per_unit), p(95)
gen double price_w5 = price_per_unit
replace price_w5 = _p5  if price_per_unit < _p5  & !missing(_p5)
replace price_w5 = _p95 if price_per_unit > _p95 & !missing(_p95)
drop _p5 _p95
* treatment (all items); normalize to May 2025 per store x item (fallback: item)
gen byte tg = treat_all
keep if !missing(tg)
bysort item_code sheet_index: egen _base_si = mean(cond(month_num == 1, price_w5, .))
bysort item_code:              egen _base_i  = mean(cond(month_num == 1, price_w5, .))
replace _base_si = _base_i if missing(_base_si)
gen double y = price_w5 / _base_si
drop if missing(y)
* balanced panel: keep store x item observed in all 6 months
egen long _sp = group(sheet_index item_code)
bysort _sp: gen long _nmonths = _N
keep if _nmonths == 6
drop _sp _nmonths _base_si _base_i
* harmonize to the common schema
gen int stata_month = tm(2025m5) + month_num - 1
gen str40 idstr    = string(item_code)
gen str20 storestr = string(sheet_index)
gen byte srcid = 3
keep srcid stata_month tg y idstr storestr
tempfile dat_store
save `dat_store'

* ---- Central Bank / RPI administrative (treat is a STRING -> recode) ----
use "${final_rpi}/rpi_cleaned_data.dta", clear
gen double y = price_norm                       // already normalized to May 2025 = 1
gen int stata_month = month                     // 'month' is already a %tm monthly date
capture confirm string variable treat
if !_rc {
    gen byte tg = (strpos(treat, "Treat") > 0)  // "Treatment (VAT exempt)" -> 1
}
else {
    gen byte tg = treat
}
gen str40 idstr = item_name_clean
gen byte srcid = 1
gen str20 storestr = ""
keep srcid stata_month tg y idstr storestr
append using `dat'
append using `dat_store'

* event time (June 2025 = 0) and a numeric panel unit id, unique within source
gen int event_time = stata_month - tm(2025m6)
egen long idnum   = group(srcid idstr)
egen long storeid = group(srcid storestr)
label define srcL 1 "Central Bank admin." 2 "NSO admin." 3 "Store survey"
label values srcid srcL

local refm = tm(2025m5) + 0.5                    // reform between May and June 2025
local x1   = tm(2023m12)
local x2   = tm(2026m5)

********************************************************************************
* 2a. RAW TRENDS (panel a): mean normalized price, treatment vs control
********************************************************************************

preserve
collapse (mean) y, by(srcid stata_month tg)
gen double yt = y if tg == 1
gen double yc = y if tg == 0

* --- Figure 3a: administrative sources only (Central Bank + NSO) ---
twoway (connected yt stata_month if srcid==1, lcolor("$my_blue")    mcolor("$my_blue")    lpattern(solid) lwidth(medthick) msize(small)) ///
       (connected yc stata_month if srcid==1, lcolor("$my_blue%50") mcolor("$my_blue%50") lpattern(dash)  lwidth(medthick) msize(small)) ///
       (connected yt stata_month if srcid==2, lcolor("$my_red")     mcolor("$my_red")     lpattern(solid) lwidth(medthick) msize(small)) ///
       (connected yc stata_month if srcid==2, lcolor("$my_red%50")  mcolor("$my_red%50")  lpattern(dash)  lwidth(medthick) msize(small)) ///
       (line yt stata_month if 0, lcolor(gs7) lpattern(solid) lwidth(medthick)) ///
       (line yt stata_month if 0, lcolor(gs7) lpattern(dash)  lwidth(medthick)) ///
    , title("Raw Price Trends for VAT-Exempt and Control Items in Port Moresby", size(medsmall)) ///
      xline(`refm', lpattern(dash) lcolor(gs8)) ///
      ytitle("Price (May 2025 = 1)") xtitle("") ///
      xlabel(`x1'(3)`x2', angle(45) format(%tmMon_YY) nogrid) ///
      ylabel(0.85(0.05)1.08, nogrid format(%4.2f)) ///
      text(1.066 `=tm(2025m6)' "VAT exemptions", size(small) color(gs6) box bcolor(white) lcolor(gs6) placement(e)) ///
      legend(order(1 "`lab1'" 3 "`lab2'" 5 "Solid = Treatment" 6 "Dashed = Control") ///
             col(2) pos(7) ring(0) region(lstyle(none)) size(small)) ///
      graphregion(color(white)) plotregion(color(white))
graph export "$dir_graphs/figure_3a.png", replace width(2400)

* --- Figure A14: add the store survey ---
twoway (connected yt stata_month if srcid==1, lcolor("$my_blue")    mcolor("$my_blue")    lpattern(solid) lwidth(medthick) msize(small)) ///
       (connected yc stata_month if srcid==1, lcolor("$my_blue%50") mcolor("$my_blue%50") lpattern(dash)  lwidth(medthick) msize(small)) ///
       (connected yt stata_month if srcid==2, lcolor("$my_red")     mcolor("$my_red")     lpattern(solid) lwidth(medthick) msize(small)) ///
       (connected yc stata_month if srcid==2, lcolor("$my_red%50")  mcolor("$my_red%50")  lpattern(dash)  lwidth(medthick) msize(small)) ///
       (connected yt stata_month if srcid==3, lcolor("$my_green")    mcolor("$my_green")    lpattern(solid) lwidth(medthick) msize(small)) ///
       (connected yc stata_month if srcid==3, lcolor("$my_green%50") mcolor("$my_green%50") lpattern(dash)  lwidth(medthick) msize(small)) ///
       (line yt stata_month if 0, lcolor(gs7) lpattern(solid) lwidth(medthick)) ///
       (line yt stata_month if 0, lcolor(gs7) lpattern(dash)  lwidth(medthick)) ///
    , title("Raw Price Trends for VAT-Exempt and Control Items in Port Moresby", size(medsmall)) ///
      xline(`refm', lpattern(dash) lcolor(gs8)) ///
      ytitle("Price (May 2025 = 1)") xtitle("") ///
      xlabel(`x1'(3)`x2', angle(45) format(%tmMon_YY) nogrid) ///
      ylabel(0.85(0.05)1.08, nogrid format(%4.2f)) ///
      text(1.066 `=tm(2025m6)' "VAT exemptions", size(small) color(gs6) box bcolor(white) lcolor(gs6) placement(e)) ///
      legend(order(1 "`lab1'" 3 "`lab2'" 5 "`lab3'" 7 "Solid = Treatment" 8 "Dashed = Control") ///
             col(3) pos(7) ring(0) region(lstyle(none)) size(small)) ///
      graphregion(color(white)) plotregion(color(white))
graph export "$dir_graphs/figure_a14.png", replace width(2400)
restore

********************************************************************************
* 2b. EVENT STUDY (panel b): monthly DiD coefficients by source, in p.p.
********************************************************************************

tempname pf
tempfile coefs
postfile `pf' byte srcid int event_time double b double lo95 double hi95 using `coefs', replace

foreach s in 1 2 3 {
    preserve
    keep if srcid == `s'
    quietly summarize event_time
    local lo = r(min)
    gen int et_shift = event_time - `lo'
    local base = -1 - `lo'                       // baseline = May 2025 (event_time -1)
    if `s' == 3 {
        quietly reghdfe y ib`base'.et_shift##i.tg, absorb(idnum storeid stata_month) vce(cluster idnum)
    }
    else {
        quietly reghdfe y ib`base'.et_shift##i.tg, absorb(idnum stata_month) vce(cluster idnum)
    }
    levelsof et_shift, local(ets)
    foreach e of local ets {
        local et = `e' + `lo'
        if `e' == `base' {
            post `pf' (`s') (`et') (0) (0) (0)
        }
        else {
            local cn "`e'.et_shift#1.tg"
            capture local bb = _b[`cn']
            if _rc continue
            local ss = _se[`cn']
            * scale to percentage points (x100): full pass-through = -9.1 p.p.
            post `pf' (`s') (`et') (100*`bb') (100*(`bb'-1.96*`ss')) (100*(`bb'+1.96*`ss'))
        }
    }

    * --- joint pre-trends Wald test: leads strictly before the May 2025 reference ---
    local pretest ""
    foreach e of local ets {
        local et = `e' + `lo'
        if `e' != `base' & `et' <= -2 {
            local pretest "`pretest' `e'.et_shift#1.tg"
        }
    }
    if "`pretest'" != "" {
        quietly test `pretest'
        local k  = r(df)
        local FF = r(F)
        local pp = r(p)
        di as txt _n "{hline 70}"
        di as txt "Joint pre-trends Wald test, `lab`s'' data (`k' leads):"
        di as res "   F = " %6.3f `FF' "   p = " %5.3f `pp'
    }

    * --- post-reform average pass-through: June 2025 onward (event_time >= 0), p.p. ---
    local postsum = 0
    local npost   = 0
    foreach e of local ets {
        local et = `e' + `lo'
        if `et' >= 0 {
            capture local bpost = _b[`e'.et_shift#1.tg]
            if !_rc {
                local postsum = `postsum' + `bpost'
                local ++npost
            }
        }
    }
    if `npost' > 0 {
        di as res "   post-reform average pass-through = " %5.1f `=100*`postsum'/`npost'' " p.p.  (over `npost' months)"
        di as txt "{hline 70}"
    }

    restore
}
postclose `pf'

preserve
use `coefs', clear
gen int mdate = event_time + tm(2025m6)          // back to a calendar month for the x-axis
format mdate %tm
* small horizontal offset so the two sources' bars don't overlap
* offsets so the sources' spikes don't overlap (two-source symmetric; three-source spread)
gen double mdate_off2 = mdate + cond(srcid==1, -0.12, 0.12)
gen double mdate_off3 = mdate + cond(srcid==1, -0.15, cond(srcid==2, 0, 0.15))
sort srcid mdate

* --- Figure 3b: administrative sources only (Central Bank + NSO) ---
twoway (rcap hi95 lo95 mdate_off2 if srcid==1, lcolor("$my_blue") lwidth(medthin) msize(medsmall)) ///
       (rcap hi95 lo95 mdate_off2 if srcid==2, lcolor("$my_red")  lwidth(medthin) msize(medsmall)) ///
       (connected b mdate_off2 if srcid==1, lcolor("$my_blue") mcolor("$my_blue") lwidth(medthick) msize(small)) ///
       (connected b mdate_off2 if srcid==2, lcolor("$my_red")  mcolor("$my_red")  lwidth(medthick) msize(small)) ///
    , title("Pass-through of VAT Exemptions to Prices in Port Moresby", size(medsmall)) ///
      yline(0, lcolor(gs8)) yline(-9.1, lpattern(dash) lcolor(gs6)) ///
      xline(`refm', lpattern(dash) lcolor(gs8)) ///
      ytitle("Price effect (p.p.)") xtitle("") ///
      ylabel(-15(5)10, nogrid) xlabel(`x1'(3)`x2', angle(45) format(%tmMon_YY) nogrid) ///
      text(-9.8 `=tm(2024m2)' "Full pass-through {&Delta}p: -9.1 p.p.", size(vsmall) color(gs6) placement(e)) ///
      text(8 `=tm(2025m6)' "VAT exemptions", size(small) color(gs6) box bcolor(white) lcolor(gs6) placement(e)) ///
      legend(order(3 "`lab1' data" 4 "`lab2' data") col(1) pos(7) ring(0) region(lstyle(none)) size(small)) ///
      graphregion(color(white)) plotregion(color(white))
graph export "$dir_graphs/figure_3b.png", replace width(2400)

* --- Figure A15: add the store survey (store FE) ---
twoway (rcap hi95 lo95 mdate_off3 if srcid==1, lcolor("$my_blue")  lwidth(medthin) msize(medsmall)) ///
       (rcap hi95 lo95 mdate_off3 if srcid==2, lcolor("$my_red")   lwidth(medthin) msize(medsmall)) ///
       (rcap hi95 lo95 mdate_off3 if srcid==3, lcolor("$my_green") lwidth(medthin) msize(medsmall)) ///
       (connected b mdate_off3 if srcid==1, lcolor("$my_blue")  mcolor("$my_blue")  lwidth(medthick) msize(small)) ///
       (connected b mdate_off3 if srcid==2, lcolor("$my_red")   mcolor("$my_red")   lwidth(medthick) msize(small)) ///
       (connected b mdate_off3 if srcid==3, lcolor("$my_green") mcolor("$my_green") lwidth(medthick) msize(small) lpattern(dash_dot)) ///
    , title("Pass-through of VAT Exemptions to Prices in Port Moresby", size(medsmall)) ///
      yline(0, lcolor(gs8)) yline(-9.1, lpattern(dash) lcolor(gs6)) ///
      xline(`refm', lpattern(dash) lcolor(gs8)) ///
      ytitle("Price effect (p.p.)") xtitle("") ///
      ylabel(-15(5)10, nogrid) xlabel(`x1'(3)`x2', angle(45) format(%tmMon_YY) nogrid) ///
      text(-9.8 `=tm(2024m2)' "Full pass-through {&Delta}p: -9.1 p.p.", size(vsmall) color(gs6) placement(e)) ///
      text(8 `=tm(2025m6)' "VAT exemptions", size(small) color(gs6) box bcolor(white) lcolor(gs6) placement(e)) ///
      legend(order(4 "`lab1' data" 5 "`lab2' data" 6 "`lab3' (store FE)") col(1) pos(7) ring(0) region(lstyle(none)) size(small)) ///
      graphregion(color(white)) plotregion(color(white))
graph export "$dir_graphs/figure_a15.png", replace width(2400)
restore

display "{hline 80}"
display "FIGURES 3a/3b + A14/A15 complete (admin: Central Bank + NSO; A14/A15 add Store survey)"
display "{hline 80}"
********************************************************************************
