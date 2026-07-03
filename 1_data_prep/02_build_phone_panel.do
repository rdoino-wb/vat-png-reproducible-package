/*==============================================================================
 02_build_phone_panel.do
 VAT exemption pass-through and incidence (Papua New Guinea) — data preparation

 PURPOSE : Build the household phone-survey dataset and the product-month price
           panel (income quintiles, winsorized prices, treatment groups, labels).
 INPUTS  : ${raw_phone}/20260429/PNG_HFPS_Household_weighted_wFood.dta
 OUTPUTS : ${final_phone}/final_dataset.dta
           ${final_phone}/product_prices_panel.dta
 DEPENDS : 01_globals.do (runs before this; geographic labels ship with the raw data)
 CALLED BY: main.do
==============================================================================*/

clear all

* Install Packages
// ssc install winsor2, replace

display as text _newline "=== STARTING DATA PREPARATION SCRIPT ===" _newline

* Load dataset
display "Loading raw data..."
use "${raw_phone}/20260429/PNG_HFPS_Household_weighted_wFood.dta" , clear
display "Data loaded successfully" _newline

*------------------------------------------------------------------------------*
* Adjust survey waves and labels
*------------------------------------------------------------------------------*

display "Adjusting survey waves and labels..."

* Correct and label month_year variable

label drop month_year

label define month_year ///
    24 "25 Jun" ///
    25 "25 Jul" ///
    26 "25 Aug" ///
    27 "25 Sep" ///
    28 "25 Oct" ///
    29 "25 Nov" ///
    30 "25 Dec" ///
    31 "26 Jan" ///
    32 "26 Feb" ///
    33 "26 Mar" ///
    34 "26 Apr" ///
    35 "26 May" ///
    36 "26 Jun"

label values month_year month_year

display "Survey waves adjusted" _newline

*------------------------------------------------------------------------------*
* HH income
*------------------------------------------------------------------------------*

display "Creating household income variables..."

* Goal: create a measure of total HH income

/* Step 1: make old and new income variables compatible, and transform categorical 
           variable into money, taking the middle point, e.g., if categorical 
		   variable indicates 250-500, we assign $375 */
		   
foreach var in s5q02 s5q05 s5q08 s5q11 s5q14 {
	
	quietly gen `var'_inc_old = .
		quietly replace `var'_inc_old = (100 - 0) / 2 if `var'_old == 1 
		quietly replace `var'_inc_old = 100 + (250 - 100) / 2 if `var'_old == 6
		quietly replace `var'_inc_old = (250 - 0) / 2 if `var'_old1 == 1
		quietly replace `var'_inc_old = 250 + (500 - 250) / 2 if `var'_old == 2 | `var'_old1 == 2
		quietly replace `var'_inc_old = 500 + (1000 - 500) / 2 if `var'_old == 3 | `var'_old1 == 3
		quietly replace `var'_inc_old = 1000 + (2000 - 1000) / 2 if `var'_old == 4 | `var'_old1 == 4
		quietly replace `var'_inc_old = 2500 if `var'_old == 5 | `var'_old1 == 5
		quietly replace `var'_inc_old = . if `var'_old < 0 | `var'_old1 < 0
		
	quietly gen `var'_inc = .
		quietly replace `var'_inc = `var' if `var' != .
		quietly replace `var'_inc = `var'_inc_old if `var' == . & `var'_inc_old != .
		
}

* Rename income items
rename s5q02_inc farming_inc
rename s5q05_inc business_inc
rename s5q08_inc wage_inc
rename s5q11_inc family_inc
rename s5q14_inc other_inc 

* Step 2: create total HH income (sum of all items)
quietly gegen total_inc = rowtotal(farming_inc business_inc wage_inc family_inc other_inc)
	* there is no income data before october 2023, so replace those with missing
	quietly recode total_inc (0 = .) if month_year < 7 

display "Income variables created" _newline
	
*------------------------------------------------------------------------------*
* HH income quintiles
*------------------------------------------------------------------------------*

display "Creating income quintiles (Strategy 1: average monthly income)..."

* Goal: create income quintiles in a few different ways
/* We want to create quintiles based on income from 2024 and assign HH accordingly */ 
	

* Strategy 1: quintiles based on average monthly income in 2024
*------------------------------------------------------------------------------*

// Create average monthly income in each year
foreach x in 23 24 25 {
	quietly egen avg_inc_`x' = mean(cond(year == 20`x', total_inc, .)) , by(hhid_full) 
}

// Create quintiles based on average monthly income in 2024
preserve 
	// collapse to get one obs per HH that participated in 2024 with their corresponding avg. monthly income of 2024
	quietly collapse (mean) avg_inc_24 , by(hhid_full)
	
	// save thresholds (r(r1) r(r2) r(r3) r(r4))
	quietly _pctile avg_inc_24 , p(20, 40, 60, 80)
	local q1 = r(r1)
	local q2 = r(r2)
	local q3 = r(r3)
	local q4 = r(r4)

restore 

scalar q1a = `q1'
scalar q2a = `q2'
scalar q3a = `q3'
scalar q4a = `q4'

// Assign HHs in 2024 to their quintile in 2024
quietly gen quintile_aux = . 
	quietly replace quintile_aux = 1 if avg_inc_24 < q1a & year == 2024
	quietly replace quintile_aux = 2 if avg_inc_24 >= q1a & avg_inc_24 < q2a & year == 2024
	quietly replace quintile_aux = 3 if avg_inc_24 >= q2a & avg_inc_24 < q3a & year == 2024
	quietly replace quintile_aux = 4 if avg_inc_24 >= q3a & avg_inc_24 < q4a & year == 2024
	quietly replace quintile_aux = 5 if avg_inc_24 >= q4a & avg_inc_24 != . & year == 2024

		
// Assign all HHs to their quintile in 2024
quietly gegen quintile_a = mean(quintile_aux) , by(hhid_full)

// Assign remaining unassigned HH to quintiles (those that did not participate in 2024, so quintile_a = missing):

	// Identify in which year the HH started participating in the survey
	quietly egen min_year = min(year) , by(hhid_full)
	
	/* For HH that did not participate in 2024, use the avg monthly income if their first year to
	   assing them to quintiles */
	foreach x in 23 25 {

		quietly replace quintile_a = 1 if avg_inc_`x' < q1a & avg_inc_`x' != .  & quintile_a == . & min_year == 20`x' 
		quietly replace quintile_a = 2 if avg_inc_`x' >= q1a & avg_inc_`x' < q2a &  quintile_a == . & min_year == 20`x' 
		quietly replace quintile_a = 3 if avg_inc_`x' >= q2a & avg_inc_`x' < q3a &  quintile_a == . & min_year == 20`x' 
		quietly replace quintile_a = 4 if avg_inc_`x' >= q3a & avg_inc_`x' < q4a &  quintile_a == . & min_year == 20`x' 
		quietly replace quintile_a = 5 if avg_inc_`x' >= q4a & avg_inc_`x' !=. &  quintile_a == . & min_year == 20`x' 
	}
	
label def q_lab 1 "Quintile 1" 2 "Quintile 2" 3 "Quintile 3" 4 "Quintile 4" 5 "Quintile 5"
label val quintile_a q_lab

display "Strategy 1 complete"

* Strategy 2: 
*------------------------------------------------------------------------------*

display "Creating income quintiles (Strategy 2: core households)..."

* Create quintiles based on the average monthly income of "core HHs", those present in the first wave of 2024

//  Core HHs are those present in Jan 2024 --> month_year == 9

// Create thresholds based on average income in 2024 of core HHs
quietly _pctile avg_inc_24 if month_year == 9, p(20, 40, 60, 80)
	scalar q1b = r(r1)
	scalar q2b = r(r2)
	scalar q3b = r(r3)
	scalar q4b = r(r4)

// Assign HHs in 2024 to their quintile in 2024	
cap drop quintile_aux
quietly gen quintile_aux = . 
	quietly replace quintile_aux = 1 if avg_inc_24 < q1b & year == 2024
	quietly replace quintile_aux = 2 if avg_inc_24 >= q1b & avg_inc_24 < q2b & year == 2024
	quietly replace quintile_aux = 3 if avg_inc_24 >= q2b & avg_inc_24 < q3b & year == 2024
	quietly replace quintile_aux = 4 if avg_inc_24 >= q3b & avg_inc_24 < q4b & year == 2024
	quietly replace quintile_aux = 5 if avg_inc_24 >= q4b & avg_inc_24 != . & year == 2024

// Assign all HHs to their quintile in 2024
quietly gegen quintile_b = mean(quintile_aux) , by(hhid_full)

// Assign remaining unassigned HH to quintiles (those that did not participate in 2024, so quintile_a = missing)
	
	/* For HH that did not participate in 2024, use the avg monthly income if their first year to
	   assing them to quintiles */
	foreach x in 23 25 {

		quietly replace quintile_b = 1 if avg_inc_`x' < q1b & avg_inc_`x' != .  & quintile_b == . & min_year == 20`x' 
		quietly replace quintile_b = 2 if avg_inc_`x' >= q1b & avg_inc_`x' < q2b &  quintile_b == . & min_year == 20`x' 
		quietly replace quintile_b = 3 if avg_inc_`x' >= q2b & avg_inc_`x' < q3b &  quintile_b == . & min_year == 20`x' 
		quietly replace quintile_b = 4 if avg_inc_`x' >= q3b & avg_inc_`x' < q4b &  quintile_b == . & min_year == 20`x' 
		quietly replace quintile_b = 5 if avg_inc_`x' >= q4b & avg_inc_`x' !=. &  quintile_b == . & min_year == 20`x' 
	}

display "Strategy 2 complete"

/* Strategy 3: calculate quintile thresholds for each month of 2024, average them,
               and use them assign HHs to their 2024 quintile */
*------------------------------------------------------------------------------*

display "Creating income quintiles (Strategy 3: average monthly thresholds)..."

// Create thresholds for each month and then take the 2024 average thresholds to create quintiles
forvalues x = 9/18 {
	
	quietly _pctile total_inc if month_year == `x', p(20, 40, 60, 80)
		local q1_`x' = r(r1)
		local q2_`x' = r(r2)
		local q3_`x' = r(r3)
		local q4_`x' = r(r4)
}

forvalues i = 1/4 {
	scalar q`i'c = (`q`i'_9 '+ `q`i'_10' + `q`i'_11' + `q`i'_12' + `q`i'_13' + `q`i'_14' + `q`i'_15' + `q`i'_16' + `q`i'_17' + `q`i'_18') / 10
}

// Assign HHs in 2024 to their quintile in 2024	
cap drop quintile_aux
quietly gen quintile_aux = . 
	quietly replace quintile_aux = 1 if avg_inc_24 <= q1c & year == 2024
	quietly replace quintile_aux = 2 if avg_inc_24 > q1c & avg_inc_24 < q2c & year == 2024
	quietly replace quintile_aux = 3 if avg_inc_24 >= q2c & avg_inc_24 < q3c & year == 2024
	quietly replace quintile_aux = 4 if avg_inc_24 >= q3c & avg_inc_24 < q4c & year == 2024
	quietly replace quintile_aux = 5 if avg_inc_24 >= q4c & avg_inc_24 != . & year == 2024
	
// Assign all HHs to their quintile in 2024
quietly gegen quintile_c = mean(quintile_aux) , by(hhid_full)

// Assign remaining unassigned HH to quintiles (those that did not participate in 2024, so quintile_a = missing)
	
	/* For HH that did not participate in 2024, use the avg monthly income if their first year to
	   assing them to quintiles */
	foreach x in 23 25 {

		quietly replace quintile_c = 1 if avg_inc_`x' <= q1c & avg_inc_`x' != .  & quintile_c == . & min_year == 20`x'
		quietly replace quintile_c = 2 if avg_inc_`x' > q1c & avg_inc_`x' < q2c &  quintile_c == . & min_year == 20`x' 
		quietly replace quintile_c = 3 if avg_inc_`x' >= q2c & avg_inc_`x' < q3c &  quintile_c == . & min_year == 20`x' 
		quietly replace quintile_c = 4 if avg_inc_`x' >= q3c & avg_inc_`x' < q4c &  quintile_c == . & min_year == 20`x' 
		quietly replace quintile_c = 5 if avg_inc_`x' >= q4c & avg_inc_`x' != . &  quintile_c == . & min_year == 20`x' 
	}
	
quietly drop quintile_aux

display "Strategy 3 complete"
display "All quintile strategies completed" _newline

*------------------------------------------------------------------------------*
* Fix food items variables
*------------------------------------------------------------------------------*

display "Fixing food items variables..."

/* replace with missing quantities, type of store, and expenditure in waves that 
   questions about the item was asked only to a few HHs for some reason
   (for some reasons this happens with some of the recently added items) */
 
local products 101 102 103 104 105 107 108 110 111 114 115 116 124 125 126 127 128 129 130 131 132 133 134 135

* For each product, blank a month's records when fewer than 300 households
* reported the item that month (thin, recently added items). Vectorized by month:
* one egen pass per product replaces the old month-by-month count loop.
foreach q in `products' {
	quietly bysort month_year: egen _nobs = count(s4q1`q')
	foreach v in 1 2 3 5 {
		quietly replace s4q`v'`q' = . if _nobs < 300
	}
	quietly drop _nobs
}

display "Food items variables fixed" _newline
	

*------------------------------------------------------------------------------*
* Type of shop
*------------------------------------------------------------------------------*

display "Creating formal/informal store indicators..."

local products 101 102 103 104 105 107 108 110 111 114 115 116 124 125 126 127 128 129 130 131 132 133 134 135

foreach q in `products' {
	quietly gen formal_store_`q' = .
		quietly replace formal_store_`q' = 1 if s4q2`q' == 2
		quietly replace formal_store_`q' = 0 if s4q2`q' != . & s4q2`q' != 2 & s4q2`q' != 99
}

display "Store type indicators created" _newline

*------------------------------------------------------------------------------*
* Sex
*------------------------------------------------------------------------------*

display "Recoding sex variables..."

* Recode sex variables so they are all dummies = 1 if male and 0 otherwise
recode resp_sex (2 = 0)
label values resp_sex head_sex

display "Sex variables recoded" _newline

*------------------------------------------------------------------------------*
* Education level
*------------------------------------------------------------------------------*

display "Creating simplified education variable..."

* Simplify the education of the head of HH by reducing the number of categories
rename head_educ head_educ_original
gen head_educ = head_educ_original
	recode head_educ (2/3 = 1) (4 = 2) (5 = 3) (7 = 4) (6 = 5) (8 = 5)
	lab def educ_lab 1 "≤Elementary" 2 "Primary" 3 "Secondary" 4 "Tertiary/other higher" 5 "Vocational/other"
	lab val head_educ educ_lab

display "Education variable created" _newline

*------------------------------------------------------------------------------*
* Region
*------------------------------------------------------------------------------*

rename urbrur urban

*------------------------------------------------------------------------------*
* Other changes
*------------------------------------------------------------------------------*

display "Making final adjustments..."

rename RESPTYPE resptype

* Keep only the panel period of the survey
quietly keep if month_year >= 7

* Create number of times the HH participates in the survey
quietly gegen survey_participations = count(hhid_full) , by(hhid_full)

display "Final adjustments complete" _newline

*------------------------------------------------------------------------------*
* Product prices 
*------------------------------------------------------------------------------*

display "Creating product prices with winsorization..."

/* We will use two main set of variables to calculate prices:
   - units purchased (s4q3*)
   - money spent on quantity purchased (s4q5*) */

* Recode -99 values, which correspond to "don't know/remember"  
quietly recode s4q3* (-99 = .)
quietly recode s4q5* (-99 = .)

* Create prices varying the winsorizing levels

foreach win_level in 1 5 {
	
	display "  Winsorizing level `win_level'%..."
		
	local products 101 102 103 104 105 107 108 110 111 114 115 116 124 125 126 127 128 129 130 131 132 133 134 135

	if "`win_level'" == "1" {
		local top 99
		local bottom 1
	}
	if "`win_level'" == "5" {
		local top 95
		local bottom 5
	}
	
	* Build the variable lists once, then winsorize in batched calls. winsor2
	* treats each variable independently, so batching matches one call per variable.
	local exp_vars ""
	local qty_vars ""
	foreach q in `products' {
		local exp_vars `exp_vars' s4q5`q'
		local qty_vars `qty_vars' s4q3`q'
	}
	quietly winsor2 `exp_vars', cuts(`bottom' `top') suffix(_w`win_level')
	quietly winsor2 `qty_vars', cuts(`bottom' `top') suffix(_w`win_level')

	local price_vars ""
	foreach q in `products' {
		quietly gen price_`q'_w`win_level' = s4q5`q'_w`win_level' / s4q3`q'_w`win_level'
		local price_vars `price_vars' price_`q'_w`win_level'
	}
	quietly winsor2 `price_vars', cuts(`bottom' `top') replace
	
	display "    All 24 products processed for level `win_level'%"

	* Step 3: Express prices in terms of relevant quantities for each product
	quietly replace price_101_w`win_level' = price_101_w`win_level' * 1000
	quietly replace price_104_w`win_level' = price_104_w`win_level' * 100
	quietly replace price_107_w`win_level' = price_107_w`win_level' * 100
	quietly replace price_114_w`win_level' = price_114_w`win_level' * 100
}

display "Product prices created" _newline

*------------------------------------------------------------------------------*
* Save dataset 
*------------------------------------------------------------------------------*

display "Saving final dataset..."

* Save dataset
save "${final_phone}/final_dataset.dta" , replace

display "Dataset saved: final_dataset.dta" _newline
	

	
********************************************************************************
* Create a panel at the product month level
********************************************************************************

display "=== CREATING PRODUCT-MONTH PANEL ===" _newline

* Load dataset
display "Loading final dataset..."
use "${final_phone}/final_dataset.dta" , clear

* Create auxiliar dataset: panel by product-month with prices_w1
display "Creating panel with w1 prices..."
preserve 

	quietly drop *w5
	quietly drop PricePer*
	quietly drop if month_year == .
	
	local products 101 102 103 104 105 107 108 110 111 114 115 116 124 125 126 127 128 129 130 131 132 133 134 135
	foreach q in `products' {
		quietly drop s4q3`q'
		quietly drop s4q5`q'
	}

	quietly ds price_* s4q3* s4q5*
	foreach var of varlist `r(varlist)' {
		local newname = subinstr("`var'", "_w1", "", 1)
		quietly rename `var' `newname'
	}

	quietly keep hhid_full month_year urban head_sex head_educ resptype price_* formal_store* survey_participations s4q3* s4q5* quintile_a

	quietly reshape long price_ formal_store_ s4q3 s4q5 , i(hhid_full month_year) j(product) string	
	
	rename price_ price_w1
	rename s4q3 quantity_w1
	rename s4q5 expenditure_w1
	rename formal_store_ formal_store

	quietly save "${final_phone}/product_panel_w1.dta" , replace 

restore 

display "Panel w1 created"

* Create auxiliar dataset: panel by product-month with prices_w5
display "Creating panel with w5 prices..."
preserve 
	quietly drop *w1
	quietly drop PricePer*
	quietly drop if month_year == .
	
	local products 101 102 103 104 105 107 108 110 111 114 115 116 124 125 126 127 128 129 130 131 132 133 134 135
	foreach q in `products' {
		quietly drop s4q3`q'
		quietly drop s4q5`q'
	}
	
	quietly ds price_* s4q3* s4q5*
	foreach var of varlist `r(varlist)' {
		local newname = subinstr("`var'", "_w5", "", 1)
		quietly rename `var' `newname'
	}
	
	quietly keep hhid_full month_year urban head_sex head_educ resptype price_* formal_store* survey_participations s4q3* s4q5* quintile_a

	quietly reshape long price_ formal_store_ s4q3 s4q5 , i(hhid_full month_year) j(product) string	
	
	rename price_ price_w5
	rename s4q3 quantity_w5
	rename s4q5 expenditure_w5
	rename formal_store_ formal_store
	
	quietly save "${final_phone}/product_panel_w5.dta" , replace 

restore 

display "Panel w5 created"

* Merge two auxiliar datasets
display "Merging w1 and w5 panels..."
use "${final_phone}/product_panel_w1.dta" , clear 
quietly merge 1:1 hhid_full month_year product using "${final_phone}/product_panel_w5.dta", gen(mer_prices)

quietly drop mer_prices 

* Drop observations that don't have prices (because the HH didn't buy that product that month)
quietly drop if price_w1 == . & price_w5 == .

/* Now we have a panel at the product-month level with information on prices
   for winsorzing levels w1 and w5 */

display "Panels merged successfully"

* Drop auxiliar datasets
display "Cleaning up temporary files..."
erase "${final_phone}/product_panel_w1.dta" 
erase "${final_phone}/product_panel_w5.dta" 

display "Temporary files removed" _newline

*------------------------------------------------------------------------------*
* Adjust a few variables
*------------------------------------------------------------------------------*

display "Adjusting panel variables..."

quietly destring product, replace

* Create treatment/control group category
quietly gen treat = .
	quietly replace treat = 1 if product == 104 | product == 105 | product == 107 | product == 108 ///
						   | product == 110 | product == 114 | product == 116 | product == 131 ///
						   | product == 132 | product == 133
	quietly replace treat = 0 if product == 102 | product == 111 | product == 101 | product == 115 ///
					   | product == 103 | product == 126 | product == 127 | product == 128 ///
					   | product == 129 | product == 130 

/* Create alternative treatment/control group categories */

* First with items in "good" category only 
quietly gen treat_good = .
	quietly replace treat_good = 1 if product == 104 | product == 105 | product == 107 | product == 108 ///
						    | product == 110 | product == 116 | product == 131 ///
						    | product == 132 
	quietly replace treat_good = 0 if product == 102 | product == 111 | product == 101 | product == 115 ///
							| product == 103

* Second with items in "good" and "fair" categories only 
quietly gen treat_fair = .
	quietly replace treat_fair = 1 if product == 104 | product == 105 | product == 107 | product == 108 ///
						    | product == 110 | product == 116 | product == 131 ///
						    | product == 132 
	quietly replace treat_fair = 0 if product == 102 | product == 111 | product == 101 | product == 115 ///
							| product == 103 | product == 129 | product == 130
							
* Finally with items in "good" category only but excluding bananas
quietly gen treat_good_nobanana = .
	quietly replace treat_good_nobanana = 1 if product == 104 | product == 105 | product == 107 | product == 108 ///
						    | product == 110 | product == 116 | product == 131 ///
						    | product == 132 
	quietly replace treat_good_nobanana = 0 if product == 102 | product == 111 | product == 101 | product == 115 

* This is useful for some loops later 
quietly gen treat_all = treat

* Create a more general variable that indicate the group (including those that do not belong to either treatment or control groups)
quietly gen item_group = .
	quietly replace item_group = 1 if treat == 1
	quietly replace item_group = 2 if treat == 0
	quietly replace item_group = 3 if treat == .

display "Treatment variables created"
	
* Create luxury/non-luxury category for food items
display "Creating luxury good indicators..."

quietly egen total_q = total(quantity_w5) , by(product)
quietly egen total_q_q1 = total(cond(quintile_a == 1, quantity_w5, .)) , by(product)
quietly egen total_q_q3 = total(cond(quintile_a == 3, quantity_w5, .)) , by(product)
quietly egen total_q_q5 = total(cond(quintile_a == 5, quantity_w5, .)) , by(product)

quietly replace total_q_q3 = . if total_q_q3 == 0 
quietly replace total_q_q5 = . if total_q_q5 == 0 

quietly gen share_q_q1 = total_q_q1 / total_q
quietly gen share_q_q3 = total_q_q3 / total_q
quietly gen share_q_q5 = total_q_q5 / total_q
quietly gen share_q_q3_third = (total_q_q3 / total_q) / 2
quietly gen share_q_q5_third = (total_q_q5 / total_q) / 3

quietly gen luxury = .
quietly replace luxury = 1 if share_q_q1 < share_q_q5_third
quietly replace luxury = 0 if share_q_q1 >= share_q_q5_third & share_q_q1 != .
quietly replace luxury = 2 if share_q_q5 == .

quietly drop share_q_*
quietly drop total_q_* total_q

display "Luxury indicators created"

* Create indicator of whether the item has long time series (always) or is recently available (recent)
display "Creating availability indicators..."

quietly gen always_available = .
quietly bysort product: egen _first_month = min(month_year)
quietly replace always_available = 1 if _first_month < 10
quietly replace always_available = 0 if _first_month > 20
quietly drop _first_month

display "Availability indicators created" _newline

********************************************************************************
* PANEL VARIABLE LABELS & VALUE LABELS
********************************************************************************

display "Applying variable labels and value labels..."

* Value label for items/products
label define items_lab ///
    101 "sugar" ///
    102 "kaukau" ///
    103 "bananas" ///
    104 "cooking oil" ///
    105 "rice" ///
    107 "tinned fish" ///
    108 "tea" ///
    110 "flour" ///
    111 "aibika" ///
    114 "tinned beef" ///
    115 "sausages" ///
    116 "whole live chicken" ///
    124 "petrol" ///
    125 "phone credit" ///
    126 "tinned baked beans" ///
    127 "powdered milk" ///
    128 "breakfast cereal" ///
    129 "butter" ///
    130 "milo" ///
    131 "noodles" ///
    132 "biscuits" ///
    133 "coffee" ///
    134 "broccoli" ///
    135 "salt", replace

* Value label for store type
label def store_lab 1 "Formal" 0 "Informal"

* Value label for treatment status
label def treat_lab 1 "Treatment" 0 "Control"

* Value label for item group
label def group_lab 1 "Treatment" 2 "Control" 3 "None"

* Value label for luxury goods
label def lux_lab 0 "Basic" 1 "Quasi-luxury" 2 "Other"

* Value label for proximity intensity (added by R script)
label def proximity_lab 1 "Low" 2 "Medium" 3 "High"

* Variable labels
label var formal_store "Dummy indicating whether HH purchased the item at a formal store recently"
label var head_educ "Education level of head of HH"
label var survey_participations "Number of times the HH participated in the phone survey"
label var price_w1 "Price (winsorizing top and bottom 1%)"
label var price_w5 "Price (winsorizing top and bottom 5%)"
label var treat "Dummy indicating treatment group (1 if treated, 0 if control)"
label var item_group "Item group category: treatment, control, none"
label var luxury "Luxury good (quintile 1 share < 1/3 of quintile 5 share)"
label var treat_good "Treatment indicator based on good items only"
label var treat_fair "Treatment indicator based on good and fair items only"
label var treat_all "Treatment indicator based on all items"
label var treat_good_nobanana "Treatment indicator based on good items only, excluding bananas"
label var always_available "Indicator that the item has been avilable in all survey rounds (not just recently available)"

display "Labels applied" _newline

*------------------------------------------------------------------------------*
* Save dataset 
*------------------------------------------------------------------------------*

display "Saving final product panel..."

* Save dataset
save "${final_phone}/product_prices_panel.dta" , replace

display "Dataset saved: product_prices_panel.dta" _newline

display as text "=== SCRIPT COMPLETED SUCCESSFULLY ===" _newline
