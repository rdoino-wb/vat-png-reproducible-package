/*
================================================================================
 fig4d_online_vs_instore.do
 VAT exemption pass-through and incidence (Papua New Guinea)

 PURPOSE : Produce Figure 4d, overlaying the in-store pass-through event study
           for RH physical stores with online pass-through (RH), monthly.
           Self-contained: builds its own online and in-store regression inputs.
 INPUTS  : ${final_e_stores}/combined_cleaned_data.dta (online prices);
           ${final_stores}/POM_Prices_Long_Clean.dta   (in-store prices)
 OUTPUTS : ${dir_graphs}/event_study/figure_4d.png  (Figure 4d);
           ${dir_tables}/regression_online_monthly.dta;
           ${dir_tables}/regression_instore_rh.dta
 DEPENDS : run after build_online_prices.do and in-store data prep in main.do
 CALLED BY: main.do
================================================================================
*/

local num_months = 3

********************************************************************************
* A. ONLINE EVENT STUDY: COLLAPSE TO MONTHLY
********************************************************************************

use "${final_e_stores}/combined_cleaned_data.dta", clear

drop if missing(price) | price <= 0

* Create month from extraction date
gen month_num = .
replace month_num = 1 if month(extraction_date) == 5 & year(extraction_date) == 2025
replace month_num = 2 if month(extraction_date) == 6 & year(extraction_date) == 2025
replace month_num = 3 if month(extraction_date) == 7 & year(extraction_date) == 2025
replace month_num = 4 if month(extraction_date) == 8 & year(extraction_date) == 2025
replace month_num = 5 if month(extraction_date) == 9 & year(extraction_date) == 2025

keep if month_num <= `num_months' & !missing(month_num)

keep if source == "rh"

* Product panel ID
gen prod_fe = source + "||" + prod_id

* Collapse to monthly mean price per product
collapse (mean) price treat, by(prod_fe source product month_num)
gen month_year = month_num

* Winsorize at 5/95 within product
bysort product: egen p5 = pctile(price), p(5)
bysort product: egen p95 = pctile(price), p(95)
gen price_w5 = price
replace price_w5 = p5 if price < p5 & !missing(p5)
replace price_w5 = p95 if price > p95 & !missing(p95)
drop p5 p95

* Treatment
rename treat treated
keep if treated != .

gen post = (month_num >= 2)
gen treatedpost = (treated == 1 & post == 1)

* Relative prices (May = 1)
bysort prod_fe: egen price_may25 = mean(cond(month_num == 1, price_w5, .))
bysort product: egen price_may25_overall = mean(cond(month_num == 1, price_w5, .))
replace price_may25 = price_may25_overall if missing(price_may25)
drop price_may25_overall
gen r_price = price_w5 / price_may25
drop if missing(r_price)

* Balance the panel
bysort prod_fe: gen n_months_obs = _N
keep if n_months_obs == `num_months'
drop n_months_obs

* Encode prod_fe for absorb
encode prod_fe, gen(prod_fe_num)

* Event time
gen event_time = month_num - 2
gen event_time_shift = event_time + 1
local baseline = 0
local lower = -1
local upper = `num_months' - 2

* DID
reghdfe r_price treatedpost, absorb(prod_fe_num month_year) vce(cluster product)
	local DIDcoef_online: di %-4.3f _b[treatedpost]
	local DIDse_online: di %-4.3f _se[treatedpost]
	local DIDp_online = (2 * ttail(e(df_r), abs(_b[treatedpost] / _se[treatedpost])))
	local t_crit_online = invttail(e(df_r), 0.025)
	local DIDci_lo_online = _b[treatedpost] - `t_crit_online' * _se[treatedpost]
	local DIDci_hi_online = _b[treatedpost] + `t_crit_online' * _se[treatedpost]

* Event study
reghdfe r_price ib`baseline'.event_time_shift##i.treated, ///
	absorb(prod_fe_num month_year) vce(cluster product)

regsave using "$dir_tables/regression_online_monthly.dta", ///
	ci pval level(95) replace ///
	addlabel(DIDcoef, `DIDcoef_online', DIDse, `DIDse_online', ///
	         DIDp, `DIDp_online', source_type, "online")

********************************************************************************
* B. IN-STORE EVENT STUDY: RH STORES ONLY
********************************************************************************

use "${final_stores}/POM_Prices_Long_Clean.dta", clear

* Keep only RH physical stores
keep if regexm(Supermarket, "^RH")

display as text _newline "{hline 60}"
display as result "IN-STORE EVENT STUDY: RH STORES"
display as text "{hline 60}"
tab Supermarket

gen price_per_unit = Price / quantity
drop if missing(price_per_unit) | price_per_unit <= 0

gen month_num = .
replace month_num = 1 if Month == "May"
replace month_num = 2 if Month == "June"
replace month_num = 3 if Month == "July"
replace month_num = 4 if Month == "August"
replace month_num = 5 if Month == "September"

keep if month_num <= `num_months' & !missing(month_num)
gen month_year = month_num

* Winsorize
bysort item_code: egen p5 = pctile(price_per_unit), p(5)
bysort item_code: egen p95 = pctile(price_per_unit), p(95)
gen price_w5 = price_per_unit
replace price_w5 = p5 if price_per_unit < p5 & !missing(p5)
replace price_w5 = p95 if price_per_unit > p95 & !missing(p95)
drop p5 p95

* Treatment
drop treat
gen treat = treat_all
rename treat treated
keep if treated != .

gen post = (month_num >= 2)
gen treatedpost = (treated == 1 & post == 1)

* Relative prices
bysort item_code sheet_index: egen price_may25 = mean(cond(month_num == 1, price_w5, .))
bysort item_code: egen price_may25_overall = mean(cond(month_num == 1, price_w5, .))
replace price_may25 = price_may25_overall if missing(price_may25)
drop price_may25_overall
gen r_price = price_w5 / price_may25
drop if missing(r_price)

* Balance
egen store_product = group(sheet_index item_code)
bysort store_product: gen n_months_obs = _N
keep if n_months_obs == `num_months'
drop n_months_obs store_product

display as text "Balanced panel obs: " _N

* Event time
gen event_time = month_num - 2
gen event_time_shift = event_time + 1
local baseline = 0

* DID
reghdfe r_price treatedpost, absorb(sheet_index month_year) vce(cluster item_code)
	local DIDcoef_instore: di %-4.3f _b[treatedpost]
	local DIDse_instore: di %-4.3f _se[treatedpost]
	local DIDp_instore = (2 * ttail(e(df_r), abs(_b[treatedpost] / _se[treatedpost])))
	local t_crit_instore = invttail(e(df_r), 0.025)
	local DIDci_lo_instore = _b[treatedpost] - `t_crit_instore' * _se[treatedpost]
	local DIDci_hi_instore = _b[treatedpost] + `t_crit_instore' * _se[treatedpost]

* Event study
reghdfe r_price ib`baseline'.event_time_shift##i.treated, ///
	absorb(sheet_index month_year) vce(cluster item_code)

regsave using "$dir_tables/regression_instore_rh.dta", ///
	ci pval level(95) replace ///
	addlabel(DIDcoef, `DIDcoef_instore', DIDse, `DIDse_instore', ///
	         DIDp, `DIDp_instore', source_type, "instore")

********************************************************************************
* C. COMBINE AND GRAPH
********************************************************************************

* Load online
use "$dir_tables/regression_online_monthly.dta", clear
keep if regexm(var, "^[0-9]+\.event_time_shift#1\.treated$")
gen event_time_shift_num = real(regexs(1)) if regexm(var, "^([0-9]+)\.event_time_shift#1\.treated$")
tempfile online
save `online'

* Load in-store
use "$dir_tables/regression_instore_rh.dta", clear
keep if regexm(var, "^[0-9]+\.event_time_shift#1\.treated$")
gen event_time_shift_num = real(regexs(1)) if regexm(var, "^([0-9]+)\.event_time_shift#1\.treated$")

append using `online'

* Add baselines
foreach src in "instore" "online" {
	local N = _N + 1
	set obs `N'
	replace event_time_shift_num = 0 in `N'
	replace coef = 0 in `N'
	replace ci_lower = 0 in `N'
	replace ci_upper = 0 in `N'
	replace source_type = "`src'" in `N'
}

gen event_time = event_time_shift_num + `lower'

* Add pooled post points
local pooled_pos = `upper' + 1.5

local N = _N + 1
set obs `N'
replace event_time = `pooled_pos' in `N'
replace coef = `DIDcoef_instore' in `N'
replace ci_lower = `DIDci_lo_instore' in `N'
replace ci_upper = `DIDci_hi_instore' in `N'
replace source_type = "instore" in `N'

local N = _N + 1
set obs `N'
replace event_time = `pooled_pos' in `N'
replace coef = `DIDcoef_online' in `N'
replace ci_lower = `DIDci_lo_online' in `N'
replace ci_upper = `DIDci_hi_online' in `N'
replace source_type = "online" in `N'

gen is_pooled = (event_time == `pooled_pos')

* Jitter for readability
gen event_time_aux = event_time
replace event_time_aux = event_time - 0.05 if source_type == "instore"
replace event_time_aux = event_time + 0.05 if source_type == "online"

sort source_type event_time

* Separator line x-position
local xline_pos = `upper' + 0.75

* Colors
global my_blue "20 97 128"
global my_red "150 39 23"

* Graph
twoway scatter coef event_time_aux if source_type == "instore" & is_pooled == 0, ///
	   connect(l) mlcolor("$my_blue") mfcolor("$my_blue*0.5") lcolor("$my_blue") msymbol(O) ///
	|| rcap ci_lower ci_upper event_time_aux if source_type == "instore" & is_pooled == 0, ///
	   color("$my_blue*0.5") lwidth(medthick) ///
	|| scatter coef event_time_aux if source_type == "instore" & is_pooled == 1, ///
	   mlcolor("$my_blue") mfcolor("$my_blue*0.5") msymbol(O) ///
	|| rcap ci_lower ci_upper event_time_aux if source_type == "instore" & is_pooled == 1, ///
	   color("$my_blue") lwidth(medthick) ///
	|| scatter coef event_time_aux if source_type == "online" & is_pooled == 0, ///
	   connect(l) mlcolor("$my_red") mfcolor("$my_red*0.5") lcolor("$my_red") msymbol(T) ///
	|| rcap ci_lower ci_upper event_time_aux if source_type == "online" & is_pooled == 0, ///
	   color("$my_red*0.5") lwidth(medthick) ///
	|| scatter coef event_time_aux if source_type == "online" & is_pooled == 1, ///
	   mlcolor("$my_red") mfcolor("$my_red*0.5") msymbol(T) ///
	|| rcap ci_lower ci_upper event_time_aux if source_type == "online" & is_pooled == 1, ///
	   color("$my_red") lwidth(medthick) ///
	 , ///
	   xline(-0.5, lcolor(gs6) lpattern(dash)) ///
	   xline(`xline_pos', lcolor(gs6) lpattern(dot)) ///
	   yline(0, lcolor(gs6)) ///
	   yline(-0.091, lpattern(dash) lcolor(gs6)) ///
	   subtitle("Price effect (p.p.)", pos(11)) ///
	   xtitle("") ytitle("") ///
	   ylabel(-0.3 "-30" -0.2 "-20" -0.1 "-10" 0 "0" 0.1 "10", nogrid) ///
	   yscale(range(-0.3 0.15)) xscale(range(-1.5 `=`pooled_pos'+0.5')) ///
	   xlabel(-1 "May 25" 0 "Jun 25" 1 "Jul 25" `pooled_pos' "Post", angle(45) labsize(small) nogrid) ///
	   text(0.12 -0.5 "VAT exemptions", box bcolor(white) lcolor(gs6) color(gs6) size(small)) ///
	   text(-0.12 0.5 "Full pass through {&Delta}p: -9.1 p.p.", size(small) color(gs6)) ///
	   legend(order(1 "In-store (RH)" 5 "Online (RH)") pos(6) rows(1)) ///
	   graphregion(color(white)) plotregion(margin(small))

graph export "${dir_graphs}/figure_4d.png", replace

display as result _newline "Combined chart saved: figure_4d.png"
display as text "In-store RH DID: `DIDcoef_instore'"
display as text "Online RH DID: `DIDcoef_online'"
