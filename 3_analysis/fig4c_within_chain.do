/*==============================================================================
 fig4c_within_chain.do
 VAT exemption pass-through and incidence (Papua New Guinea) — analysis

 PURPOSE : Figure 4c — differences in pass-through within the largest supermarket
           chain (Stop and Shop / SNS). Per-store pass-through for each chain
           store, colored by competition group, plus pooled high and pooled low
           within the chain. Per store, TWFE DiD on log price (same estimator as
           the 4b store-level distribution); pct = 100*(exp(b)-1). May-Sep 2025.
 INPUTS  : ${final_stores}/POM_Prices_Long_Clean.dta (prices, lat/lng);
           ${dir_tables}/store_competition_groups.dta (high_comp, from fig4ab);
           globals ${dir_graphs}, ${dir_tables}
 OUTPUTS : ${dir_graphs}/figure_4c.png;
           ${dir_tables}/figure4c_plot_data.dta (+ .csv)
 DEPENDS : Reads ${dir_tables}/store_competition_groups.dta, written by
           fig4ab_event_study_competition.do, which must run FIRST.
 CALLED BY: main.do
==============================================================================*/

clear all
set more off
global my_blue "20 97 128"
global my_red  "150 39 23"

local num_months = 5   // May-Sep, matching the store-level distribution (Panel 4b)

*-------------------------------------------------------------------------------
* CHAIN DEFINITION
*
* The chain is Stop and Shop / SNS. From the diagnostic on the clean data, the
* branded stores are (sheet_index): 1 Stop and Shop (Downtown), 6 Stop and Shop
* (Rainbow), 10 Stop N Shop Badili, 12 Stop and Shop Express (airways), 26 Stop
* and Shop Waigani Central, 27 Stop & Shop Boroko, 38 SNS 8 mile. "(Rainbow)" is
* the location, not the Rainbow brand, so it is included. Set explicitly by
* sheet_index (robust to name spelling). run_diagnostic = 1 re-lists candidates.
*-------------------------------------------------------------------------------
local run_diagnostic = 0                                   // 1 = list chain stores and stop
local chain_ids   "1 6 10 12 26 27 38"                      // Stop and Shop / SNS stores
local chain_pattern "SNS|STOP N SHOP|STOP AND SHOP|STOP & SHOP"  // fallback name match
local chain_exclude "ZZZNONE"                               // no exclusion; Rainbow loc is in-chain

if `run_diagnostic' == 1 {
    use "${final_stores}/POM_Prices_Long_Clean.dta", clear
    capture confirm variable store_type
    if !_rc keep if store_type == "Chain"
    bysort sheet_index (Supermarket): keep if _n == 1
    sort sheet_index
    di as result _newline "DIAGNOSTIC: chain-type stores (read off the six Stop and Shop ids)"
    list sheet_index Supermarket proximity_tertile, clean noobs
    di as error _newline "Set run_diagnostic = 0 and paste the six sheet_index into chain_ids, then rerun."
    exit
}

*-------------------------------------------------------------------------------
* Select the chain
*-------------------------------------------------------------------------------
use "${final_stores}/POM_Prices_Long_Clean.dta", clear

if "`chain_ids'" != "" {
    gen byte _inchain = 0
    foreach id of local chain_ids {
        replace _inchain = 1 if sheet_index == `id'
    }
    keep if _inchain == 1
    drop _inchain
}
else {
    gen _NAME = upper(Supermarket)
    keep if regexm(_NAME, "`chain_pattern'") & !regexm(_NAME, "`chain_exclude'")
    drop _NAME
}

* Report and check the selection
preserve
    keep sheet_index Supermarket proximity_tertile
    duplicates drop
    bysort sheet_index: keep if _n == 1
    sort sheet_index
    list sheet_index Supermarket proximity_tertile, clean noobs
    count
    local n_stores = r(N)
    di as result "Chain stores selected: `n_stores'"
    if `n_stores' != 7 di as error "WARNING: expected 7 stores, selected `n_stores'. Check chain_ids."
restore

*-------------------------------------------------------------------------------
* Build estimation variables (winsorized within the chain)
*-------------------------------------------------------------------------------
gen double price_per_unit = Price / quantity
drop if missing(price_per_unit) | price_per_unit <= 0

gen month_num = .
replace month_num = 1 if lower(strtrim(Month)) == "may"
replace month_num = 2 if inlist(lower(strtrim(Month)), "june", "jun")
replace month_num = 3 if inlist(lower(strtrim(Month)), "july", "jul")
replace month_num = 4 if inlist(lower(strtrim(Month)), "august", "aug")
replace month_num = 5 if inlist(lower(strtrim(Month)), "september", "sep")
keep if month_num <= `num_months' & !missing(month_num)
gen month_year = month_num

bysort item_code: egen p5 = pctile(price_per_unit), p(5)
bysort item_code: egen p95 = pctile(price_per_unit), p(95)
gen double price_w5 = price_per_unit
replace price_w5 = p5 if price_per_unit < p5 & !missing(p5)
replace price_w5 = p95 if price_per_unit > p95 & !missing(p95)
drop p5 p95

gen double ln_price = ln(price_w5)
gen byte treated = treat
drop if missing(treated)
gen byte post = (month_num >= 2)

* Competition grouping: SAME distance-decay measure as Figure 4a/b
* (store_competition_groups.dta from fig4ab_event_study_competition.do, run first),
* so the high/low split matches 4a/b.
capture confirm file "${dir_tables}/store_competition_groups.dta"
if _rc {
    di as error "Missing store_competition_groups.dta. Run fig4ab_event_study_competition.do first."
    exit 601
}
capture drop high_comp
merge m:1 sheet_index using "${dir_tables}/store_competition_groups.dta", keepusing(high_comp) keep(3) nogen

tempfile base
save `base'

*-------------------------------------------------------------------------------
* Per-store estimates + pooled high / pooled low
*-------------------------------------------------------------------------------
tempfile res
postfile P double sheet_index byte high_comp double pct double lo double hi byte is_pooled ///
    using `res', replace

levelsof sheet_index, local(stores)
foreach s of local stores {
    preserve
        keep if sheet_index == `s'
        count
        local n = r(N)
        egen tag_item = tag(item_code)
        count if tag_item
        local n_items = r(N)
        drop tag_item
        quietly summarize treated
        local treat_sd = r(sd)
        quietly summarize high_comp
        local hc = r(mean)
        if (`n' >= 10 & `n_items' >= 3 & `treat_sd' > 0) {
            cap quietly reghdfe ln_price i.treated##i.post, absorb(month_year item_code) vce(robust)
            if !_rc {
                local b = _b[1.treated#1.post]
                local se = _se[1.treated#1.post]
                local t = invttail(e(df_r), 0.025)
                local pct = 100*(exp(`b')-1)
                local lo  = 100*(exp(`b'-`t'*`se')-1)
                local hi  = 100*(exp(`b'+`t'*`se')-1)
                post P (`s') (`hc') (`pct') (`lo') (`hi') (0)
            }
        }
    restore
}

foreach g in 1 0 {
    preserve
        keep if high_comp == `g'
        count
        if r(N) > 0 {
            cap quietly reghdfe ln_price i.treated##i.post, absorb(sheet_index month_year item_code) vce(cluster item_code)
            if !_rc {
                local b = _b[1.treated#1.post]
                local se = _se[1.treated#1.post]
                local t = invttail(e(df_r), 0.025)
                local pct = 100*(exp(`b')-1)
                local lo  = 100*(exp(`b'-`t'*`se')-1)
                local hi  = 100*(exp(`b'+`t'*`se')-1)
                post P (.) (`g') (`pct') (`lo') (`hi') (1)
            }
        }
    restore
}
postclose P

*-------------------------------------------------------------------------------
* Assemble plot data
*-------------------------------------------------------------------------------
use `res', clear

* Number per-store rows, high-competition first (matches the figure layout).
preserve
    keep if is_pooled == 0
    gsort -high_comp pct
    gen long store_num = _n
    tempfile stores_d
    save `stores_d'
restore
keep if is_pooled == 1
gen long store_num = .
append using `stores_d'

gen double y = store_num
replace y = -0.45 if is_pooled == 1 & high_comp == 1   // pooled high (upper)
replace y = -0.95 if is_pooled == 1 & high_comp == 0   // pooled low  (lower)

quietly count if is_pooled == 0
local ns = r(N)

* Pooled values for the vertical reference lines (missing if a group is absent)
local ph = .
local pl = .
quietly summarize pct if is_pooled == 1 & high_comp == 1
if r(N) > 0 local ph = r(mean)
quietly summarize pct if is_pooled == 1 & high_comp == 0
if r(N) > 0 local pl = r(mean)

* Build the y-axis label list (1..ns plus the Pooled row)
local ylab ""
forvalues i = 1/`ns' {
    local ylab "`ylab' `i'"
}
local ylab `"`ylab' -0.7 "Pooled""'

* Build reference lines only for pooled values that exist
local xlines ""
if !missing(`ph') local xlines `"`xlines' xline(`ph', lpattern(dash) lcolor("$my_blue*0.6") lwidth(thin))"'
if !missing(`pl') local xlines `"`xlines' xline(`pl', lpattern(dash) lcolor("$my_red*0.6") lwidth(thin))"'

save "${dir_tables}/figure4c_plot_data.dta", replace
export delimited using "${dir_tables}/figure4c_plot_data.csv", replace

*-------------------------------------------------------------------------------
* Plot
*-------------------------------------------------------------------------------
twoway ///
    (rcap lo hi y if is_pooled==0 & high_comp==1, horizontal lcolor("$my_blue") lwidth(medthin)) ///
    (scatter y pct if is_pooled==0 & high_comp==1, mcolor("$my_blue") msymbol(O) msize(medium)) ///
    (rcap lo hi y if is_pooled==0 & high_comp==0, horizontal lcolor("$my_red") lwidth(medthin)) ///
    (scatter y pct if is_pooled==0 & high_comp==0, mcolor("$my_red") msymbol(O) msize(medium)) ///
    (rcap lo hi y if is_pooled==1 & high_comp==1, horizontal lcolor("$my_blue") lwidth(medium)) ///
    (scatter y pct if is_pooled==1 & high_comp==1, mcolor("$my_blue") msymbol(D) msize(large)) ///
    (rcap lo hi y if is_pooled==1 & high_comp==0, horizontal lcolor("$my_red") lwidth(medium)) ///
    (scatter y pct if is_pooled==1 & high_comp==0, mcolor("$my_red") msymbol(D) msize(large)) ///
    , ///
    subtitle("Stop and Shop", size(medsmall)) ///
    xtitle("Price effect", size(small)) ytitle("") ///
    xscale(range(-32 12)) xlabel(-30 "-30%" -20 "-20%" -10 "-10%" 0 "0" 10 "10%", nogrid labsize(small)) ///
    ylabel(`ylab', nogrid angle(0) labsize(small)) yscale(range(-1.4 `=`ns'+0.6')) ///
    `xlines' ///
    yline(0.2, lpattern(dash) lcolor(gs10) lwidth(thin)) ///
    legend(order(2 "High competition" 4 "Low competition" 6 "Pooled high" 8 "Pooled low") ///
        rows(1) position(6) size(small) region(lcolor(gs12) fcolor(white))) ///
    plotregion(color(white)) graphregion(color(white)) ///
    xsize(8.8) ysize(5.2) name(fig4c, replace)

graph export "${dir_graphs}/figure_4c.png", replace width(2400)

di as result "Done. Figure 4c written to ${dir_graphs}/figure_4c.png"
