/*==============================================================================
 figA37_store_distribution.do
 VAT exemption pass-through and incidence (Papua New Guinea) — analysis

 PURPOSE : Store-by-store DiD (TWFE) pass-through estimates; distribution of
           store-level pass-through by chain vs independent (Figure A37) plus
           t-tests (chain vs independent, high vs low competition).
 INPUTS  : ${final_stores}/POM_Prices_Long_Clean.dta; globals ${dir_graphs},
           ${dir_logs}, colors ${my_blue}, ${my_red}
 OUTPUTS : ${dir_graphs}/figure_a37.png
 DEPENDS : ${final_stores}/POM_Prices_Long_Clean.dta must exist
 CALLED BY: main.do
==============================================================================*/

clear all
set more off

********************************************************************************
* 1. SETUP & PARAMETERS
********************************************************************************

* Color scheme (consistent with other scripts)
global my_blue "20 97 128"
global my_red "150 39 23"
global my_green "20 106 128"
global my_orange "253 174 97"
global my_purple "93 87 107"

* Analysis parameters
local num_months = 5   

********************************************************************************
* 2. DATA PREPARATION
********************************************************************************

* Initialize results holder
tempfile results

* Load Data
use "${final_stores}/POM_Prices_Long_Clean.dta", clear

* --- Variable Engineering ---
gen price_per_unit = Price / quantity
drop if missing(price_per_unit) | price_per_unit <= 0

* Numeric Month Conversion
gen month_num = .
replace month_num = 1 if Month == "May"
replace month_num = 2 if Month == "June"
replace month_num = 3 if Month == "July"
replace month_num = 4 if Month == "August"
replace month_num = 5 if Month == "September"
keep if month_num <= `num_months' & !missing(month_num)
gen month_year = month_num

* --- Winsorize (Outlier Protection) ---
bysort item_code: egen p5 = pctile(price_per_unit), p(5)
bysort item_code: egen p95 = pctile(price_per_unit), p(95)
gen price_w5 = price_per_unit
replace price_w5 = p5 if price_per_unit < p5
replace price_w5 = p95 if price_per_unit > p95
gen ln_price = ln(price_w5)

* --- Treatment Setup ---
rename treat treated
gen post = (month_num >= 2 & month_num != .)

* --- Save Store Characteristics ---
preserve
    keep sheet_index Supermarket store_type proximity_tertile
    duplicates drop
    isid sheet_index
    tempfile store_info
    save `store_info', replace
restore

********************************************************************************
* 3. STORE-BY-STORE REGRESSION LOOP
********************************************************************************

* Prepare results file structure
preserve
    clear
    gen sheet_index = .
    gen twfe_effect = .
    gen twfe_se = .
    gen n_obs = .
    gen n_items = .
    save `results', replace
restore

levelsof sheet_index, local(stores)
local n_stores: word count `stores'
local counter = 0

di as text "--- Starting Store-by-Store Regressions (Total: `n_stores') ---"

foreach store in `stores' {
    local counter = `counter' + 1
    
    qui {
        preserve
        keep if sheet_index == `store'
        
        * Check Sample Size
        count
        local n = r(N)
        distinct item_code
        local n_items = r(ndistinct)
        
        * Check Variation
        sum treated
        local treat_sd = r(sd)
        
        if `n' >= 10 & `n_items' >= 3 & `treat_sd' > 0 {
            
            cap reghdfe ln_price i.treated##i.post, ///
                absorb(month_year item_code) vce(robust)
            
            if _rc == 0 {
                cap {
                    local coef = _b[1.treated#1.post]
                    local se   = _se[1.treated#1.post]
                    
                    restore 
                    preserve
                    clear
                    set obs 1
                    gen sheet_index = `store'
                    gen twfe_effect = `coef'
                    gen twfe_se = `se'
                    gen n_obs = `n'
                    gen n_items = `n_items'
                    
                    append using `results'
                    save `results', replace
                    restore
                }
                if _rc != 0 restore 
            }
            else {
                restore
            }
        }
        else {
            restore
        }
    }
    
    if mod(`counter', 10) == 0 di "Processed `counter' of `n_stores'..."
}

********************************************************************************
* 4. PROCESS RESULTS & DEFINE GROUPS
********************************************************************************

use `results', clear
drop if missing(twfe_effect)

* CORRECT CONVERSION: Exact percentage change from Log
gen pct_price_change = 100 * (exp(twfe_effect) - 1)

* Merge characteristics
merge 1:1 sheet_index using `store_info', keep(3) nogen

* --- GROUP DEFINITIONS ---

* 1. Define Chain vs Independent
capture confirm numeric variable store_type
if _rc == 0 {
    decode store_type, gen(store_type_str)
}
else {
    gen store_type_str = store_type
}

gen chain_group = ""
replace chain_group = "Chain" if strpos(store_type_str, "Chain") > 0
replace chain_group = "Independent" if strpos(store_type_str, "Independent") > 0
replace chain_group = "Independent" if chain_group == ""

* 2. Define Proximity (High vs Low/Mid)
capture confirm numeric variable proximity_tertile
if _rc == 0 {
    decode proximity_tertile, gen(prox_str)
}
else {
    gen prox_str = proximity_tertile
}

gen proximity_group = "Low/Mid Competition"
replace proximity_group = "High Competition" if prox_str == "High" | prox_str == "3"

********************************************************************************
* 5. STATISTICAL TESTS
********************************************************************************

di as result "--- T-Test: Chains vs Independents ---"
ttest pct_price_change, by(chain_group) unequal

di as result "--- T-Test: High vs Low Competition ---"
ttest pct_price_change, by(proximity_group) unequal

********************************************************************************
* 6. FINAL VISUALIZATIONS 
********************************************************************************

local min_x = -35
local max_x = 0

********************************************************************************
* 6.3 DISTRIBUTION BY CHAIN vs INDEPENDENT -> Figure A37 (store_pt_chains_hist.pdf)
********************************************************************************

gen is_chain = (chain_group == "Chain") if !missing(chain_group)
label define is_chain_lbl 1 "(a) Chain" 0 "(b) Independent"
label values is_chain is_chain_lbl

local opts `"color("$my_blue") width(2) percent xlabel(-25(5)0, nogrid) ylabel(0(10)30, nogrid) xline(-9.1, lcolor(gs6) lpattern(dash)) graphregion(color(white)) plotregion(color(white))"'

histogram pct_price_change if is_chain == 1 & pct_price_change <= 0, ///
    title("(a) Chain") xtitle("Price change relative to control items (%)") ytitle("Share of stores") `opts'
graph save "$dir_logs/g1.gph", replace

histogram pct_price_change if is_chain == 0 & pct_price_change <= 0, ///
    title("(b) Independent") xtitle("Price change relative to control items (%)") ytitle("") `opts'
graph save "$dir_logs/g2.gph", replace

graph combine "$dir_logs/g1.gph" "$dir_logs/g2.gph", rows(1) graphregion(color(white))
graph export "$dir_graphs/figure_a37.png", replace

* clean up temporary combined-graph files
cap erase "$dir_logs/g1.gph"
cap erase "$dir_logs/g2.gph"
