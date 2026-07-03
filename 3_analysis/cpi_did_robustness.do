/*==============================================================================
 cpi_did_robustness.do
 VAT exemption pass-through and incidence (Papua New Guinea) — analysis

 PURPOSE : DiD robustness on the quarterly NSO CPI panel — pass-through estimates
           across three control-group specifications, the CPI event-study figure,
           and the raw price-index trends figure.
 INPUTS  : ${final_nso}/cpi_quarterly_panel.dta (built by
           1_data_prep/07_build_cpi_panel.do)
 OUTPUTS : ${dir_tables}/cpi_did_table.tex;
           ${dir_graphs}/figure_a12.png (CPI event-study) +
           ${dir_tables}/cpi_event_study_coefficients.dta;
           ${dir_graphs}/figure_a13.png (CPI price-index trends)
 DEPENDS : 1_data_prep/07_build_cpi_panel.do must have run to build the CPI panel
 CALLED BY: main.do
==============================================================================*/

set more off

* standalone fallbacks (no effect when run from main.do)
if "${dir_graphs}" == "" global dir_graphs "."
if "${dir_tables}" == "" global dir_tables "."

* package palette (mirrors 01_globals; same as the other pass-through / event-study figures)
global my_blue   "20 97 128"
global my_red    "150 39 23"
global my_green  "0 166 118"
global my_purple "93 87 107"

********************************************************************************
* A. DIFFERENCE-IN-DIFFERENCES
********************************************************************************
use "${final_nso}/cpi_quarterly_panel.dta", clear

* Restrict to Jun 2022 onwards for DiD analysis
keep if quarter >= 41

********************************************************************************
* SPECIFICATION 1: Treatment (10) vs All Comparable Food (28)
********************************************************************************

di _n as txt _dup(72) "="
di as res "  SPECIFICATION 1: Treatment (10) vs All Comparable Food (28)"
di as txt _dup(72) "="

preserve
keep if allcpi == 0

* Model 1a: Pooled OLS
di _n as res "  Model 1a: Pooled OLS"
reg price_index treatment post did, vce(cluster item_id)
estimates store m1a

* Model 1b: Item Fixed Effects
di _n as res "  Model 1b: Item FE"
areg price_index post did, absorb(item_id) vce(cluster item_id)
estimates store m1b

* Model 1c: Two-Way FE (Item + Quarter)
di _n as res "  Model 1c: Two-Way FE (Item + Quarter)"
reghdfe price_index did, absorb(item_id qdate) vce(cluster item_id)
estimates store m1c

restore

********************************************************************************
* SPECIFICATION 2: Treatment (10) vs Curated Comparables (6)
********************************************************************************

di _n as txt _dup(72) "="
di as res "  SPECIFICATION 2: Treatment (10) vs Curated Comparables (6)"
di as txt _dup(72) "="

preserve
keep if treatment == 1 | curated_ctrl == 1

* Model 2a: Pooled OLS
di _n as res "  Model 2a: Pooled OLS"
reg price_index treatment post did, vce(cluster item_id)
estimates store m2a

* Model 2b: Item FE
di _n as res "  Model 2b: Item FE"
areg price_index post did, absorb(item_id) vce(cluster item_id)
estimates store m2b

* Model 2c: Two-Way FE
di _n as res "  Model 2c: Two-Way FE (Item + Quarter)"
reghdfe price_index did, absorb(item_id qdate) vce(cluster item_id)
estimates store m2c

restore

********************************************************************************
* SPECIFICATION 3: Treatment (10) vs Full CPI Basket
********************************************************************************

di _n as txt _dup(72) "="
di as res "  SPECIFICATION 3: Treatment (10) vs Full CPI Basket"
di as txt _dup(72) "="

preserve
keep if treatment == 1 | allcpi == 1

* Model 3a: Pooled OLS
di _n as res "  Model 3a: Pooled OLS"
reg price_index treatment post did, vce(cluster item_id)
estimates store m3a

* Model 3b: Two-Way FE
di _n as res "  Model 3b: Two-Way FE (Item + Quarter)"
reghdfe price_index did, absorb(item_id qdate) vce(cluster item_id)
estimates store m3b

restore

********************************************************************************
* COMBINED RESULTS TABLE
********************************************************************************

di _n as txt _dup(72) "="
di as res "  TABLE: DiD Estimates Across Specifications"
di as txt _dup(72) "="

esttab m1a m1c m2a m2c m3a m3b using "${dir_tables}/cpi_did_table.tex",     ///
    replace se star(* 0.10 ** 0.05 *** 0.01)                        ///
    keep(did)                                                        ///
    coeflabels(did "Treatment $\times$ Post")                        ///
    mtitles("Pooled" "TWFE" "Pooled" "TWFE" "Pooled" "TWFE")        ///
    mgroups("vs Comparable (28)" "vs Curated (6)" "vs CPI",         ///
        pattern(1 0 1 0 1 0)                                         ///
        prefix(\multicolumn{@span}{c}{) suffix(})                    ///
        span erepeat(\cmidrule(lr){@span}))                          ///
    scalars("N Observations" "r2_a Adj. R-sq")                      ///
    nonotes addnotes("Standard errors clustered by item in parentheses." ///
        "* p<0.10, ** p<0.05, *** p<0.01."                          ///
        "Sample: June 2022 -- December 2025. Treatment date: March 2025.") ///
    booktabs nonumber label

* Also print to console
esttab m1a m1c m2a m2c m3a m3b,                                     ///
    se star(* 0.10 ** 0.05 *** 0.01)                                 ///
    keep(did)                                                        ///
    coeflabels(did "Treatment x Post")                               ///
    mtitles("Pooled" "TWFE" "Pooled" "TWFE" "Pooled" "TWFE")        ///
    title("DiD Estimates: Treatment Effect on Price Index")

di _n as res "  Table saved to: ${dir_tables}/cpi_did_table.tex"

********************************************************************************
* B. EVENT STUDY
********************************************************************************
use "${final_nso}/cpi_quarterly_panel.dta", clear

* Restrict to Jun 2022 onwards for event study
keep if quarter >= 41

********************************************************************************
* GENERATE TREATMENT × QUARTER INTERACTIONS
********************************************************************************

* Create interactions for each quarter with treatment
* Omit quarter 52 (March 2025) as the reference period
forvalues q = 41/55 {
    gen treat_q`q' = treatment * (quarter == `q')
}

********************************************************************************
* PANEL 1: vs All Comparable Food (28 items)
********************************************************************************

preserve
keep if allcpi == 0

reghdfe price_index treat_q41-treat_q51 treat_q53-treat_q55, ///
    absorb(item_id qdate) vce(cluster item_id)

* Store coefficients
tempfile es_food
postfile hdl_food str20 ctrl int(quarter) float(coef se ci_lo ci_hi) ///
    using `es_food'

local j = 1
forvalues q = 41/55 {
    if `q' == 52 {
        post hdl_food ("Comparable (28)") (`q') (0) (0) (0) (0)
    }
    else {
        local coef = _b[treat_q`q']
        local se   = _se[treat_q`q']
        local lo   = `coef' - 1.96 * `se'
        local hi   = `coef' + 1.96 * `se'
        post hdl_food ("Comparable (28)") (`q') (`coef') (`se') (`lo') (`hi')
        local j = `j' + 1
    }
}
postclose hdl_food
restore

********************************************************************************
* PANEL 2: vs Curated Comparables (6 items)
********************************************************************************

preserve
keep if treatment == 1 | curated_ctrl == 1

reghdfe price_index treat_q41-treat_q51 treat_q53-treat_q55, ///
    absorb(item_id qdate) vce(cluster item_id)

tempfile es_curated
postfile hdl_cur str20 ctrl int(quarter) float(coef se ci_lo ci_hi) ///
    using `es_curated'

local j = 1
forvalues q = 41/55 {
    if `q' == 52 {
        post hdl_cur ("Curated (6)") (`q') (0) (0) (0) (0)
    }
    else {
        local coef = _b[treat_q`q']
        local se   = _se[treat_q`q']
        local lo   = `coef' - 1.96 * `se'
        local hi   = `coef' + 1.96 * `se'
        post hdl_cur ("Curated (6)") (`q') (`coef') (`se') (`lo') (`hi')
        local j = `j' + 1
    }
}
postclose hdl_cur
restore

********************************************************************************
* PANEL 3: vs All CPI
********************************************************************************

preserve
keep if treatment == 1 | allcpi == 1

reghdfe price_index treat_q41-treat_q51 treat_q53-treat_q55, ///
    absorb(item_id qdate) vce(cluster item_id)

tempfile es_cpi
postfile hdl_cpi str20 ctrl int(quarter) float(coef se ci_lo ci_hi) ///
    using `es_cpi'

local j = 1
forvalues q = 41/55 {
    if `q' == 52 {
        post hdl_cpi ("All CPI") (`q') (0) (0) (0) (0)
    }
    else {
        local coef = _b[treat_q`q']
        local se   = _se[treat_q`q']
        local lo   = `coef' - 1.96 * `se'
        local hi   = `coef' + 1.96 * `se'
        post hdl_cpi ("All CPI") (`q') (`coef') (`se') (`lo') (`hi')
        local j = `j' + 1
    }
}
postclose hdl_cpi
restore

drop treat_q*

********************************************************************************
* COMBINE AND PLOT
********************************************************************************

use `es_food', clear
append using `es_curated'
append using `es_cpi'

gen qdate = tq(2012q2) + quarter - 1
format qdate %tq

* offset each group's spikes so they do not overlap (Fig 3 convention)
gen double qoff = qdate
replace qoff = qdate - 0.15 if ctrl == "Comparable (28)"
replace qoff = qdate + 0.15 if ctrl == "All CPI"
quietly summarize ci_hi
local ytext = r(max)

* ── Event study figure ────────────────────────────────────────────────────────
twoway (rcap ci_lo ci_hi qoff if ctrl == "Comparable (28)", lcolor("$my_green") lwidth(medthin) msize(medsmall)) ///
       (connected coef qoff if ctrl == "Comparable (28)", lcolor("$my_green") mcolor("$my_green") msymbol(O) msize(small) lwidth(medthick)) ///
       (rcap ci_lo ci_hi qoff if ctrl == "Curated (6)", lcolor("$my_red") lwidth(medthin) msize(medsmall)) ///
       (connected coef qoff if ctrl == "Curated (6)", lcolor("$my_red") mcolor("$my_red") msymbol(D) msize(small) lwidth(medthick) lpattern(dash)) ///
       (rcap ci_lo ci_hi qoff if ctrl == "All CPI", lcolor("$my_purple") lwidth(medthin) msize(medsmall)) ///
       (connected coef qoff if ctrl == "All CPI", lcolor("$my_purple") mcolor("$my_purple") msymbol(T) msize(small) lwidth(medthick) lpattern(dash_dot)) ///
    , title("Quarterly Pass-through of VAT Exemptions: Event Study by Control Group", size(medsmall)) ///
      yline(0, lcolor(gs8)) ///
      xline(`=tq(2025q1)+0.5', lpattern(dash) lcolor(gs8)) ///
      ytitle("DiD coefficient (index points)") xtitle("") ///
      ylabel(, nogrid) xlabel(, angle(45) format(%tq) nogrid) ///
      text(`ytext' `=tq(2025q1)+0.5' "VAT exemptions", size(small) color(gs6) box bcolor(white) lcolor(gs6) placement(w)) ///
      legend(order(2 "vs All Comparable Food (28)" 4 "vs Curated Comparables (6)" 6 "vs All CPI Groups") ///
             col(1) pos(7) ring(0) region(lstyle(none)) size(small)) ///
      graphregion(color(white)) plotregion(color(white))

graph export "${dir_graphs}/figure_a12.png", replace width(2400)

* ── Save coefficient dataset ─────────────────────────────────────────────────
save "${dir_tables}/cpi_event_study_coefficients.dta", replace

* ── Print coefficient table ───────────────────────────────────────────────────
di _n as txt _dup(78) "="
di as res "  Event Study Coefficients (reference = March 2025)"
di as txt _dup(78) "="
di as txt "  " _dup(74) "-"
di as txt "  Control Group       Quarter     Coef       SE      [95% CI]"
di as txt "  " _dup(74) "-"

levelsof ctrl, local(groups)
foreach g of local groups {
    forvalues q = 41/55 {
        su coef if ctrl == "`g'" & quarter == `q', meanonly
        local c = r(mean)
        su se if ctrl == "`g'" & quarter == `q', meanonly
        local s = r(mean)
        su ci_lo if ctrl == "`g'" & quarter == `q', meanonly
        local lo = r(mean)
        su ci_hi if ctrl == "`g'" & quarter == `q', meanonly
        local hi = r(mean)
        local qlbl: display %tq tq(2012q2) + `q' - 1
        if `q' == 52 {
            di as txt "  `g'" _col(24) "`qlbl'" ///
                _col(36) as res "(reference)"
        }
        else {
            di as txt "  `g'" _col(24) "`qlbl'" ///
                as res _col(36) %8.3f `c' %10.3f `s' ///
                "   [" %8.2f `lo' "," %8.2f `hi' "]"
        }
    }
    di as txt "  " _dup(74) "-"
}

********************************************************************************
* C. RAW PRICE-INDEX TRENDS
********************************************************************************
use "${final_nso}/cpi_quarterly_panel.dta", clear

********************************************************************************
* COMPUTE GROUP MEANS BY QUARTER
********************************************************************************

* Treatment group mean
preserve
keep if treatment == 1
collapse (mean) treat_mean = price_index, by(qdate)
tempfile t_means
save `t_means'
restore

* All comparable food mean (28 items)
preserve
keep if treatment == 0 & allcpi == 0
collapse (mean) comp_mean = price_index, by(qdate)
tempfile c_means
save `c_means'
restore

* Curated comparables mean (6 items)
preserve
keep if curated_ctrl == 1
collapse (mean) curated_mean = price_index, by(qdate)
tempfile cu_means
save `cu_means'
restore

* All CPI (single series)
preserve
keep if allcpi == 1
rename price_index cpi_mean
keep qdate cpi_mean
tempfile cpi_means
save `cpi_means'
restore

* Merge all series
use `t_means', clear
merge 1:1 qdate using `c_means',  nogen
merge 1:1 qdate using `cu_means', nogen
merge 1:1 qdate using `cpi_means', nogen

* label anchor near the top of the plotted range
egen double _ymax = rowmax(treat_mean curated_mean comp_mean cpi_mean)
quietly summarize _ymax
local ytext = r(max)
drop _ymax

* ── Price index figure ────────────────────────────────────────────────────────
twoway (connected treat_mean qdate, lcolor("$my_blue") mcolor("$my_blue") msymbol(O) msize(small) lpattern(solid) lwidth(medthick)) ///
       (connected curated_mean qdate, lcolor("$my_red") mcolor("$my_red") msymbol(D) msize(small) lpattern(dash) lwidth(medthick)) ///
       (connected comp_mean qdate, lcolor("$my_green") mcolor("$my_green") msymbol(S) msize(small) lpattern(solid) lwidth(medthick)) ///
       (connected cpi_mean qdate, lcolor("$my_purple") mcolor("$my_purple") msymbol(T) msize(small) lpattern(dash_dot) lwidth(medthick)) ///
    , title("Price Index Trends for VAT-Exempt and Control CPI Items", size(medsmall)) ///
      xline(`=tq(2025q1)+0.5', lpattern(dash) lcolor(gs8)) ///
      yline(100, lcolor(gs13) lwidth(vthin)) ///
      ytitle("Price index (Jun 2012 = 100)") xtitle("") ///
      ylabel(, nogrid) xlabel(, angle(45) format(%tq) nogrid) ///
      text(`ytext' `=tq(2025q1)+0.5' "VAT exemptions", size(small) color(gs6) box bcolor(white) lcolor(gs6) placement(w)) ///
      legend(order(1 "Treatment Group (10)" 2 "Curated Comparables (6)" 3 "All Comparable Food (28)" 4 "All CPI Groups") ///
             col(1) pos(11) ring(0) region(lstyle(none)) size(small)) ///
      graphregion(color(white)) plotregion(color(white))

graph export "${dir_graphs}/figure_a13.png", replace width(2400)

* ── Print final values ────────────────────────────────────────────────────────
di _n as txt _dup(72) "="
di as res "  Price Index Values — December 2025"
di as txt _dup(72) "="
su treat_mean if qdate == tq(2025q4), meanonly
di as txt "  Treatment Group (10):       " as res %6.1f r(mean)
su curated_mean if qdate == tq(2025q4), meanonly
di as txt "  Curated Comparables (6):    " as res %6.1f r(mean)
su comp_mean if qdate == tq(2025q4), meanonly
di as txt "  All Comparable Food (28):   " as res %6.1f r(mean)
su cpi_mean if qdate == tq(2025q4), meanonly
di as txt "  All CPI Groups:             " as res %6.1f r(mean)
di as txt _dup(72) "="
