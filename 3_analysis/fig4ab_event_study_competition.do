/*==============================================================================
 fig4ab_event_study_competition.do
 VAT exemption pass-through and incidence (Papua New Guinea) — analysis

 PURPOSE : Competition (high vs low/mid) pass-through: Figure 4a event study
           (May-Oct 2025, unbalanced) and Figure 4b store-level pass-through
           distribution (May-Sep 2025, store TWFE). Competition is a
           distance-decay score from store lat/lng, proximity_i =
           sum_{j != i} exp(-d_km_ij / decay_km), top tertile = High; this wider
           distance measure is used for 4a/b only (4c and the maps use the R
           travel-time tertile). Three stores flagged as data-collection errors
           (Kwik Mart Tokarara, Eliseo Wholesale Gordons, RH Gordons) are dropped
           by identity from both panels.
 INPUTS  : ${final_stores}/POM_Prices_Long_Clean.dta (needs lat, lng); globals
           ${dir_graphs}, ${dir_tables}
 OUTPUTS : ${dir_graphs}/figure_4a.png, figure_4b.png;
           ${dir_tables}/store_competition_groups.dta (+ .csv) — consumed by
           fig4c_within_chain.do; plus store-level pass-through and plot-data
           intermediates (.dta/.csv) in ${dir_tables}
 DEPENDS : ${final_stores}/POM_Prices_Long_Clean.dta must exist. Must run BEFORE
           fig4c_within_chain.do, which reads store_competition_groups.dta.
 CALLED BY: main.do
==============================================================================*/

clear all
set more off

* ---- Parameters ----
local decay_km    = 2     // distance-decay length (km) for the proximity score
                          // (wider distance measure used for 4a/4b)
local panelb_xmax = 8     // 4b histogram x upper limit

local DATA "${final_stores}/POM_Prices_Long_Clean.dta"
local OUTD "${dir_tables}"
local OUTF "${dir_graphs}"

********************************************************************************
* 1. Reconstruct store proximity groups (Fig 4a/b)
*    Distance-decay competition score from store lat/lng:
*       proximity_i = sum_{j != i} exp(-d_km_ij / decay_km),  top tertile = High.
*    Author's note: Fig 4a/b use this wider distance measure rather than the R
*    travel-time tertile. Override for 4a/b only; 4c and the maps keep the R tertile.
********************************************************************************
use "`DATA'", clear
preserve
    keep sheet_index Supermarket lat lng
    duplicates drop
    drop if missing(sheet_index)
    isid sheet_index
    tempfile store_names
    save `store_names', replace

    keep sheet_index lat lng
    rename sheet_index sheet_i
    rename lat lat_i
    rename lng lng_i

    cross using `store_names'
    drop if sheet_i == sheet_index
    drop if missing(lat_i) | missing(lng_i) | missing(lat) | missing(lng)

    local pi = c(pi)
    gen double dlat = (lat - lat_i)*`pi'/180
    gen double dlng = (lng - lng_i)*`pi'/180
    gen double a = sin(dlat/2)^2 + cos(lat_i*`pi'/180)*cos(lat*`pi'/180)*sin(dlng/2)^2
    gen double d_km = 2*6371*asin(sqrt(a))
    gen double w = exp(-d_km/`decay_km')

    collapse (sum) proximity_score=w (min) nearest_km=d_km, by(sheet_i)
    rename sheet_i sheet_index
    merge 1:1 sheet_index using `store_names', keep(3) nogen

    xtile proximity_tertile = proximity_score, nq(3)
    label define proxter 1 "Low" 2 "Medium" 3 "High", replace
    label values proximity_tertile proxter

    gen byte high_comp = (proximity_tertile == 3)
    gen str22 competition_group = cond(high_comp==1, "High Competition", "Low/Mid Competition")

    order sheet_index Supermarket lat lng proximity_score nearest_km proximity_tertile high_comp competition_group
    save "`OUTD'/store_competition_groups.dta", replace
    export delimited using "`OUTD'/store_competition_groups.csv", replace
restore

********************************************************************************
* 2. Build Panel B store-level estimates and identify far-right outliers
********************************************************************************
use "`DATA'", clear
merge m:1 sheet_index using "`OUTD'/store_competition_groups.dta", keep(3) nogen

gen double price_per_unit = Price / quantity
drop if missing(price_per_unit) | price_per_unit <= 0

gen month_num = .
replace month_num = 1 if lower(strtrim(Month)) == "may"
replace month_num = 2 if inlist(lower(strtrim(Month)), "june", "jun")
replace month_num = 3 if inlist(lower(strtrim(Month)), "july", "jul")
replace month_num = 4 if inlist(lower(strtrim(Month)), "august", "aug")
replace month_num = 5 if inlist(lower(strtrim(Month)), "september", "sep")
keep if month_num <= 5 & !missing(month_num)
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

tempfile store_results
postfile H double sheet_index double twfe_effect double twfe_se double n_obs double n_items ///
    using `store_results', replace

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
        if (`n' >= 10 & `n_items' >= 3 & `treat_sd' > 0) {
            cap quietly reghdfe ln_price i.treated##i.post, absorb(month_year item_code) vce(robust)
            if !_rc {
                cap local b = _b[1.treated#1.post]
                cap local se = _se[1.treated#1.post]
                if !_rc post H (`s') (`b') (`se') (`n') (`n_items')
            }
        }
    restore
}
postclose H

use `store_results', clear
drop if missing(twfe_effect)
gen double pct_price_change = 100*(exp(twfe_effect)-1)
merge 1:1 sheet_index using "`OUTD'/store_competition_groups.dta", keep(3) nogen
* Drop the three stores the author flagged as data-collection errors (dropped
* "entirely" from both 4a and 4b): Kwik Mart Tokarara, Eliseo Wholesale Gordons,
* RH Gordons. Reported there at +14.5%, +11.2%, +6.3%. Dropped by identity, not
* by a threshold, so the rule does not depend on the recomputed point estimates.
gen byte drop_far_right_outlier = ///
    regexm(lower(Supermarket), "kwik mart tokarara") | ///
    regexm(lower(Supermarket), "eliseo wholesale")   | ///
    regexm(lower(Supermarket), "rh gordon")
order sheet_index Supermarket competition_group high_comp proximity_tertile pct_price_change twfe_effect twfe_se n_obs n_items drop_far_right_outlier
save "`OUTD'/store_pass_through_before_drop.dta", replace
export delimited using "`OUTD'/store_pass_through_before_drop.csv", replace

preserve
    keep if drop_far_right_outlier == 1
    gsort -pct_price_change
    save "`OUTD'/dropped_far_right_outlier_stores.dta", replace
    export delimited using "`OUTD'/dropped_far_right_outlier_stores.csv", replace
restore

keep if drop_far_right_outlier != 1
save "`OUTD'/figure4b_store_pass_through_final.dta", replace
export delimited using "`OUTD'/figure4b_store_pass_through_final.csv", replace

********************************************************************************
* 3. Panel A event study after dropping the same outlier stores
********************************************************************************
use "`DATA'", clear
merge m:1 sheet_index using "`OUTD'/store_competition_groups.dta", keep(3) nogen
merge m:1 sheet_index using "`OUTD'/dropped_far_right_outlier_stores.dta", keepusing(drop_far_right_outlier) nogen
replace drop_far_right_outlier = 0 if missing(drop_far_right_outlier)
drop if drop_far_right_outlier == 1

gen double price_per_unit = Price / quantity
drop if missing(price_per_unit) | price_per_unit <= 0

gen month_num = .
replace month_num = 1 if lower(strtrim(Month)) == "may"
replace month_num = 2 if inlist(lower(strtrim(Month)), "june", "jun")
replace month_num = 3 if inlist(lower(strtrim(Month)), "july", "jul")
replace month_num = 4 if inlist(lower(strtrim(Month)), "august", "aug")
replace month_num = 5 if inlist(lower(strtrim(Month)), "september", "sep")
replace month_num = 6 if inlist(lower(strtrim(Month)), "october", "oct")
keep if month_num <= 6 & !missing(month_num)
gen month_year = month_num

bysort item_code: egen p5 = pctile(price_per_unit), p(5)
bysort item_code: egen p95 = pctile(price_per_unit), p(95)
gen double price_w5 = price_per_unit
replace price_w5 = p5 if price_per_unit < p5 & !missing(p5)
replace price_w5 = p95 if price_per_unit > p95 & !missing(p95)
drop p5 p95

gen byte treated = treat
drop if missing(treated)
gen byte post = (month_num >= 2)
gen byte treatedpost = (treated == 1 & post == 1)

bysort item_code sheet_index: egen double price_may25 = mean(cond(month_num == 1, price_w5, .))
bysort item_code: egen double price_may25_overall = mean(cond(month_num == 1, price_w5, .))
replace price_may25 = price_may25_overall if missing(price_may25)
drop price_may25_overall
gen double r_price = price_w5 / price_may25
drop if missing(r_price)

gen byte event_time_shift = month_num - 1   // May=0, Jun=1, ..., Oct=5

tempfile panela_base
save `panela_base', replace

tempfile fig4a_results
postfile A byte high_comp str22 competition_group double event_time str12 label ///
    double coef double se double ci_low double ci_high byte is_pooled ///
    using `fig4a_results', replace

foreach g in 1 0 {
    use `panela_base', clear
    keep if high_comp == `g'
    local glabel = cond(`g'==1, "High Competition", "Low/Mid Competition")
    post A (`g') ("`glabel'") (0) ("May 25") (0) (0) (0) (0) (0)
    quietly reghdfe r_price ib0.event_time_shift##i.treated, absorb(sheet_index month_year item_code) vce(cluster item_code)
    local tcrit = invttail(e(df_r), 0.025)
    forvalues k = 1/5 {
        local et = `k'
        local lab = cond(`k'==1, "Jun 25", cond(`k'==2, "Jul 25", cond(`k'==3, "Aug 25", cond(`k'==4, "Sep 25", "Oct 25"))))
        local cname "`k'.event_time_shift#1.treated"
        local b = _b[`cname']
        local s = _se[`cname']
        local lo = `b' - `tcrit'*`s'
        local hi = `b' + `tcrit'*`s'
        post A (`g') ("`glabel'") (`et') ("`lab'") (`b') (`s') (`lo') (`hi') (0)
    }
    quietly reghdfe r_price treatedpost, absorb(sheet_index month_year item_code) vce(cluster item_code)
    local tcrit = invttail(e(df_r), 0.025)
    local b = _b[treatedpost]
    local s = _se[treatedpost]
    local lo = `b' - `tcrit'*`s'
    local hi = `b' + `tcrit'*`s'
    post A (`g') ("`glabel'") (6.4) ("Post Avg.") (`b') (`s') (`lo') (`hi') (1)
}
postclose A

use `fig4a_results', clear
gen double coef_pp = 100*coef
gen double ci_low_pp = 100*ci_low
gen double ci_high_pp = 100*ci_high
gen double se_pp = 100*se
save "`OUTD'/figure4a_plot_data_final.dta", replace
export delimited using "`OUTD'/figure4a_plot_data_final.csv", replace

preserve
    keep competition_group label coef_pp ci_low_pp ci_high_pp se_pp is_pooled
    export delimited using "`OUTD'/figure4a_coefficients_pp.csv", replace
restore

********************************************************************************
* 4. Plot final Figure 4
********************************************************************************
use "`OUTD'/figure4a_plot_data_final.dta", clear

gen double x = .
replace x = event_time - 1 if is_pooled == 0    // May=-1, Jun=0, ..., Oct=4
replace x = 5.6 if is_pooled == 1

gen double x_hi = x - 0.10 if high_comp == 1
gen double x_lo = x + 0.10 if high_comp == 0

twoway ///
    (rcap ci_low_pp ci_high_pp x_hi if high_comp==1 & is_pooled==0, lcolor("20 97 128") lwidth(thin)) ///
    (connected coef_pp x_hi if high_comp==1 & is_pooled==0, sort lcolor("20 97 128") mcolor("20 97 128") msymbol(O) msize(small) lwidth(medthin)) ///
    (rcap ci_low_pp ci_high_pp x_lo if high_comp==0 & is_pooled==0, lcolor("150 39 23") lwidth(thin)) ///
    (connected coef_pp x_lo if high_comp==0 & is_pooled==0, sort lcolor("150 39 23") mcolor("150 39 23") msymbol(T) msize(small) lwidth(medthin)) ///
    (rcap ci_low_pp ci_high_pp x_hi if high_comp==1 & is_pooled==1, lcolor("20 97 128") lwidth(thin)) ///
    (scatter coef_pp x_hi if high_comp==1 & is_pooled==1, mcolor("20 97 128") msymbol(O) msize(small)) ///
    (rcap ci_low_pp ci_high_pp x_lo if high_comp==0 & is_pooled==1, lcolor("150 39 23") lwidth(thin)) ///
    (scatter coef_pp x_lo if high_comp==0 & is_pooled==1, mcolor("150 39 23") msymbol(T) msize(small)) ///
    , ///
    title("") ///
    ytitle("Price effect (p.p.)", size(small)) xtitle("") ///
    yscale(range(-32 16)) ylabel(-30(10)10, nogrid angle(0) labsize(small)) ///
    xscale(range(-1.6 6.1)) ///
    xlabel(-1 "May 25" 0 "Jun 25" 1 "Jul 25" 2 "Aug 25" 3 "Sep 25" 4 "Oct 25" 5.6 "Post Avg.", angle(45) labsize(small)) ///
    yline(0, lcolor(gs8) lwidth(thin)) ///
    yline(-9.1, lpattern(dash) lcolor(gs8) lwidth(thin)) ///
    xline(-0.5, lpattern(dash) lcolor(gs8) lwidth(thin)) ///
    xline(4.75, lpattern(dot) lcolor(gs12) lwidth(thin)) ///
    text(11.6 0.05 "VAT exemptions", size(vsmall) color(gs6) box bcolor(white) margin(small)) ///
    text(-12.7 2.6 "Full pass through {&Delta}p: -9.1 p.p.", size(small) color(gs6)) ///
    legend(order(2 "High Competition" 4 "Low/Mid Competition") rows(1) position(6) ring(0) size(small) region(lcolor(gs12) fcolor(white))) ///
    plotregion(color(white)) graphregion(color(white)) ///
    xsize(8.8) ysize(4.7) ///
    name(fig4a, replace)

graph export "`OUTF'/figure_4a.png", replace width(2400)

use "`OUTD'/figure4b_store_pass_through_final.dta", clear

histogram pct_price_change if high_comp == 1, ///
    start(-20) width(2) percent ///
    xscale(range(-20 `panelb_xmax')) xlabel(-20(5)5, nogrid labsize(large)) ///
    yscale(range(0 32)) ylabel(0(10)30, nogrid angle(0) labsize(large)) ///
    xline(-9.1, lcolor(black) lpattern(dash) lwidth(thin)) ///
    fcolor("20 97 128") lcolor("20 97 128") ///
    title("(a) High competition", size(large) color(black)) ///
    xtitle("Price change relative to control items (%)", size(large)) ///
    ytitle("Share of stores", size(large)) ///
    plotregion(color(white)) graphregion(color(white)) ///
    name(hist_hi, replace)

histogram pct_price_change if high_comp == 0, ///
    start(-20) width(2) percent ///
    xscale(range(-20 `panelb_xmax')) xlabel(-20(5)5, nogrid labsize(large)) ///
    yscale(range(0 32)) ylabel(0(10)30, nogrid angle(0) labsize(large)) ///
    xline(-9.1, lcolor(black) lpattern(dash) lwidth(thin)) ///
    fcolor("20 97 128") lcolor("20 97 128") ///
    title("(b) Low/Mid competition", size(large) color(black)) ///
    xtitle("Price change relative to control items (%)", size(large)) ///
    ytitle("") ///
    plotregion(color(white)) graphregion(color(white)) ///
    name(hist_lo, replace)

graph combine hist_hi hist_lo, rows(1) ///
    title("") ///
    graphregion(color(white)) xsize(8.8) ysize(3.9) ///
    imargin(medium) name(fig4b, replace)

graph export "`OUTF'/figure_4b.png", replace width(2400)
