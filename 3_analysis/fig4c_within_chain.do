/*==============================================================================
 fig4c_within_chain.do
 VAT exemption pass-through (Papua New Guinea) — Figure 4c (Stop and Shop)

 PURPOSE : Per-store pass-through within Stop and Shop from one regression
           (i.sheet_index#c.treatedpost), colored by the median proximity split,
           plus pooled high and pooled low. Coefficient on r_price plotted in
           percentage points.
 INPUTS  : ${final_stores}/POM_Prices_Long_Clean.csv (needs treat_good,
           proximity_binary from fig1_store_proximity_map.R)
 OUTPUTS : ${dir_graphs}/figure_4c.png
           ${dir_tables}/store_passthrough_estimates.csv
 DEPENDS : fig1_store_proximity_map.R (writes proximity_binary)
 CALLED BY: main.do
==============================================================================*/

clear all
set more off
if "${my_blue}" == "" global my_blue "20 97 128"
if "${my_red}"  == "" global my_red  "150 39 23"

import delimited using "${final_stores}/POM_Prices_Long_Clean.csv", clear varnames(1)

* chain identifier
gen chain = ""
replace chain = "Eliseo"        if regexm(supermarket, "[Ee]lis[ei]o")
replace chain = "Stop and Shop" if regexm(supermarket, "[Ss]top") & regexm(supermarket, "[Ss]hop")
replace chain = "Stop and Shop" if regexm(supermarket, "SNS")
replace chain = "RH"            if regexm(supermarket, "^RH ")
replace chain = "Foodworld"     if regexm(supermarket, "[Ff]ood[Ww]orld")
replace chain = "SVS"           if regexm(supermarket, "^SVS")
replace chain = "Independent"   if chain == ""

* variables
gen price_per_unit = price / quantity
drop if missing(price_per_unit) | price_per_unit <= 0

gen month_num = .
replace month_num = 1 if month == "May"
replace month_num = 2 if month == "June"
replace month_num = 3 if month == "July"
replace month_num = 4 if month == "August"
replace month_num = 5 if month == "September"
replace month_num = 6 if month == "October"
keep if month_num <= 5 & !missing(month_num)

bysort item_code: egen p5 = pctile(price_per_unit), p(5)
bysort item_code: egen p95 = pctile(price_per_unit), p(95)
gen price_w5 = price_per_unit
replace price_w5 = p5 if price_per_unit < p5
replace price_w5 = p95 if price_per_unit > p95
drop p5 p95

gen treated = treat_good
keep if treated != .
gen post = (month_num >= 2)
gen treatedpost = treated * post

bysort item_code sheet_index: egen price_may = mean(cond(month_num == 1, price_w5, .))
bysort item_code: egen price_may_all = mean(cond(month_num == 1, price_w5, .))
replace price_may = price_may_all if missing(price_may)
gen r_price = price_w5 / price_may
drop if missing(r_price)

gen high_prox = (proximity_binary == "Above Median")

preserve
    collapse (first) supermarket suburb chain proximity_binary high_prox, by(sheet_index)
    tempfile store_info
    save `store_info'
restore

tempfile analysis
save `analysis'

********************************************************************************
* Per-store effects from one regression
********************************************************************************
reghdfe r_price i.sheet_index#c.treatedpost, absorb(sheet_index month_num) vce(cluster item_code)
regsave, ci level(95)
keep if regexm(var, "sheet_index#c.treatedpost")
gen sheet_index = real(regexs(1)) if regexm(var, "^([0-9]+)\.sheet_index")
gen passthrough_pct = coef / -0.091 * 100
merge m:1 sheet_index using `store_info', keep(match) nogen
keep if chain == "Stop and Shop"
keep sheet_index supermarket suburb high_prox coef stderr ci_lower ci_upper passthrough_pct
export delimited "${dir_tables}/store_passthrough_estimates.csv", replace
gen byte is_pooled = 0
tempfile store_est
save `store_est'

********************************************************************************
* Pooled high / pooled low: inverse-variance weighted mean of the store
* coefficients (weights 1/se^2; SE = sqrt(1/sum w); point within the store range)
********************************************************************************
use `store_est', clear
gen double w = 1/(stderr^2)
gen double wc = w*coef
collapse (sum) wc (sum) w (count) n_stores=coef, by(high_prox)
gen double coef = wc/w
gen double se = sqrt(1/w)
gen double ci_lower = coef - 1.96*se
gen double ci_upper = coef + 1.96*se
gen byte is_pooled = 1
keep high_prox coef ci_lower ci_upper is_pooled
tempfile pooled
save `pooled'

********************************************************************************
* Assemble and plot
********************************************************************************
use `store_est', clear
gsort -high_prox coef
gen long store_num = _n
tempfile sd
save `sd'

use `pooled', clear
gen long store_num = .
append using `sd'

gen double y = store_num
replace y = -0.45 if is_pooled==1 & high_prox==1
replace y = -0.95 if is_pooled==1 & high_prox==0

* y-axis labels: suburb for stores, single "Pooled" tick
gen str60 ylab_txt = strtrim(suburb) if is_pooled == 0
replace ylab_txt = supermarket if is_pooled == 0 & (missing(ylab_txt) | ylab_txt == "")
capture label drop ylbl
forvalues i = 1/`=_N' {
    if is_pooled[`i'] == 0 label define ylbl `=y[`i']' "`=ylab_txt[`i']'", add
}
label values y ylbl

quietly count if is_pooled == 0
local ns = r(N)

quietly summarize coef if is_pooled==1 & high_prox==1
local ph = r(mean)
quietly summarize coef if is_pooled==1 & high_prox==0
local pl = r(mean)

twoway ///
    (rcap ci_lower ci_upper y if is_pooled==0 & high_prox==1, horizontal lcolor("$my_blue") lwidth(medthin)) ///
    (scatter y coef if is_pooled==0 & high_prox==1, mcolor("$my_blue") msymbol(O) msize(medium)) ///
    (rcap ci_lower ci_upper y if is_pooled==0 & high_prox==0, horizontal lcolor("$my_red") lwidth(medthin)) ///
    (scatter y coef if is_pooled==0 & high_prox==0, mcolor("$my_red") msymbol(O) msize(medium)) ///
    (rcap ci_lower ci_upper y if is_pooled==1 & high_prox==1, horizontal lcolor("$my_blue") lwidth(medium)) ///
    (scatter y coef if is_pooled==1 & high_prox==1, mcolor("$my_blue") msymbol(D) msize(large)) ///
    (rcap ci_lower ci_upper y if is_pooled==1 & high_prox==0, horizontal lcolor("$my_red") lwidth(medium)) ///
    (scatter y coef if is_pooled==1 & high_prox==0, mcolor("$my_red") msymbol(D) msize(large)) ///
    , ///
    subtitle("Stop and Shop", size(medsmall)) ///
    xtitle("Price effect", size(small)) ytitle("") ///
    xscale(range(-0.32 0.14)) ///
    xlabel(-0.3 "-30%" -0.2 "-20%" -0.1 "-10%" 0 "0" 0.1 "10%", nogrid labsize(small)) ///
    ylabel(1(1)`ns' -0.7 "Pooled", valuelabel nogrid angle(0) labsize(vsmall)) ///
    yscale(range(-1.4 `=`ns'+0.6')) ///
    xline(`ph', lpattern(dash) lcolor("$my_blue*0.6") lwidth(thin)) ///
    xline(`pl', lpattern(dash) lcolor("$my_red*0.6") lwidth(thin)) ///
    yline(0.2, lpattern(dash) lcolor(gs10) lwidth(thin)) ///
    legend(order(2 "High competition" 4 "Low competition" 6 "Pooled high" 8 "Pooled low") ///
        rows(1) position(6) size(small) region(lcolor(gs12) fcolor(white))) ///
    plotregion(color(white)) graphregion(color(white)) ///
    xsize(8.8) ysize(5.2) name(fig4c, replace)

graph export "${dir_graphs}/figure_4c.png", replace width(2400)
di as result "Done. figure_4c.png written."
