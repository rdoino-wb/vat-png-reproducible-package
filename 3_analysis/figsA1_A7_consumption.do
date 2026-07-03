/*==============================================================================
 figsA1_A7_consumption.do
 VAT exemption pass-through and incidence (Papua New Guinea) — analysis

 PURPOSE : Descriptive consumption/expenditure figures by income quintile
           (formal/informal/own-production shares, quantity and expenditure by
           item and quintile, basic vs quasi-luxury spending) for Figures A1-A7.
 INPUTS  : ${final_phone}/final_dataset.dta;
           ${final_phone}/product_prices_panel.dta;
           ${final_phone}/temp/basic_luxury_items.dta (built inline below)
 OUTPUTS : $dir_graphs/figure_a1.png ... figure_a7.png;
           ${final_phone}/temp/basic_luxury_items.dta (intermediate)
 DEPENDS : run from main.do after data prep (final_dataset and product_prices_panel built upstream)
 CALLED BY: main.do
==============================================================================*/

*------------------------------------------------------------------------------*
* Palette and general graph rules (white background, no grid, thin white edges).
* my_* mirror 01_globals.do; redefined so the file runs alone.
*------------------------------------------------------------------------------*
global my_blue  "20 97 128"
global my_red   "150 39 23"
global my_green "0 166 118"

* Clean quintile palette Q1..Q5 (sampled from the reference figure; also the
* first five colors of the item cycle used in A2, so panels stay consistent).
global q1 "26 133 255"
global q2 "212 17 89"
global q3 "0 191 127"
global q4 "255 212 0"
global q5 "79 44 153"

* White plot/graph regions, injected into every exported figure below.
global wbg "graphregion(color(white)) plotregion(color(white))"

* Quintile bar-color option string (5 stacked series), reused by A1 and A5.
global qbars `"bar(1, fcolor("$q1") lcolor("$q1")) bar(2, fcolor("$q2") lcolor("$q2")) bar(3, fcolor("$q3") lcolor("$q3")) bar(4, fcolor("$q4") lcolor("$q4")) bar(5, fcolor("$q5") lcolor("$q5"))"'

*------------------------------------------------------------------------------*
* Share of formal/informal/own consumption by quintile
*------------------------------------------------------------------------------*	
  
/* The only way of doing this is to first take the percent of consumption from
   own production (s4aq3a). Then take the total expenditure on food, and take the
   formal / informal proportions.  */


* Load dataset
use "${final_phone}/final_dataset.dta" , clear

local products 101 102 103 104 105 107 108 110 111 114 115 116 124 125 126 127 128 129 130 131 132 133 134 135

* Proportion of food consumption from own prodution (approximation)
gen own_prod = . 
	replace own_prod = 0 if s4aq3a == 0
	replace own_prod = 12.5 if s4aq3a == 1 // 1% - 25%
	replace own_prod = 37.5 if s4aq3a == 2 // 26% - 50%
	replace own_prod = 62.5 if s4aq3a == 3 // 51% - 75%
	replace own_prod = 87.5 if s4aq3a == 4
	
* Proportion of food consumption formal / informal 
// The best way is to proxy this using expenditure
local products 101 102 103 104 105 107 108 110 111 114 115 116 124 125 126 127 128 129 130 131 132 133 134 135

* Recode -99 values, which correspond to "don't know/remember"  
recode s4q3* (-99 = .)
recode s4q5* (-99 = .)

* Winsorize bottom and top 1%
foreach q in `products' {
	sum s4q5`q' if  s4q5`q' > 0 & s4q5`q' != ., d 
	replace s4q5`q' = r(p99) if s4q5`q' > r(p99) & s4q5`q' != .
	replace s4q5`q' = r(p1) if s4q5`q' < r(p1) & s4q5`q' != .
}

// Step 2: Generate total expenditure by type of store
foreach q in `products' {
	gen exp_`q'_formal = .
	replace exp_`q'_formal = s4q5`q' if formal_store_`q' == 1 
	gen exp_`q'_informal = .
	replace exp_`q'_informal = s4q5`q' if formal_store_`q' == 0
}

gegen cons_exp_formal = rowtotal(exp_101_formal exp_102_formal exp_103_formal exp_104_formal exp_105_formal exp_107_formal ///
								 exp_108_formal exp_110_formal exp_111_formal exp_114_formal exp_115_formal exp_116_formal ///
								 exp_124_formal exp_125_formal exp_126_formal exp_127_formal exp_128_formal exp_129_formal  ///
								 exp_130_formal exp_131_formal exp_132_formal exp_133_formal exp_134_formal exp_135_formal)
								 
gegen cons_exp_informal = rowtotal(exp_101_informal exp_102_informal exp_103_informal exp_104_informal exp_105_informal exp_107_informal ///
								 exp_108_informal exp_110_informal exp_111_informal exp_114_informal exp_115_informal exp_116_informal ///
								 exp_124_informal exp_125_informal exp_126_informal exp_127_informal exp_128_informal exp_129_informal ///
								 exp_130_informal exp_131_informal exp_132_informal exp_133_informal exp_134_informal exp_135_informal)

gegen cons_exp = rowtotal (cons_exp_formal cons_exp_informal)

// Step 3: Generate proportion of total expenditure that is formal / informal							 
gen exp_prop_formal = (cons_exp_formal / cons_exp) * 100
gen exp_prop_informal = 100 - exp_prop_formal


// Step 4: collapse by quintile
collapse (mean) exp_prop_formal exp_prop_informal own_prod , by(quintile_a)
drop if quintile_a == .
gen base = 0
gen max = 100
gen quintile_low = quintile_a - 0.15
gen quintile_high = quintile_a + 0.15

twoway rbar exp_prop_formal base quintile_a, barwidth(0.3) fcolor("$my_blue*0.8") lcolor("$my_blue*1.2") ///
	|| rbar max exp_prop_formal quintile_a, barwidth(0.3) fcolor("$my_red*0.8") lcolor("$my_red*1.2") ///
	|| scatter own_prod quintile_a, connect(l) mlcolor("$my_green") mfcolor("$my_green") msize(medlarge) lcolor("$my_green") lwidth(medthick) ///
	title("Type of consumption/expenditure by quintile", size(medsmall)) xtitle("") ytitle("") ///
	ylab(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", nogrid) ///
	xlab(, valuelabel nogrid) ///
	legend(pos(6) rows(1) region(lcolor(none)) order(1 "Formal expenditure" 2 "Informal expenditure" 3 "Own production")) ///
	${wbg}
graph export "$dir_graphs/figure_a7.png" , replace width(2400)

	
	
*------------------------------------------------------------------------------*
* Relative incidence summary:
* quantity purchased by item and quintile,
* summary with all items
*------------------------------------------------------------------------------*	


* Load dataset
use "${final_phone}/final_dataset.dta" , clear
 
local products 101 102 103 104 105 107 108 110 111 114 115 116 124 125 126 127 128 129 130 131 132 133 134 135

* collapse total quantity purhased of each item by quintile
collapse (sum) s4q3*_w5 , by(quintile_a)

drop if quintile_a == .


foreach q in `products' {
	* Trick
	*local q 101
	gegen total_`q' = total(s4q3`q'_w5)
	gen prop_`q' = (s4q3`q'_w5 / total_`q' ) * 100
	rename s4q3`q'_w5 s4q3`q'
}
drop total* s4q3*

reshape long prop_ , i(quintile_a) j(product) string
reshape wide prop_ , i(product) j(quintile_a)

destring product , replace

lab def product_lab 101 "sugar" 102 "kaukau" 103 "bananas" 104 "cooking oil" 105 "rice" 107 "tinned fish" ///
					108 "tea" 110 "flour" 111 "aibika" 114 "tinned beef" 115 "sausages" 116 "chicken" 124 "petrol" ///
					125 "phone credit" 126 "tinned baked beans" 127 "powdered milk" 128 "breakfast cereal" 129 "butter" ///
					130 "milo" 131 "noodles" 132 "biscuits" 133 "coffee" 134 "broccoli" 135 "salt"
lab val product product_lab

* Bar graph
graph bar prop_*  , over(product, label(valuelabel labsize(small) angle(45))) stack ///
	title("Food purchased by item and quintile (in quantity)", size(medsmall)) ///
	ylab(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", nogrid) ///
	legend(pos(6) rows(1) region(lcolor(none)) ///
	order(1 "Quintile 1" 2 "Quintile 2" 3 "Quintile 3" 4 "Quintile 4" 5 "Quintile 5")) ///
	${qbars} ${wbg}

	graph export "$dir_graphs/figure_a5.png" , replace width(2400)
	
	
*------------------------------------------------------------------------------*
* Relative formal / informal split summary:
* summary for all items
*------------------------------------------------------------------------------*	

* Load dataset
use "${final_phone}/product_prices_panel.dta" , clear

drop if formal_store == .

collapse (sum) quantity_w5  , by(product formal_store)

bysort product: egen total_quantity = total(quantity_w5)
gen percent = (quantity_w5 / total_quantity ) * 100

* Prepare data structure for graph 
drop total_quantity quantity_w5
rename percent percent_
reshape wide percent_ , i(product) j(formal_store)

* Locals for title
local globalname = "item_`q'" 
local goodlabel = "$`globalname'"
local globalname = "food_`q'"
local foodlabel = "$`globalname'"	

* Graph
graph bar percent_1 percent_0, over(product, label(labsize(small) angle(45)) ) stack ///
	  title("Summary of quantity purchased in formal/informal stores", size(medsmall)) ///
	  legend(order(1 "Formal" 2 "Informal") pos(6) rows(1) region(lcolor(none))) ///
	  ylab(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", nogrid) ///
	  bar(1, fcolor("$my_blue%80") lcolor("$my_blue*1.2") lwidth(medthick)) ///
	  bar(2, fcolor("$my_red%80") lcolor("$my_red*1.2") lwidth(medthick)) ///
	  ${wbg}

	graph export "$dir_graphs/figure_a6.png" , replace width(2400)
	
	
*------------------------------------------------------------------------------*
* Auxiliary dataset: basic / quasi-luxury item classification
* (saved for the A3/A4 expenditure-by-category figures below)
*------------------------------------------------------------------------------*

cap mkdir "${final_phone}/temp"

* Load panel dataset 
use "${final_phone}/product_prices_panel.dta" , clear

* Collapse at the item level keeping luxury indicator
collapse (mean) luxury , by(product)

* Save auxiliar dataset
save "${final_phone}/temp/basic_luxury_items.dta", replace

*------------------------------------------------------------------------------*
* Who buys luxury vs non-luxury items? Absolute amount spent by each
* income quintile, separate by basic and quasi-luxury
* but considering average monthly expenditure (including zeros)
*------------------------------------------------------------------------------*	

* Load dataset
use "${final_phone}/final_dataset.dta" , clear

recode s4q5*_w5 (. = 0)

* collapse to get total amount spent on each item by quintile and month
collapse (mean) s4q5*_w5 , by(quintile_a month_year)
collapse (mean) s4q5*_w5 , by(quintile_a)

drop if quintile_a == .

local products 101 102 103 104 105 107 108 110 111 114 115 116 124 125 126 127 129 130 131 132 133 134 135
foreach q in `products' {
	rename s4q5`q'_w5 expenditure_`q'
}

* Prepare data structure for graph
reshape long expenditure_ , i(quintile_a) j(product) string
destring product, replace
rename expenditure_ expenditure


********************************************************************************
*
* This dofile creates an auxiliar dataset that is a list of the food items
* along with its definition of basic / quasi-luxury goods to merge with other
* datasets
********************************************************************************

* We need to bring luxury/non luxury definition from panel 
merge m:1 product using "${final_phone}/temp/basic_luxury_items.dta", keepusing(luxury)
keep if _merge == 3 // so far breakfast cereal is not purchased by anyone so it doesn't merge with panel, so we drop it
drop _merge 

* Collapse to get average monthly expenditure on each type of items, by quintile
collapse (sum) expenditure , by(quintile_a luxury)

forvalues x = 0/1 {
	if `x' == 0 {
		local item_type "basic"
		local fignum "a3"
	}
	if `x' == 1 {
		local item_type "quasi-luxury"
		local fignum "a4"
	}
	
	twoway bar expenditure quintile_a if luxury == `x', ///
	barwidth(0.5) bfcolor("$my_blue%80") blcolor("$my_blue*1.2") blwidth(medthick) ///
	title("Average monthly amount spent on `item_type' items by quintile", size(medsmall)) ///
	ylabel(0, add nogrid) xlab(, valuelabel nogrid) ///
	xtitle("") ytitle("Kina") ${wbg}
	
	graph export "$dir_graphs/figure_`fignum'.png" , replace width(2400)
	
}

*------------------------------------------------------------------------------*
* Absolute incidence summary: 
* Expenditure by item and quintile, broken down by item 
*------------------------------------------------------------------------------*

* Load dataset
use "${final_phone}/final_dataset.dta" , clear

local products 101 102 103 104 105 107 108 110 111 114 115 116 124 125 126 127 129 130 131 132 133 134 135
foreach q in `products' {
	drop s4q5`q' s4q5`q'_w1
	quietly sum month_year if s4q5`q'_w5 != . & s4q5`q'_w5 > 0
	local first_month = r(min)
	recode s4q5`q'_w5 (. = 0) if month_year >= `first_month'
	rename s4q5`q'_w5 s4q5`q'
}

* Drop breakfast cereal (128). It is excluded from the expenditure analysis
* (not in `products'), so its raw/winsorized variables survive the loop and would
* leak into reshape long as string j values (128, 128_w1, 128_w5), which breaks
* destring product and lab val product downstream.
capture drop s4q5128 s4q5128_w1 s4q5128_w5
* Insurance: any remaining winsorized/raw stub so reshape only sees s4q5### codes.
capture drop s4q5*_w1
capture drop s4q5*_w5

collapse (mean) s4q5* , by(quintile_a month_year)
collapse (mean) s4q5* , by(quintile_a)

* quintile_a==. survives the collapse and becomes a j() value in the Option 2
* reshape wide (j(quintile_a)), which Stata rejects. Drop it here.
drop if quintile_a == .
* s4q5136/s4q5137 are outside `products', so the rename/recode loop never touches
* them; they leak into reshape long as products 136/137 and add unlabeled series to
* the Option 1 graph bar. Drop with the rest of the non-`products' base codes.
capture drop s4q5136 s4q5137

preserve 
	* Option 1: each bar is a quintile, and we stack expenditures of each item
	* item palette sampled from the reference figure (15-color cycle;
	* order matches s4q5* -> legend below, breakfast cereal excluded)
	local itcols "26 133 255|212 17 89|0 191 127|255 212 0|79 44 153|255 99 51|77 183 255|124 0 21|15 239 175|250 163 7|117 139 253|254 217 183|8 35 76|248 141 173|15 81 86|26 133 255|0 191 127|255 212 0|79 44 153|255 99 51|77 183 255|124 0 21|15 239 175"
	local ibars ""
	local i = 1
	while "`itcols'" != "" {
		gettoken c itcols : itcols, parse("|")
		if "`c'" == "|" continue
		local ibars `"`ibars' bar(`i', fcolor("`c'") lcolor("`c'"))"'
		local ++i
	}
	graph bar s4q5*  , over(quintile_a, label(valuelabel labsize(small))) stack ///
			title("Average expenditure by item and quintile (in Kina)", size(medsmall)) ///
			ylabel(, nogrid) ///
			legend(pos(3) cols(1) size(tiny) symxsize(*.5) keygap(*.4) region(lcolor(none)) ///
			order(1 "sugar" 2 "kaukau" 3 "bananas" 4 "cooking oil" 5 "rice" 6 "tinned fish" ///
				  7 "tea" 8 "flour" 9 "aibika" 10 "tinned beef" 11 "sausages" 12 "chicken" 13 "petrol" ///
							14 "phone credit" 15 "tinned baked beans" 16 "powdered milk" 17 "butter" ///
							18 "milo" 19 "noodles" 20 "biscuits" 21 "coffee" 22 "broccoli" 23 "salt")) ///
			`ibars' ${wbg} xsize(9) ysize(5.5)
							
		graph export "$dir_graphs/figure_a2.png" , replace width(2400)
restore 

preserve 
	* Option 2: each bar is an item, and we stack expenditure of each quintile
	reshape long s4q5 , i(quintile_a) j(product) string
	reshape wide s4q5 , i(product) j(quintile_a)

	forvalues x = 1/5 {
		rename s4q5`x' expenditure_`x'
	}

	drop if expenditure_1 == . & expenditure_2 == . & expenditure_3 == . & expenditure_4 == . & expenditure_5 == . 

	destring product , replace

	lab def product_lab 101 "sugar" 102 "kaukau" 103 "bananas" 104 "cooking oil" 105 "rice" 107 "tinned fish" ///
						108 "tea" 110 "flour" 111 "aibika" 114 "tinned beef" 115 "sausages" 116 "chicken" 124 "petrol" ///
						125 "phone credit" 126 "tinned baked beans" 127 "powdered milk" 128 "breakfast cereal" 129 "butter" ///
						130 "milo" 131 "noodles" 132 "biscuits" 133 "coffee" 134 "broccoli" 135 "salt"
	lab val product product_lab 

	* Bar graph
	graph bar expenditure_*  , over(product, label(valuelabel labsize(small) angle(45))) stack ///
		title("Average expenditure by item and quintile (in Kina)", size(medsmall)) ///
		ylabel(, nogrid) ///
		legend(pos(6) rows(1) size(small) region(lcolor(none)) ///
		order(1 "Quintile 1" 2 "Quintile 2" 3 "Quintile 3" 4 "Quintile 4" 5 "Quintile 5")) ///
		${qbars} ${wbg}
		
		graph export "$dir_graphs/figure_a1.png" , replace width(2400)
		
restore
