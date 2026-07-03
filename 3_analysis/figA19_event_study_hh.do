/*==============================================================================
 figA19_event_study_hh.do
 VAT exemption pass-through and incidence (Papua New Guinea) — analysis

 PURPOSE : Household-level event studies of relative prices around the VAT
           exemptions, overall and by store type and area (Figure A19 a-d).
 INPUTS  : ${final_phone}/product_prices_panel.dta; globals ${dir_graphs},
           ${dir_tables}
 OUTPUTS : ${dir_graphs}/figure_a19a.png, figure_a19b.png, figure_a19c.png,
           figure_a19d.png; ${dir_tables}/regression.dta (scratch, overwritten)
 DEPENDS : ${final_phone}/product_prices_panel.dta must exist
 CALLED BY: main.do
==============================================================================*/

/* Install packages
ssc install reghdfe
ssc install ftools
ssc install regsave
*/

* Ensure the figure subfolder exists (this script runs before others that create it)
cap mkdir "$dir_graphs/event_study"

*------------------------------------------------------------------------------*
* Event study: general event study
*------------------------------------------------------------------------------*


foreach group in fair { // narrowed to paper spec: A19 uses group=fair
foreach items_availability in always { // narrowed: A19a uses the 'always' series

* Trick 
*local group fair 
*local items_availability always
	
* Load dataset
use "$final_phone/product_prices_panel.dta", clear

* Create treatment/control group category
drop treat 
gen treat = treat_`group'

rename treat treated 

* Keep only treated and control items
keep if treated != .

if "`items_availability'" == "always" {
	// Keep only items for which we have long time series (exclude recently available items)
	keep if always_available == 1 
}

* Create post indicator
gen post = (month_year >= 24 & month_year != .)

* Create interaction of treated and post 
gen treatedpost = (treated == 1 & post == 1)

* Create the relevant outcome: relative prices (may 2025 = 1)
bysort product: gegen price_may25 = mean(cond(month_year == 23, price_w5, .)) // the baseline price is the average price across HHs of each item in May 2025
gen r_price = price_w5 / price_may25

* Relative time since policy (single reform date for all items)
gen rel_time = month_year - 24

* Create event time (relative time but restricting months too far from VAT removal)
gen event_time = rel_time

local upper = 6
local lower = -17
replace event_time = `lower' if event_time < `lower'
replace event_time = `upper'  if event_time > `upper' 

/* Create an auxiliar variable that is always positive to run regression, 
   as otherwise it will not work. This one goes from zero onwards */
gen event_time_shift = event_time + (- `lower')

* Set of control variables 
*local controlvars c.quantity_w5

* Run DID (for reference)
reghdfe r_price treatedpost `controlvars' , absorb(product month_year) vce(cluster product)

	* Save DID estimate, SE, p-value
	local DIDcoef = _b[treatedpost]
	local DIDse = _se[treatedpost]
	local DIDp = (2 * ttail(e(df_r), abs(_b[treatedpost] / _se[treatedpost])))

display "DID Estimate: `DIDcoef' (SE: `DIDse', p: `DIDp')"

* Local to get the baseline event_time_shift
local baseline = `lower' * (-1) - 1
disp `baseline'

* Run event study with product and month fixed effects excluding baseline period
reghdfe r_price ib`baseline'.event_time_shift##i.treated `controlvars' , absorb(product month_year) vce(cluster product)

* Pooled post-treatment effect using lincom (avg of post coefficients that exist)
local first_post = 0 + (- `lower')
local last_post = `upper' + (- `lower')

local lincom_expr ""
local n_post = 0
forvalues t = `first_post'/`last_post' {
    capture display _b[`t'.event_time_shift#1.treated]
    if _rc == 0 {
        if `n_post' == 0 {
            local lincom_expr "`t'.event_time_shift#1.treated"
        }
        else {
            local lincom_expr "`lincom_expr' + `t'.event_time_shift#1.treated"
        }
        local n_post = `n_post' + 1
    }
}

if `n_post' > 0 {
    lincom (`lincom_expr') / `n_post'
    local pooled_coef = r(estimate)
    local pooled_se = r(se)
    local pooled_ci_lower = `pooled_coef' - 1.96 * `pooled_se'
    local pooled_ci_upper = `pooled_coef' + 1.96 * `pooled_se'
    
    display "Pooled post-treatment effect (avg of `n_post' event study coefficients):"
    display "  Coefficient: `pooled_coef'"
    display "  95% CI: [`pooled_ci_lower', `pooled_ci_upper']"
}
else {
    local pooled_coef = .
    local pooled_se = .
    local pooled_ci_lower = .
    local pooled_ci_upper = .
    display "Warning: No post-treatment coefficients found"
}

* Save regression results
regsave using "$dir_tables/regression.dta", ci pval level(95) replace ///
	addlabel(DIDcoef, `DIDcoef', DIDse, `DIDse', DIDp, `DIDp', ///
	         pooled_coef, `pooled_coef', pooled_se, `pooled_se', ///
	         pooled_ci_lower, `pooled_ci_lower', pooled_ci_upper, `pooled_ci_upper', ///
	         lower, `lower', upper, `upper')

* Load regression results 
use "$dir_tables/regression" , clear

/* Tricks to drop useless estimates and to add an observation that is 0 
   right at event time -1 (baseline) */
drop if coef == 0
replace coef = 0 if var == "_cons"
replace ci_lower = 0 if var == "_cons"
replace ci_upper = 0 if var == "_cons"

replace var = "`baseline'" if var=="_cons"

* Trick to get a variable with the event time
gen leadnum = .
gen match = regexs(1) if regexm(var, "^([0-9]+)\.event_time_shift#1\.treated")
replace leadnum = real(match)
gen event_time = leadnum + `lower'

* Fix: assign event_time for the baseline observation (May 2025 = -1)
replace event_time = -1 if var == "`baseline'"

* Get pooled CI from saved results
qui sum pooled_ci_lower
local pooled_ci_lower = r(mean)
qui sum pooled_ci_upper
local pooled_ci_upper = r(mean)
qui sum pooled_coef
local pooled_coef = r(mean)

display "Retrieved pooled coef: `pooled_coef'"
display "Retrieved CI: [`pooled_ci_lower', `pooled_ci_upper']"

* Get max event_time for pooled position
qui sum event_time
local max_event = r(max)

* Add pooled post-reform point
local pooled_pos = `max_event' + 2
local N = _N + 1
set obs `N'
replace var = "pooled_post" in `N'
replace event_time = `pooled_pos' in `N'
replace coef = `pooled_coef' in `N'
replace ci_lower = `pooled_ci_lower' in `N'
replace ci_upper = `pooled_ci_upper' in `N'

* Flag for pooled point
gen is_pooled = (var == "pooled_post")

sort event_time 

* Define colors
global my_green "0 166 118"
global my_blue "20 97 128"
global my_red "150 39 23"

* Define event time labels for graph
label def month_lab -17 "Oct 23" -16 "Dec 23" -15 "Jan 24" -14 "Feb 24" -13 "Mar 24" -12 "Apr 24" -11 "May 24" -10 "Jun 24" -9 "Jul 24" -8 "Oct 24" -7 "Nov 24" -6 "Dec 24" -5 "Jan 25" -4 "Feb 25" -3 "March 25" -2 "Apr 25" -1 "May 25" 0 "Jun 25" 1 "Jul 25" 2 "Aug 25" 3 "Sep 25" 4 "Oct 25" 5 "Nov 25" 6 "Dec 25"
label val event_time month_lab

local text_pos = 2.5
local xline_pos = `max_event' + 1

* Graph with pooled point
twoway scatter coef event_time if is_pooled == 0, connect(l) mlcolor("$my_green") mfcolor("$my_green*0.5") lcolor("$my_green") msymbol(O) ///
	|| rcap ci_lower ci_upper event_time if is_pooled == 0, color("$my_green*0.8") lwidth(medium) ///
	|| scatter coef event_time if is_pooled == 1, mlcolor("$my_green") mfcolor("$my_green*0.5") msymbol(O) ///
	|| rcap ci_lower ci_upper event_time if is_pooled == 1, color("$my_green") lwidth(medthick) ///
	, ///
	xline(-0.5, lcolor(gs6) lpattern(dash) lwidth(thin)) ///
	xline(`xline_pos', lcolor(gs6) lpattern(dot)) ///
	yline(0, lcolor(gs8) lwidth(thin)) ///
	yline(-0.091, lpattern(dash) lcolor(gs6)) ///
	caption("Price effect (p.p.)", pos(11)) ///
	xtitle("") ytitle("") ///
	ylabel(-0.3 "-30" -0.2 "-20" -0.1 "-10" 0 "0" 0.1 "10", nogrid) ///
	yscale(range(-0.32 0.15)) ///
	xlabel(-17 "Oct 23" -15 "Jan 24" -13 "Mar 24" -11 "May 24" -9 "Jul 24" -7 "Nov 24" -5 "Jan 25" -3 "March 25" -1 "May 25" 1 "Jul 25" 3 "Sep 25" 5 "Nov 25" `pooled_pos' "Post", angle(45) labsize(small) nogrid) ///
	text(0.12 0 "VAT exemptions", box bcolor(white) lcolor(gs6) color(gs6)) ///
	text(-0.12 `text_pos' "Full pass through {&Delta}p: -9.1 p.p.", color(gs6)) ///
	legend(off) ///
	graphregion(color(white) margin(l=2 r=3 t=1 b=0)) ///
	plotregion(color(white))

	* Export graph
	* Figure A19, panel a
	graph export "$dir_graphs/figure_a19a.png" , replace
	
} // loop over we keep only items for which we have long time series only or not ends (2) 	
} // loop over criteria to define treatment and control groups ends (1)



*------------------------------------------------------------------------------*
* Event study: heterogeneity by formal vs informal stores 
*------------------------------------------------------------------------------*

foreach group in fair { // narrowed to paper spec: A19 uses group=fair
foreach items_availability in always_and_recent { // narrowed: A19b by-store-type series

* Trick 
*local group good
*local items_availability always

* Trick to create dataset to store regression results later
cap erase "$dir_tables/regression.dta"
preserve 
	clear
	set obs 1
	gen store_type = "garbage" 
	save "$dir_tables/regression.dta", replace
restore  

foreach store_type in formal informal { // loop over type of store begins (2)
* Trick
*local store_type formal
	if "`store_type'" == "formal" {
		local store_value = 1
	}
	if "`store_type'" == "informal" {
		local store_value = 0
	}
	
	* Load dataset
	use "$final_phone/product_prices_panel.dta", clear

	* Create treatment/control group category
	drop treat 
	gen treat = treat_`group'

	rename treat treated 

	* Keep only treated and control items purchased in one type of store
	keep if treated != . & formal_store == `store_value'
	
	if "`items_availability'" == "always" {
		// Keep only items for which we have long time series (exclude recently available items)
		keep if always_available == 1 
	}

	* Create post indicator
	gen post = (month_year >= 24 & month_year != .)

	* Create interaction of treated and post 
	gen treatedpost = (treated == 1 & post == 1)

	* Create the relevant outcome: relative prices (may 2025 = 1)
	bysort product: gegen price_may25 = mean(cond(month_year == 23, price_w5, .)) // the baseline price is the average price across HHs of each item in May 2025
	gen r_price = price_w5 / price_may25

	* Relative time since policy (single reform date for all items)
	gen rel_time = month_year - 24

	* Create event time (relative time but restricting months too far from VAT removal)
	gen event_time = rel_time

	local upper = 6
	local lower = -17
	replace event_time = `lower' if event_time < `lower'
	replace event_time = `upper'  if event_time > `upper' 

	/* Create an auxiliar variable that is always positive to run regression, 
	   as otherwise it will not work. This one goes from zero onwards */
	gen event_time_shift = event_time + (- `lower')

	* Set of control variables 
	*local controlvars c.quantity_w5

	* Run DID (for reference)
	reghdfe r_price treatedpost `controlvars' , absorb(product month_year) vce(cluster product)

		* Save DID estimate, SE, p-value
		local DIDcoef = _b[treatedpost]
		local DIDse = _se[treatedpost]
		local DIDp = (2 * ttail(e(df_r), abs(_b[treatedpost] / _se[treatedpost])))

	* Local to get the baseline event_time_shift
	local baseline = `lower' * (-1) - 1
	disp `baseline'

	* Run event study with product and month fixed effects excluding baseline period
	reghdfe r_price ib`baseline'.event_time_shift##i.treated `controlvars' , absorb(product month_year) vce(cluster product)

	* Pooled post-treatment effect using lincom (only coefficients that exist)
	local first_post = 0 + (- `lower')
	local last_post = `upper' + (- `lower')
	
	local lincom_expr ""
	local n_post = 0
	forvalues t = `first_post'/`last_post' {
	    capture display _b[`t'.event_time_shift#1.treated]
	    if _rc == 0 {
	        if `n_post' == 0 {
	            local lincom_expr "`t'.event_time_shift#1.treated"
	        }
	        else {
	            local lincom_expr "`lincom_expr' + `t'.event_time_shift#1.treated"
	        }
	        local n_post = `n_post' + 1
	    }
	}
	
	if `n_post' > 0 {
	    lincom (`lincom_expr') / `n_post'
	    local pooled_coef = r(estimate)
	    local pooled_se = r(se)
	    local pooled_ci_lower = `pooled_coef' - 1.96 * `pooled_se'
	    local pooled_ci_upper = `pooled_coef' + 1.96 * `pooled_se'
	}
	else {
	    local pooled_coef = .
	    local pooled_se = .
	    local pooled_ci_lower = .
	    local pooled_ci_upper = .
	}

	* Save regression results
	regsave using "$dir_tables/regression.dta", ci pval level(95) append ///
		addlabel(DIDcoef, `DIDcoef', DIDse, `DIDse', DIDp, `DIDp', ///
		         pooled_coef, `pooled_coef', pooled_se, `pooled_se', ///
		         pooled_ci_lower, `pooled_ci_lower', pooled_ci_upper, `pooled_ci_upper', ///
		         store_type, "`store_type'")

} // loop over type of store ends (2) 

* Load regression results with formal and informal event studies
use "$dir_tables/regression" , clear

* Drop the useless observation used to create the dataset
drop if store_type == "garbage"

* Define bounds
local lower = -17
local upper = 6

/* Tricks to drop useless estimates and to add an observation that is 0 
   right at event time -1 (baseline) */
drop if coef == 0
replace coef = 0 if var == "_cons"
replace ci_lower = 0 if var == "_cons"
replace ci_upper = 0 if var == "_cons"

local baseline = `lower' * (-1) - 1
replace var = "`baseline'" if var=="_cons"

* Trick to get a variable with the event time
gen leadnum = .
gen match = regexs(1) if regexm(var, "^([0-9]+)\.event_time_shift#1\.treated")
replace leadnum = real(match)
gen event_time = leadnum + `lower'

* Fix: assign event_time for the baseline observation (May 2025 = -1)
replace event_time = -1 if var == "`baseline'"

* Get pooled CI from saved results for each store type
qui sum pooled_coef if store_type == "formal"
local pooled_coef_formal = r(mean)
qui sum pooled_ci_lower if store_type == "formal"
local pooled_ci_lower_formal = r(mean)
qui sum pooled_ci_upper if store_type == "formal"
local pooled_ci_upper_formal = r(mean)

qui sum pooled_coef if store_type == "informal"
local pooled_coef_informal = r(mean)
qui sum pooled_ci_lower if store_type == "informal"
local pooled_ci_lower_informal = r(mean)
qui sum pooled_ci_upper if store_type == "informal"
local pooled_ci_upper_informal = r(mean)

display "Formal: coef=`pooled_coef_formal' CI=[`pooled_ci_lower_formal', `pooled_ci_upper_formal']"
display "Informal: coef=`pooled_coef_informal' CI=[`pooled_ci_lower_informal', `pooled_ci_upper_informal']"

* Get max event_time for pooled position
qui sum event_time
local max_event = r(max)

* Add pooled post-reform points
local pooled_pos = `max_event' + 2

* Formal pooled point
local N = _N + 1
set obs `N'
replace var = "pooled_post" in `N'
replace event_time = `pooled_pos' in `N'
replace coef = `pooled_coef_formal' in `N'
replace ci_lower = `pooled_ci_lower_formal' in `N'
replace ci_upper = `pooled_ci_upper_formal' in `N'
replace store_type = "formal" in `N'

* Informal pooled point
local N = _N + 1
set obs `N'
replace var = "pooled_post" in `N'
replace event_time = `pooled_pos' in `N'
replace coef = `pooled_coef_informal' in `N'
replace ci_lower = `pooled_ci_lower_informal' in `N'
replace ci_upper = `pooled_ci_upper_informal' in `N'
replace store_type = "informal" in `N'

* Flag for pooled points
gen is_pooled = (var == "pooled_post")

* Jitter for visibility
gen event_time_aux = event_time
replace event_time_aux = event_time - 0.1 if store_type == "formal"
replace event_time_aux = event_time + 0.1 if store_type == "informal"

sort store_type event_time 

* Define colors
global my_blue "20 97 128"
global my_red "150 39 23"

* Define event time labels for graph
label def month_lab -17 "Oct 23" -16 "Dec 23" -15 "Jan 24" -14 "Feb 24" -13 "Mar 24" -12 "Apr 24" -11 "May 24" -10 "Jun 24" -9 "Jul 24" -8 "Oct 24" -7 "Nov 24" -6 "Dec 24" -5 "Jan 25" -4 "Feb 25" -3 "March 25" -2 "Apr 25" -1 "May 25" 0 "Jun 25" 1 "Jul 25" 2 "Aug 25" 3 "Sep 25" 4 "Oct 25" 5 "Nov 25" 6 "Dec 25"
label val event_time month_lab

local text_pos = 2.5
local xline_pos = `max_event' + 1

* Graph with pooled points
twoway scatter coef event_time_aux if store_type == "formal" & is_pooled == 0, ///
	   connect(l) mlcolor("$my_blue") mfcolor("$my_blue*0.5") lcolor("$my_blue") msymbol(O) ///
	|| rcap ci_lower ci_upper event_time_aux if store_type == "formal" & is_pooled == 0, ///
	   color("$my_blue*0.8") lwidth(medium) ///
	|| scatter coef event_time_aux if store_type == "informal" & is_pooled == 0, ///
	   connect(l) mlcolor("$my_red") mfcolor("$my_red*0.5") msymbol(T) lcolor("$my_red") ///
	|| rcap ci_lower ci_upper event_time_aux if store_type == "informal" & is_pooled == 0, ///
	   color("$my_red*0.8") lwidth(medium) ///
	|| scatter coef event_time_aux if store_type == "formal" & is_pooled == 1, ///
	   mlcolor("$my_blue") mfcolor("$my_blue*0.5") msymbol(O) ///
	|| rcap ci_lower ci_upper event_time_aux if store_type == "formal" & is_pooled == 1, ///
	   color("$my_blue") lwidth(medthick) ///
	|| scatter coef event_time_aux if store_type == "informal" & is_pooled == 1, ///
	   mlcolor("$my_red") mfcolor("$my_red*0.5") msymbol(T) ///
	|| rcap ci_lower ci_upper event_time_aux if store_type == "informal" & is_pooled == 1, ///
	   color("$my_red") lwidth(medthick) ///
	, ///
	xline(-0.5, lcolor(gs6) lpattern(dash) lwidth(thin)) ///
	xline(`xline_pos', lcolor(gs6) lpattern(dot)) ///
	yline(0, lcolor(gs8) lwidth(thin)) ///
	yline(-0.091, lpattern(dash) lcolor(gs6)) ///
	caption("Price effect (p.p.)", pos(11)) ///
	xtitle("") ytitle("") ///
	ylabel(-0.3 "-30" -0.2 "-20" -0.1 "-10" 0 "0" 0.1 "10", nogrid) ///
	yscale(range(-0.32 0.15)) ///
	xlabel(-17 "Oct 23" -15 "Jan 24" -13 "Mar 24" -11 "May 24" -9 "Jul 24" -7 "Nov 24" -5 "Jan 25" -3 "March 25" -1 "May 25" 1 "Jul 25" 3 "Sep 25" 5 "Nov 25" `pooled_pos' "Post", angle(45) labsize(small) nogrid) ///
	text(0.12 0 "VAT exemptions", box bcolor(white) lcolor(gs6) color(gs6)) ///
	text(-0.12 `text_pos' "Full pass through {&Delta}p: -9.1 p.p.", color(gs6)) ///
	legend(order(1 "Formal" 3 "Informal") pos(6) rows(1) region(lstyle(none))) ///
	graphregion(color(white) margin(l=2 r=3 t=1 b=0)) ///
	plotregion(color(white))

	* Export graph
	* Figure A19, panel b
	graph export "$dir_graphs/figure_a19b.png" , replace
	
} // loop over we keep only items for which we have long time series only or not ends (2) 
} // loop over criteria to define treatment and control groups (good and fair) ends (1)


*------------------------------------------------------------------------------*
* Sections producing non-paper figures (by area; treated-only within store type)
* were removed so this script outputs only the four A19 panels.
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
* Event study: heterogeneity by store type and urban / rural areas 
*------------------------------------------------------------------------------*

foreach group in fair { // narrowed to paper spec: A19 uses group=fair

* Trick 
*local group good 

* Trick to create dataset to store regression results later
cap erase "$dir_tables/regression.dta"
preserve 
	clear
	set obs 1
	gen store_type = "garbage"
	gen area_type = "garbage" 
	save "$dir_tables/regression.dta", replace
restore  

foreach area in urban rural { // loop over area begins (2)
foreach store_type in formal informal { // loop over type of store begins (3)

	if "`area'" == "urban" {
		local area_value = 1
	}
	if "`area'" == "rural" {
		local area_value = 0
	}
	
	if "`store_type'" == "formal" {
		local store_value = 1
	}
	if "`store_type'" == "informal" {
		local store_value = 0
	}
	
	* Load dataset
	use "$final_phone/product_prices_panel.dta", clear

	* Create treatment/control group category
	drop treat 
	gen treat = treat_`group'

	rename treat treated 

	* Keep only treated and control items purchased the specific area and type of store
	keep if treated != . & urban == `area_value' & formal_store == `store_value'

	* Create post indicator
	gen post = (month_year >= 24 & month_year != .)

	* Create interaction of treated and post 
	gen treatedpost = (treated == 1 & post == 1)

	* Create the relevant outcome: relative prices (may 2025 = 1)
	bysort product: gegen price_may25 = mean(cond(month_year == 23, price_w5, .)) // the baseline price is the average price across HHs of each item in May 2025
	gen r_price = price_w5 / price_may25

	* Relative time since policy (single reform date for all items)
	gen rel_time = month_year - 24

	* Create event time (relative time but restricting months too far from VAT removal)
	gen event_time = rel_time

	local upper = 6
	local lower = -17
	replace event_time = `lower' if event_time < `lower'
	replace event_time = `upper'  if event_time > `upper' 

	/* Create an auxiliar variable that is always positive to run regression, 
	   as otherwise it will not work. This one goes from zero onwards */
	gen event_time_shift = event_time + (- `lower')

	* Set of control variables 
	*local controlvars c.quantity_w5

	* Run DID (for reference)
	reghdfe r_price treatedpost `controlvars' , absorb(product month_year) vce(cluster product)

		* Save DID estimate, SE, p-value
		local DIDcoef = _b[treatedpost]
		local DIDse = _se[treatedpost]
		local DIDp = (2 * ttail(e(df_r), abs(_b[treatedpost] / _se[treatedpost])))

	* Local to get the baseline event_time_shift
	local baseline = `lower' * (-1) - 1
	disp `baseline'

	* Run event study with product and month fixed effects excluding baseline period
	reghdfe r_price ib`baseline'.event_time_shift##i.treated `controlvars' , absorb(product month_year) vce(cluster product)

	* Pooled post-treatment effect using lincom (only coefficients that exist)
	local first_post = 0 + (- `lower')
	local last_post = `upper' + (- `lower')
	
	local lincom_expr ""
	local n_post = 0
	forvalues t = `first_post'/`last_post' {
	    capture display _b[`t'.event_time_shift#1.treated]
	    if _rc == 0 {
	        if `n_post' == 0 {
	            local lincom_expr "`t'.event_time_shift#1.treated"
	        }
	        else {
	            local lincom_expr "`lincom_expr' + `t'.event_time_shift#1.treated"
	        }
	        local n_post = `n_post' + 1
	    }
	}
	
	if `n_post' > 0 {
	    lincom (`lincom_expr') / `n_post'
	    local pooled_coef = r(estimate)
	    local pooled_se = r(se)
	    local pooled_ci_lower = `pooled_coef' - 1.96 * `pooled_se'
	    local pooled_ci_upper = `pooled_coef' + 1.96 * `pooled_se'
	}
	else {
	    local pooled_coef = .
	    local pooled_se = .
	    local pooled_ci_lower = .
	    local pooled_ci_upper = .
	}

	* Save regression results
	regsave using "$dir_tables/regression.dta", ci pval level(95) append ///
		addlabel(DIDcoef, `DIDcoef', DIDse, `DIDse', DIDp, `DIDp', ///
		         pooled_coef, `pooled_coef', pooled_se, `pooled_se', ///
		         pooled_ci_lower, `pooled_ci_lower', pooled_ci_upper, `pooled_ci_upper', ///
		         area_type, "`area'", store_type, "`store_type'")

} // loop over type of store ends (3)	
} // loop over type of store ends (2) 

* Load regression results with specific area and type of store
use "$dir_tables/regression" , clear

* Drop the useless observation used to create the dataset
drop if area_type == "garbage" | store_type == "garbage"

* Define bounds
local lower = -17
local upper = 6

/* Tricks to drop useless estimates and to add an observation that is 0 
   right at event time -1 (baseline) */
drop if coef == 0
replace coef = 0 if var == "_cons"
replace ci_lower = 0 if var == "_cons"
replace ci_upper = 0 if var == "_cons"

local baseline = `lower' * (-1) - 1
replace var = "`baseline'" if var=="_cons"

* Trick to get a variable with the event time
gen leadnum = .
gen match = regexs(1) if regexm(var, "^([0-9]+)\.event_time_shift#1\.treated")
replace leadnum = real(match)
gen event_time = leadnum + `lower'

* Fix: assign event_time for the baseline observation (May 2025 = -1)
replace event_time = -1 if var == "`baseline'"

* Get pooled CI from saved results for each area×store combination
foreach area in urban rural {
	foreach st in formal informal {
		qui sum pooled_coef if area_type == "`area'" & store_type == "`st'"
		local pooled_coef_`area'_`st' = r(mean)
		qui sum pooled_ci_lower if area_type == "`area'" & store_type == "`st'"
		local pooled_ci_lower_`area'_`st' = r(mean)
		qui sum pooled_ci_upper if area_type == "`area'" & store_type == "`st'"
		local pooled_ci_upper_`area'_`st' = r(mean)
		
		display "`area' `st': coef=`pooled_coef_`area'_`st'' CI=[`pooled_ci_lower_`area'_`st'', `pooled_ci_upper_`area'_`st'']"
	}
}

* Get max event_time for pooled position
qui sum event_time
local max_event = r(max)

* Add pooled post-reform points for each area×store combination
local pooled_pos = `max_event' + 2

foreach area in urban rural {
	foreach st in formal informal {
		local N = _N + 1
		set obs `N'
		replace var = "pooled_post" in `N'
		replace event_time = `pooled_pos' in `N'
		replace coef = `pooled_coef_`area'_`st'' in `N'
		replace ci_lower = `pooled_ci_lower_`area'_`st'' in `N'
		replace ci_upper = `pooled_ci_upper_`area'_`st'' in `N'
		replace area_type = "`area'" in `N'
		replace store_type = "`st'" in `N'
	}
}

* Flag for pooled points
gen is_pooled = (var == "pooled_post")

* Jitter for visibility
gen event_time_aux = event_time
replace event_time_aux = event_time - 0.1 if store_type == "formal"
replace event_time_aux = event_time + 0.1 if store_type == "informal"

sort area_type store_type event_time 

* Define colors
global my_blue "20 97 128"
global my_red "150 39 23"

* Define event time labels for graph
label def month_lab -17 "Oct 23" -16 "Dec 23" -15 "Jan 24" -14 "Feb 24" -13 "Mar 24" -12 "Apr 24" -11 "May 24" -10 "Jun 24" -9 "Jul 24" -8 "Oct 24" -7 "Nov 24" -6 "Dec 24" -5 "Jan 25" -4 "Feb 25" -3 "March 25" -2 "Apr 25" -1 "May 25" 0 "Jun 25" 1 "Jul 25" 2 "Aug 25" 3 "Sep 25" 4 "Oct 25" 5 "Nov 25" 6 "Dec 25"
label val event_time month_lab

local text_pos = 2.5
local xline_pos = `max_event' + 1

* Graph in urban areas
twoway scatter coef event_time_aux if area_type == "urban" & store_type == "formal" & is_pooled == 0, ///
	   connect(l) mlcolor("$my_blue") mfcolor("$my_blue*0.5") lcolor("$my_blue") msymbol(O) ///
	|| rcap ci_lower ci_upper event_time_aux if area_type == "urban" & store_type == "formal" & is_pooled == 0, ///
	   color("$my_blue*0.8") lwidth(medium) ///
	|| scatter coef event_time_aux if area_type == "urban" & store_type == "informal" & is_pooled == 0, ///
	   connect(l) mlcolor("$my_red") mfcolor("$my_red*0.5") msymbol(T) lcolor("$my_red") ///
	|| rcap ci_lower ci_upper event_time_aux if area_type == "urban" & store_type == "informal" & is_pooled == 0, ///
	   color("$my_red*0.8") lwidth(medium) ///
	|| scatter coef event_time_aux if area_type == "urban" & store_type == "formal" & is_pooled == 1, ///
	   mlcolor("$my_blue") mfcolor("$my_blue*0.5") msymbol(O) ///
	|| rcap ci_lower ci_upper event_time_aux if area_type == "urban" & store_type == "formal" & is_pooled == 1, ///
	   color("$my_blue") lwidth(medthick) ///
	|| scatter coef event_time_aux if area_type == "urban" & store_type == "informal" & is_pooled == 1, ///
	   mlcolor("$my_red") mfcolor("$my_red*0.5") msymbol(T) ///
	|| rcap ci_lower ci_upper event_time_aux if area_type == "urban" & store_type == "informal" & is_pooled == 1, ///
	   color("$my_red") lwidth(medthick) ///
	, ///
	xline(-0.5, lcolor(gs6) lpattern(dash) lwidth(thin)) ///
	xline(`xline_pos', lcolor(gs6) lpattern(dot)) ///
	yline(0, lcolor(gs8) lwidth(thin)) ///
	yline(-0.091, lpattern(dash) lcolor(gs6)) ///
	caption("Price effect (p.p.)", pos(11)) ///
	xtitle("") ytitle("") ///
	ylabel(-0.3 "-30" -0.2 "-20" -0.1 "-10" 0 "0" 0.1 "10", nogrid) ///
	yscale(range(-0.32 0.15)) ///
	xlabel(-17 "Oct 23" -15 "Jan 24" -13 "Mar 24" -11 "May 24" -9 "Jul 24" -7 "Nov 24" -5 "Jan 25" -3 "March 25" -1 "May 25" 1 "Jul 25" 3 "Sep 25" 5 "Nov 25" `pooled_pos' "Post", angle(45) labsize(small) nogrid) ///
	text(0.12 0 "VAT exemptions", box bcolor(white) lcolor(gs6) color(gs6)) ///
	text(-0.12 `text_pos' "Full pass through {&Delta}p: -9.1 p.p.", color(gs6)) ///
	legend(order(1 "Formal" 3 "Informal") pos(6) rows(1) region(lstyle(none))) ///
	graphregion(color(white) margin(l=2 r=3 t=1 b=0)) ///
	plotregion(color(white))

	graph export "$dir_graphs/figure_a19c.png" , replace
	
* Graph in rural areas
twoway scatter coef event_time_aux if area_type == "rural" & store_type == "formal" & is_pooled == 0, ///
	   connect(l) mlcolor("$my_blue") mfcolor("$my_blue*0.5") lcolor("$my_blue") msymbol(O) ///
	|| rcap ci_lower ci_upper event_time_aux if area_type == "rural" & store_type == "formal" & is_pooled == 0, ///
	   color("$my_blue*0.8") lwidth(medium) ///
	|| scatter coef event_time_aux if area_type == "rural" & store_type == "informal" & is_pooled == 0, ///
	   connect(l) mlcolor("$my_red") mfcolor("$my_red*0.5") msymbol(T) lcolor("$my_red") ///
	|| rcap ci_lower ci_upper event_time_aux if area_type == "rural" & store_type == "informal" & is_pooled == 0, ///
	   color("$my_red*0.8") lwidth(medium) ///
	|| scatter coef event_time_aux if area_type == "rural" & store_type == "formal" & is_pooled == 1, ///
	   mlcolor("$my_blue") mfcolor("$my_blue*0.5") msymbol(O) ///
	|| rcap ci_lower ci_upper event_time_aux if area_type == "rural" & store_type == "formal" & is_pooled == 1, ///
	   color("$my_blue") lwidth(medthick) ///
	|| scatter coef event_time_aux if area_type == "rural" & store_type == "informal" & is_pooled == 1, ///
	   mlcolor("$my_red") mfcolor("$my_red*0.5") msymbol(T) ///
	|| rcap ci_lower ci_upper event_time_aux if area_type == "rural" & store_type == "informal" & is_pooled == 1, ///
	   color("$my_red") lwidth(medthick) ///
	, ///
	xline(-0.5, lcolor(gs6) lpattern(dash) lwidth(thin)) ///
	xline(`xline_pos', lcolor(gs6) lpattern(dot)) ///
	yline(0, lcolor(gs8) lwidth(thin)) ///
	yline(-0.091, lpattern(dash) lcolor(gs6)) ///
	caption("Price effect (p.p.)", pos(11)) ///
	xtitle("") ytitle("") ///
	ylabel(-0.3 "-30" -0.2 "-20" -0.1 "-10" 0 "0" 0.1 "10", nogrid) ///
	yscale(range(-0.32 0.15)) ///
	xlabel(-17 "Oct 23" -15 "Jan 24" -13 "Mar 24" -11 "May 24" -9 "Jul 24" -7 "Nov 24" -5 "Jan 25" -3 "March 25" -1 "May 25" 1 "Jul 25" 3 "Sep 25" 5 "Nov 25" `pooled_pos' "Post", angle(45) labsize(small) nogrid) ///
	text(0.12 0 "VAT exemptions", box bcolor(white) lcolor(gs6) color(gs6)) ///
	text(-0.12 `text_pos' "Full pass through {&Delta}p: -9.1 p.p.", color(gs6)) ///
	legend(order(1 "Formal" 3 "Informal") pos(6) rows(1) region(lstyle(none))) ///
	graphregion(color(white) margin(l=2 r=3 t=1 b=0)) ///
	plotregion(color(white))

	graph export "$dir_graphs/figure_a19d.png" , replace
	

} // loop over criteria to define treatment and control groups (good and fair) ends (1)
