/*==============================================================================
 figsA36_A38_event_study_stores.do
 VAT exemption pass-through and incidence (Papua New Guinea) — analysis

 PURPOSE : Store-price event studies by luxury vs basic goods (Figure A38) and
           by store type, chain vs independent (Figure A36).
 INPUTS  : ${final_stores}/POM_Prices_Long_Clean.dta; globals ${dir_graphs},
           ${dir_tables}, colors ${my_blue}, ${my_red}
 OUTPUTS : ${dir_graphs}/figure_a38.png, figure_a36.png;
           ${dir_tables}/regression_luxury.dta, regression_storetype.dta (scratch)
 DEPENDS : ${final_stores}/POM_Prices_Long_Clean.dta must exist
 CALLED BY: main.do
==============================================================================*/

local num_months = 6

*------------------------------------------------------------------------------*
* HETEROGENEITY BY LUXURY GOODS - SEPARATE REGRESSIONS
*------------------------------------------------------------------------------*


foreach group in all { // narrowed to paper spec: A38 uses group=all
foreach sample_type in balanced { // narrowed to paper spec: balanced panel

* Create dataset to store regression results
cap erase "$dir_tables/regression_luxury.dta"
preserve 
	clear
	set obs 1
	gen luxury_type = "garbage" 
	save "$dir_tables/regression_luxury.dta", replace
restore  

foreach luxury_val in 0 1 {
	if `luxury_val' == 0 {
		local luxury_name "basic"
	}
	else {
		local luxury_name "luxury"
	}
	
	use "${final_stores}/POM_Prices_Long_Clean.dta", clear
	
	* FILTER: Keep only this luxury category
	keep if luxury == `luxury_val'
	
	* Create price per unit
	gen price_per_unit = Price / quantity
	drop if missing(price_per_unit) | price_per_unit <= 0
	
	* Convert month to numeric
	gen month_num = .
	replace month_num = 1 if Month == "May"
	replace month_num = 2 if Month == "June"
	replace month_num = 3 if Month == "July"
	replace month_num = 4 if Month == "August"
	replace month_num = 5 if Month == "September"
	replace month_num = 6 if Month == "October"
	
	keep if month_num <= `num_months' & !missing(month_num)
	gen month_year = month_num
	
	* Winsorize
	bysort item_code: egen p5 = pctile(price_per_unit), p(5)
	bysort item_code: egen p95 = pctile(price_per_unit), p(95)
	gen price_w5 = price_per_unit
	replace price_w5 = p5 if price_per_unit < p5 & !missing(p5)
	replace price_w5 = p95 if price_per_unit > p95 & !missing(p95)
	drop p5 p95
	
	* Treatment variables
	drop treat
	gen treat = treat_`group'
	rename treat treated
	keep if treated != .
	
	gen post = (month_num >= 2 & month_num != .)
	gen treatedpost = (treated == 1 & post == 1)
	
	* Relative prices
	bysort item_code sheet_index: egen price_may25 = mean(cond(month_num == 1, price_w5, .))
	bysort item_code: egen price_may25_overall = mean(cond(month_num == 1, price_w5, .))
	replace price_may25 = price_may25_overall if missing(price_may25)
	drop price_may25_overall
	gen r_price = price_w5 / price_may25
	drop if missing(r_price)
	
	* Balance panel if needed
	if "`sample_type'" == "balanced" {
		egen store_product = group(sheet_index item_code)
		bysort store_product: gen n_months_obs = _N
		keep if n_months_obs == `num_months'
		drop n_months_obs store_product
	}
	
	* Event time
	gen rel_time = month_num - 2
	gen event_time = rel_time
	local lower = -1
	gen event_time_shift = event_time - `lower'
	local baseline = 0
	local upper = `num_months' - 2
	
	* DID with CI calculation
	reghdfe r_price treatedpost, absorb(sheet_index month_year item_code) vce(cluster item_code)
		local DIDcoef: di %-4.3f _b[treatedpost]
		local DIDse: di %-4.3f _se[treatedpost]
		local DIDp = (2 * ttail(e(df_r), abs(_b[treatedpost] / _se[treatedpost])))
		* Calculate 95% CI for pooled estimate
		local t_crit = invttail(e(df_r), 0.025)
		local DID_ci_lower = _b[treatedpost] - `t_crit' * _se[treatedpost]
		local DID_ci_upper = _b[treatedpost] + `t_crit' * _se[treatedpost]
	
	* Event study - SIMPLE TWO-WAY INTERACTION
	reghdfe r_price ib`baseline'.event_time_shift##i.treated, ///
		absorb(sheet_index month_year item_code) vce(cluster item_code)
	
	regsave using "$dir_tables/regression_luxury.dta", ci pval level(95) append ///
		addlabel(DIDcoef, `DIDcoef', DIDse, `DIDse', DIDp, `DIDp', ///
		         DID_ci_lower, `DID_ci_lower', DID_ci_upper, `DID_ci_upper', ///
		         luxury_type, "`luxury_name'")
}

* Load and prepare graph data
use "$dir_tables/regression_luxury.dta", clear
drop if luxury_type == "garbage"

keep if regexm(var, "^[0-9]+\.event_time_shift#1\.treated$")
gen event_time_shift_num = real(regexs(1)) if regexm(var, "^([0-9]+)\.event_time_shift#1\.treated$")

* Get DID CIs for each luxury type
qui sum DID_ci_lower if luxury_type == "basic"
local did_ci_lower_basic = r(mean)
qui sum DID_ci_upper if luxury_type == "basic"
local did_ci_upper_basic = r(mean)
qui sum DIDcoef if luxury_type == "basic"
local did_coef_basic = r(mean)

qui sum DID_ci_lower if luxury_type == "luxury"
local did_ci_lower_luxury = r(mean)
qui sum DID_ci_upper if luxury_type == "luxury"
local did_ci_upper_luxury = r(mean)
qui sum DIDcoef if luxury_type == "luxury"
local did_coef_luxury = r(mean)

* Add baseline for each luxury type
foreach luxury_name in "basic" "luxury" {
	local N = _N + 1
	set obs `N'
	replace var = "0.event_time_shift#1.treated" in `N'
	replace event_time_shift_num = 0 in `N'
	replace coef = 0 in `N'
	replace ci_lower = 0 in `N'
	replace ci_upper = 0 in `N'
	replace luxury_type = "`luxury_name'" in `N'
}

gen event_time = event_time_shift_num + `lower'

* Add pooled post-reform points
local pooled_pos = `upper' + 1.5

* Basic pooled point
local N = _N + 1
set obs `N'
replace var = "pooled_post" in `N'
replace event_time = `pooled_pos' in `N'
replace coef = `did_coef_basic' in `N'
replace ci_lower = `did_ci_lower_basic' in `N'
replace ci_upper = `did_ci_upper_basic' in `N'
replace luxury_type = "basic" in `N'

* Luxury pooled point
local N = _N + 1
set obs `N'
replace var = "pooled_post" in `N'
replace event_time = `pooled_pos' in `N'
replace coef = `did_coef_luxury' in `N'
replace ci_lower = `did_ci_lower_luxury' in `N'
replace ci_upper = `did_ci_upper_luxury' in `N'
replace luxury_type = "luxury" in `N'

* Flag for pooled points
gen is_pooled = (var == "pooled_post")

* Create jittered x-axis for visibility
gen event_time_aux = event_time
replace event_time_aux = event_time - 0.1 if luxury_type == "basic"
replace event_time_aux = event_time + 0.1 if luxury_type == "luxury"

sort luxury_type event_time

label def event_time_lab -1 "May 25" 0 "Jun 25" 1 "Jul 25" 2 "Aug 25" 3 "Sep 25" 4 "Oct 25"
label val event_time event_time_lab

local text_pos = floor((`upper' + 0) / 2)
if `text_pos' < 1 local text_pos = 0.4
local xline_pos = `upper' + 0.75

* Graph with pooled points
twoway scatter coef event_time_aux if luxury_type == "basic" & !is_pooled, ///
	   connect(l) mlcolor("$my_blue") mfcolor("$my_blue*0.5") lcolor("$my_blue") msymbol(O) ///
	|| rcap ci_lower ci_upper event_time_aux if luxury_type == "basic" & !is_pooled, color("$my_blue*0.5") lwidth(medium) ///
	|| scatter coef event_time_aux if luxury_type == "luxury" & !is_pooled, ///
	   connect(l) mlcolor("$my_red") mfcolor("$my_red*0.5") lcolor("$my_red") msymbol(T) ///
	|| rcap ci_lower ci_upper event_time_aux if luxury_type == "luxury" & !is_pooled, color("$my_red*0.5") lwidth(medium) ///
	|| scatter coef event_time_aux if luxury_type == "basic" & is_pooled, ///
	   mlcolor("$my_blue") mfcolor("$my_blue*0.5") msymbol(O) ///
	|| rcap ci_lower ci_upper event_time_aux if luxury_type == "basic" & is_pooled, color("$my_blue") lwidth(medthick) ///
	|| scatter coef event_time_aux if luxury_type == "luxury" & is_pooled, ///
	   mlcolor("$my_red") mfcolor("$my_red*0.5") msymbol(T) ///
	|| rcap ci_lower ci_upper event_time_aux if luxury_type == "luxury" & is_pooled, color("$my_red") lwidth(medthick) ///
	, ///
	xline(-0.5, lcolor(gs6) lpattern(dash)) ///
	xline(`xline_pos', lcolor(gs6) lpattern(dot)) ///
	yline(0, lcolor(gs6)) ///
	yline(-0.091, lpattern(dash) lcolor(gs6)) ///
	caption("Price effect (p.p.)", pos(11)) ///
	xtitle("") ytitle("") ///
	ylabel(-0.3 "-30" -0.2 "-20" -0.1 "-10" 0 "0" 0.1 "10", nogrid) yscale(range(-0.2 0.2)) ///
	xlabel(-1 "May 25" 0 "Jun 25" 1 "Jul 25" 2 "Aug 25" 3 "Sep 25" 4 "Oct 25" `pooled_pos' "Post", ///
		angle(45) labsize(small) nogrid) ///
	text(0.15 0 "VAT exemptions", box bcolor(white) lcolor(gs6) color(gs6)) ///
	text(-0.13 `text_pos' "Full pass through {&Delta}p: -9.1 p.p.", size(small) color(gs6)) ///
	legend(order(1 "Basic" 3 "Luxury") pos(6) rows(1)) ///
	graphregion(color(white) margin(l=2 r=3 t=1 b=0)) ///
	plotregion(color(white))

graph export "$dir_graphs/figure_a38.png", replace width(2400)

} // sample_type loop
} // group loop



*------------------------------------------------------------------------------*
* HETEROGENEITY BY STORE TYPE - SEPARATE REGRESSIONS
*------------------------------------------------------------------------------*

foreach group in all { // narrowed to paper spec: A36 uses group=all
foreach sample_type in balanced { // narrowed to paper spec: balanced panel

cap erase "$dir_tables/regression_storetype.dta"
preserve 
	clear
	set obs 1
	gen store_category = "garbage" 
	save "$dir_tables/regression_storetype.dta", replace
restore  

foreach store in Independent Chain {
	
	use "${final_stores}/POM_Prices_Long_Clean.dta", clear
	
	* FILTER: Keep only this store type
	keep if store_type == "`store'"
	
	* Create price per unit
	gen price_per_unit = Price / quantity
	drop if missing(price_per_unit) | price_per_unit <= 0
	
	* Convert month to numeric
	gen month_num = .
	replace month_num = 1 if Month == "May"
	replace month_num = 2 if Month == "June"
	replace month_num = 3 if Month == "July"
	replace month_num = 4 if Month == "August"
	replace month_num = 5 if Month == "September"
	replace month_num = 6 if Month == "October"
	
	keep if month_num <= `num_months' & !missing(month_num)
	gen month_year = month_num
	
	* Winsorize
	bysort item_code: egen p5 = pctile(price_per_unit), p(5)
	bysort item_code: egen p95 = pctile(price_per_unit), p(95)
	gen price_w5 = price_per_unit
	replace price_w5 = p5 if price_per_unit < p5 & !missing(p5)
	replace price_w5 = p95 if price_per_unit > p95 & !missing(p95)
	drop p5 p95
	
	* Treatment variables
	drop treat
	gen treat = treat_`group'
	rename treat treated
	keep if treated != .
	
	gen post = (month_num >= 2 & month_num != .)
	gen treatedpost = (treated == 1 & post == 1)
	
	* Relative prices
	bysort item_code sheet_index: egen price_may25 = mean(cond(month_num == 1, price_w5, .))
	bysort item_code: egen price_may25_overall = mean(cond(month_num == 1, price_w5, .))
	replace price_may25 = price_may25_overall if missing(price_may25)
	drop price_may25_overall
	gen r_price = price_w5 / price_may25
	drop if missing(r_price)
	
	* Balance panel if needed
	if "`sample_type'" == "balanced" {
		egen store_product = group(sheet_index item_code)
		bysort store_product: gen n_months_obs = _N
		keep if n_months_obs == `num_months'
		drop n_months_obs store_product
	}
	
	* Event time
	gen rel_time = month_num - 2
	gen event_time = rel_time
	local lower = -1
	gen event_time_shift = event_time - `lower'
	local baseline = 0
	local upper = `num_months' - 2
	
	* DID
	reghdfe r_price treatedpost, absorb(sheet_index month_year item_code) vce(cluster item_code)
		local DIDcoef = _b[treatedpost]
		local DIDse = _se[treatedpost]
		local DIDp = (2 * ttail(e(df_r), abs(_b[treatedpost] / _se[treatedpost])))
	
	* Event study
	reghdfe r_price ib`baseline'.event_time_shift##i.treated, ///
		absorb(sheet_index month_year item_code) vce(cluster item_code)
	
	regsave using "$dir_tables/regression_storetype.dta", ci pval level(95) append ///
		addlabel(DIDcoef, `DIDcoef', DIDse, `DIDse', DIDp, `DIDp', store_category, "`store'")
}

* Load and prepare graph data
use "$dir_tables/regression_storetype.dta", clear
drop if store_category == "garbage"

* Define bounds
local lower = -1
local upper = `num_months' - 2

keep if regexm(var, "^[0-9]+\.event_time_shift#1\.treated$")
gen event_time_shift_num = real(regexs(1)) if regexm(var, "^([0-9]+)\.event_time_shift#1\.treated$")

* Get DID info for each store type (calculate CI from coef and se)
qui sum DIDcoef if store_category == "Independent"
local did_coef_indep = r(mean)
qui sum DIDse if store_category == "Independent"
local did_se_indep = r(mean)
local did_ci_lower_indep = `did_coef_indep' - 1.96 * abs(`did_se_indep')
local did_ci_upper_indep = `did_coef_indep' + 1.96 * abs(`did_se_indep')

qui sum DIDcoef if store_category == "Chain"
local did_coef_chain = r(mean)
qui sum DIDse if store_category == "Chain"
local did_se_chain = r(mean)
local did_ci_lower_chain = `did_coef_chain' - 1.96 * abs(`did_se_chain')
local did_ci_upper_chain = `did_coef_chain' + 1.96 * abs(`did_se_chain')

display "Independent: coef=`did_coef_indep' se=`did_se_indep'"
display "Chain: coef=`did_coef_chain' se=`did_se_chain'"

* Add baseline for each store type
foreach store in Independent Chain {
	local N = _N + 1
	set obs `N'
	replace var = "0.event_time_shift#1.treated" in `N'
	replace event_time_shift_num = 0 in `N'
	replace coef = 0 in `N'
	replace ci_lower = 0 in `N'
	replace ci_upper = 0 in `N'
	replace store_category = "`store'" in `N'
}

gen event_time = event_time_shift_num + `lower'

* Add pooled post-reform points
local pooled_pos = `upper' + 1.5

* Independent pooled point
local N = _N + 1
set obs `N'
replace var = "pooled_post" in `N'
replace event_time = `pooled_pos' in `N'
replace coef = `did_coef_indep' in `N'
replace ci_lower = `did_ci_lower_indep' in `N'
replace ci_upper = `did_ci_upper_indep' in `N'
replace store_category = "Independent" in `N'

* Chain pooled point
local N = _N + 1
set obs `N'
replace var = "pooled_post" in `N'
replace event_time = `pooled_pos' in `N'
replace coef = `did_coef_chain' in `N'
replace ci_lower = `did_ci_lower_chain' in `N'
replace ci_upper = `did_ci_upper_chain' in `N'
replace store_category = "Chain" in `N'

* Flag for pooled points
gen is_pooled = (var == "pooled_post")

* Create jittered x-axis for visibility
gen event_time_aux = event_time
replace event_time_aux = event_time - 0.1 if store_category == "Independent"
replace event_time_aux = event_time + 0.1 if store_category == "Chain"

sort store_category event_time

label def event_time_lab -1 "May 25" 0 "Jun 25" 1 "Jul 25" 2 "Aug 25" 3 "Sep 25" 4 "Oct 25"
label val event_time event_time_lab

local text_pos = floor((`upper' + 0) / 2)
if `text_pos' < 1 local text_pos = 0.4
local xline_pos = `upper' + 0.75

* Graph with pooled points
twoway scatter coef event_time_aux if store_category == "Independent" & is_pooled == 0, ///
	   connect(l) mlcolor("$my_blue") mfcolor("$my_blue*0.5") lcolor("$my_blue") msymbol(O) ///
	|| rcap ci_lower ci_upper event_time_aux if store_category == "Independent" & is_pooled == 0, color("$my_blue*0.5") lwidth(medium) ///
	|| scatter coef event_time_aux if store_category == "Chain" & is_pooled == 0, ///
	   connect(l) mlcolor("$my_red") mfcolor("$my_red*0.5") msymbol(T) lcolor("$my_red") ///
	|| rcap ci_lower ci_upper event_time_aux if store_category == "Chain" & is_pooled == 0, color("$my_red*0.5") lwidth(medium) ///
	|| scatter coef event_time_aux if store_category == "Independent" & is_pooled == 1, ///
	   mlcolor("$my_blue") mfcolor("$my_blue*0.5") msymbol(O) ///
	|| rcap ci_lower ci_upper event_time_aux if store_category == "Independent" & is_pooled == 1, color("$my_blue") lwidth(medthick) ///
	|| scatter coef event_time_aux if store_category == "Chain" & is_pooled == 1, ///
	   mlcolor("$my_red") mfcolor("$my_red*0.5") msymbol(T) ///
	|| rcap ci_lower ci_upper event_time_aux if store_category == "Chain" & is_pooled == 1, color("$my_red") lwidth(medthick) ///
	, ///
	xline(-0.5, lcolor(gs6) lpattern(dash)) ///
	xline(`xline_pos', lcolor(gs6) lpattern(dot)) ///
	yline(0, lcolor(gs6)) ///
	yline(-0.091, lpattern(dash) lcolor(gs6)) ///
	caption("Price effect (p.p.)", pos(11)) ///
	xtitle("") ytitle("") ///
	ylabel(-0.3 "-30" -0.2 "-20" -0.1 "-10" 0 "0" 0.1 "10", nogrid) yscale(range(-0.2 0.2)) ///
	xlabel(-1 "May 25" 0 "Jun 25" 1 "Jul 25" 2 "Aug 25" 3 "Sep 25" 4 "Oct 25" `pooled_pos' "Post", ///
		angle(45) labsize(small) nogrid) ///
	text(0.15 0 "VAT exemptions", box bcolor(white) lcolor(gs6) color(gs6)) ///
	text(-0.13 `text_pos' "Full pass through {&Delta}p: -9.1 p.p.", size(small) color(gs6)) ///
	legend(order(1 "Independent" 3 "Chain") pos(6) rows(1)) ///
	graphregion(color(white) margin(l=2 r=3 t=1 b=0)) ///
	plotregion(color(white))

graph export "$dir_graphs/figure_a36.png", replace width(2400)

}
}
