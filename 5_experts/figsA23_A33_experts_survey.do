/*==============================================================================
 figsA23_A33_experts_survey.do
 VAT exemption pass-through and incidence (Papua New Guinea) — analysis

 PURPOSE : Clean the expert prediction survey and produce descriptive exhibits
           (Figures A23-A33) and Table A5 (respondent background).
 INPUTS  : ${raw_experts}/experts_survey.csv; globals ${dir_graphs},
           ${dir_tables}, ${final_experts}, color ${my_green}
 OUTPUTS : ${final_experts}/experts_survey_processed.dta (cleaned survey,
           consumed by figsA34_A35_experts_hte.do and fig6_actual_vs_expert.do);
           ${dir_graphs}/figure_a23.png ... figure_a33.png;
           ${dir_tables}/table_a5.tex
 DEPENDS : ${raw_experts}/experts_survey.csv must exist
 CALLED BY: main.do
==============================================================================*/

/* To check the responses, I did a test, in which I said my primary research institution was "other" and then "f",
   so look for that response and delete it, the answers are mine and random so it's garbage.
   Similarly, if any, delete answers with my email mstrehlpessina@ucsb.edu or matias.strehl@gmail.com, they are just tests */

clear all

capture mkdir "${dir_graphs}/experts_survey"

import delimited "$raw_experts/experts_survey.csv", clear 

drop if _n <= 16

destring finished , force replace

* This can be modified if we only want finished responses
*keep if finished == 0 | finished == 1
* --- Table A5 counts: captured before restricting to complete responses ---
count
scalar n_total = r(N)
count if finished == 1
scalar n_complete = r(N)

keep if finished == 1

**********

destring prices_* , replace
destring hetero_pass_* , replace
destring income_* , replace 

* Goal: attach labels from string var2 to numeric var1
* Assumes each code in var1 maps to exactly one intended label in var2
local variables variation time sub_small substantial small experience_geo sspp_confidence
foreach var in `variables' {
	destring `var' , replace
	
	quietly levelsof `var' if !missing(`var'), local(levels)

	capture label drop `var'_mylab
	foreach l of local levels {
		quietly levelsof `var'_label if `var' == `l' & `var'_label != "", local(lbl)		
		disp `lbl'
		label define `var'_mylab `l' `lbl', add
	}

	label values `var' `var'_mylab

}

* Create indicators for having experience in each field
gen pf_exp = 0 
	replace pf_exp = 1 if regexm(experience_label, "Public Economics")
gen incidence_exp = 0 
	replace incidence_exp = 1 if regexm(experience_label, "Tax Incidence")
gen development_exp = 0 
	replace development_exp = 1 if regexm(experience_label, "Development Economics")	
gen io_exp = 0 
	replace io_exp = 1 if regexm(experience_label, "Industrial Organization")
	
* Create indicators from social science platform standard questions
*-------------------------------------------------------------------------------
/*

all questions that start with "socres" are for those that are researchers
but I'm not so sure that those that start with "socnores" are for non-researchers,
becuase in that case the number of observations don't match.

socres_label --> question on are you a phd student, pos doc, faculty....
socreswhi_label --> which of the above are you // some values are free text although the field was multiple choice
socresdis_label --> discipline // multiple choice with an "other" free-text option
socresaffil_label --> primary research institution // some values are free text although the field was multiple choice
												// (respondents selecting "other" were re-prompted to enter text)

socresaffilother --> Other research affiliation												
socresecofie_label --> research field
socresotherfie_label --> rseearch field 
socrespsyfie_label --> research field 
socrespolfie_label --> research field 
socressocifie_label --> research field. 
											


socresnosec_label --> what is your sector?
socnoresorg_label --> What type of organization do you currently work for?

socnoresorg_label --> type of organization 

socnoresedu_label --> educational level 
socedu_label --> identical to socnoresedu_label

*/


gen researcher = .
 replace researcher = 1 if socres_label == "Yes"
 replace researcher = 0 if socres_label == "No"
 
gen researcher_type = socreswhi_label
	replace researcher_type = "Faculty" if socreswhi_label == "['Assistant Professor', 'Faculty']" | ///
							  socreswhi_label == "['Associate Professor']" | ///
							  socreswhi_label == "['Professor']"
	replace researcher_type = "Masters student" if socreswhi_label == "['Masters Student']"
	replace researcher_type = "PhD student" if socreswhi_label == "['PhD Student']"
	replace researcher_type = "Postdoc" if socreswhi_label == "['Post-doc']"
	replace researcher_type = "Researcher in a thinktank, government agency, or other organization" if socreswhi_label == "['Researcher']"

* Create indicator of being a researcher in Economics
gen islist = substr(socresdis_label,1,1)=="["
	replace socresdis_label = subinstr(socresdis_label, "[", "", .) if islist == 1
	replace socresdis_label = subinstr(socresdis_label, "]", "", .) if islist == 1
	replace socresdis_label = subinstr(socresdis_label, "'", "", .) if islist == 1

split socresdis_label, parse(",") gen(discipline) trim     // creates discipline1 discipline2...
gen discipline_economics = (discipline1 == "Economics" | discipline2 == "Economics" ///
  | discipline3 == "Economics" | discipline4 == "Economics")
  
  
* Labels
*-------------------------------------------------------------------------------

label var prices_1
label var prices_2
label var prices_3
label var prices_4
	
label var pf_exp "Has research experience in Public Economics"
label var incidence_exp "Has research experience in Tax Incidence"
label var development_exp "Has research experience in Development Economics"
label var io_exp "Has research experience in Industrial Organization"

label var experience_geo "Has experience doing research in low-middle-income countries"

* Save processed experts survey 
*------------------------------------------------------------------------------*

save "$final_experts/experts_survey_processed.dta" , replace


*------------------------------------------------------------------------------*
*  EMPIRICAL ANALYSIS
*------------------------------------------------------------------------------*


* Pass through rates by data source
*-------------------------------------------------------------------------------

/* On a scale from 0% to 100%, where 0% represents no pass-through and 100% 
represents full pass-through, what do you think the average pass-through rate 
(as a percent) would be based on…*/

* Load datset
use "$final_experts/experts_survey_processed.dta", clear

/*
graph box prices_1 prices_2 prices_3 prices_4, ///
	  ylab(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", nogrid) ///
	  legend(order(1 "Phone survey" 2 "CPI" 3 "Supermarket Census" 4 "Webscraped data") ///
	  pos(6) rows(1))


graph hbox prices_1 prices_2 prices_3 prices_4, ///
	  ylab(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", nogrid) ///
	  legend(order(1 "Phone survey" 2 "CPI" 3 "Supermarket Census" 4 "Webscraped data") ///
	  pos(6) rows(1)) */
	  

keep prices_1 prices_2 prices_3 prices_4
gen id = _n
reshape long prices_, i(id) j(source)
rename prices_ prices

forvalues x = 1/4 {
	sum prices if source == `x'
	local mean_`x' = string(r(mean), "%9.1fc")
}

* Now each row is a value with a source label
graph hbox prices,  over(source, relabel(1 `" "Phone" "survey" "'  2 "CPI" 3 `" "Supermarket" "census" "' 4 "Webscrapped") label(labsize(medsmall) nogrid) ) ///
	title("What do you think the average pass-through rate would be?", size(medsmall)) ///
    ytitle("Pass-through rate") box(1, color("$my_green%80") lwidth(medthick)) ///
	ylab(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", nogrid) ///
	text(`mean_1' 100 "Mean:`mean_1'% " , color("$my_green") size(small)) ///
	text(`mean_2' 73 "Mean:`mean_2'% " , color("$my_green") size(small)) ///
	text(`mean_3' 46 "Mean:`mean_3'% " , color("$my_green") size(small)) ///
	text(`mean_4' 19 "Mean:`mean_4'% " , color("$my_green") size(small)) ///
	graphregion(color(white)) plotregion(color(white))
	
	graph export "$dir_graphs/figure_a23.png", replace width(2400)


* Variation in pass through rates 
*-------------------------------------------------------------------------------
/* To what extent do you think there will be variation in pass-through rates 
between the 10 zero-rated food items? */

* Load datset
use "$final_experts/experts_survey_processed.dta" , clear


twoway histogram variation , percent discrete width(0.5) gap(20) ///
	title("To what extent do you think there will be variation in pass-through rates?", size(medsmall)) ///
	fcolor("$my_green%80") lcolor("$my_green") lwidth(medthick) ///
	ytitle("") xtitle("") xscale(range(0.7 3.3)) ///
	ylab(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", nogrid) ///
	xlab(1(1)3, nogrid valuelabel) ///
	graphregion(color(white)) plotregion(color(white))
	
	graph export "$dir_graphs/figure_a24.png", replace width(2400)
	
* Items with high pass-through rates  
*-------------------------------------------------------------------------------

/*For which of the following items do you think there would be the highest pass-through rate?*/

* Load datset
use "$final_experts/experts_survey_processed.dta" , clear

* 0) Identify the list variable
local listvar item_pass_high_label

* 1) Normalize separators and basic cleanup
replace `listvar' = subinstr(`listvar', ";", ",", .)
replace `listvar' = subinstr(`listvar', "/", ",", .)
replace `listvar' = subinstr(`listvar', " and ", ",", .)   // "A and B" -> "A, B"
replace `listvar' = lower(`listvar')
replace `listvar' = itrim(trim(`listvar'))

* 2) Split into tokens
capture drop tok*
split `listvar', parse(",") gen(tok) trim     // creates tok1 tok2 ...
gen resp_id = _n                               // ID per respondent

* 3) Reshape to long (one row per mention)
reshape long tok, i(resp_id) j(k)
rename tok item
drop if missing(item) | item==""               // remove empties
replace item = itrim(trim(item))

* 5) De-duplicate within respondent (if they wrote the same item twice)
bysort resp_id item: keep if _n==1

* Trick to save total number of respondents of this question in a local
preserve
contract resp_id                          // includes missing by default
count if resp_id != .
local n_respondents = r(N)                          // number of distinct values
restore


* 6) Count mentions
contract item
rename _freq mentions
gen percent_respondents = (mentions / `n_respondents') * 100
gsort -percent_respondents item

* 8) Plot: horizontal bar of counts (nice for long labels)
graph hbar (sum) percent_respondents, over(item, sort(1) descending ///
	label(labsize(small))) ///
	title("For which of the following items do you think" ///
	"there would be the highest pass-through rate?", size(medsmall)) ///
	bar(1, fcolor("$my_green%80") lcolor("$my_green") lwidth(medthick)) ///
    ytitle("Percent of respondents that mention each item") ///
	ylab(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%", nogrid) ///
    blabel(bar, format(%9.1fc)) ///
    note("Each respondent could list multiple items", size(small)) ///
	graphregion(color(white)) plotregion(color(white))

	graph export "$dir_graphs/figure_a25.png", replace width(2400)
	
* Items with low pass-through rates  
*-------------------------------------------------------------------------------

/* For which of the following items do you think there would be the lowest pass-through rate? */

* Load datset
use "$final_experts/experts_survey_processed.dta" , clear

* 0) Identify the list variable
local listvar item_pass_low_label

* 1) Normalize separators and basic cleanup
replace `listvar' = subinstr(`listvar', ";", ",", .)
replace `listvar' = subinstr(`listvar', "/", ",", .)
replace `listvar' = subinstr(`listvar', " and ", ",", .)   // "A and B" -> "A, B"
replace `listvar' = lower(`listvar')
replace `listvar' = itrim(trim(`listvar'))

* 2) Split into tokens
capture drop tok*
split `listvar', parse(",") gen(tok) trim     // creates tok1 tok2 ...
gen resp_id = _n                               // ID per respondent

* 3) Reshape to long (one row per mention)
reshape long tok, i(resp_id) j(k)
rename tok item
drop if missing(item) | item==""               // remove empties
replace item = itrim(trim(item))

* 5) De-duplicate within respondent (if they wrote the same item twice)
bysort resp_id item: keep if _n==1

* Trick to save total number of respondents of this question in a local
preserve
contract resp_id                          // includes missing by default
count if resp_id != .
local n_respondents = r(N)                          // number of distinct values
restore


* 6) Count mentions
contract item
rename _freq mentions
gen percent_respondents = (mentions / `n_respondents') * 100
gsort -percent_respondents item

* 8) Plot: horizontal bar of counts (nice for long labels)
graph hbar percent_respondents, over(item, sort(1) descending ///
	label(labsize(small))) ///
	title("For which of the following items do you think" ///
	"there would be the lowest pass-through rate?", size(medsmall)) ///
	bar(1, fcolor("$my_green%80") lcolor("$my_green") lwidth(medthick)) ///
    ytitle("Percent of respondents that mention each item") ///
	ylab(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%", nogrid) ///
    blabel(bar, format(%9.1fc)) ///
    note("Each respondent could list multiple items", size(small)) ///
	graphregion(color(white)) plotregion(color(white))

	graph export "$dir_graphs/figure_a26.png", replace width(2400)


* Heterogeneity  
*-------------------------------------------------------------------------------

/* On a scale from 0% to 100%, where 0% represents no pass-through and 100% 
represents full pass-through, what do you think the average pass-through rate 
after two months would be in...*/

* Load datset
use "$final_experts/experts_survey_processed.dta" , clear

keep hetero_pass_1 hetero_pass_2 hetero_pass_3
gen id = _n
reshape long hetero_pass_, i(id) j(store_type) 
rename hetero_pass_ pass

forvalues x = 1/3 {
	sum pass if store_type == `x'
	local mean_`x' = string(r(mean), "%9.1fc")
}
* Now each row is a value with a source label
graph hbox pass,  over(store_type, relabel(1 `" "Formal chain" "supermarkets" "'  ///
	2 `" "Formal indep."  "supermarkets" "' 3 `" "Informal" "stores" "') ///
	label(labsize(medsmall) nogrid) ) ///
	title("What do you think the average pass-through rate after two months would be in...?", size(medsmall)) ///
    ytitle("Pass-through rate") box(1, color("$my_green%80") lwidth(medthick)) ///
	ylab(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", nogrid) ///
	text(`mean_1' 100 "Mean:`mean_1'% " , color("$my_green") size(small)) ///
	text(`mean_2' 63 "Mean:`mean_2'% " , color("$my_green") size(small)) ///
	text(`mean_3' 26 "Mean:`mean_3'% " , color("$my_green") size(small)) ///
	graphregion(color(white)) plotregion(color(white))
	
	graph export "$dir_graphs/figure_a27.png", replace width(2400)
	
* Pass through over time  
*-------------------------------------------------------------------------------

/* How do you expect pass through rates to change from two to six months?*/

* Load datset
use "$final_experts/experts_survey_processed.dta" , clear

twoway histogram time, percent discrete width(0.5) gap(20) ///
	title("How do you expect pass through rates to change from two to six months?", size(medsmall)) ///
	fcolor("$my_green%80") lcolor("$my_green") lwidth(medthick) ///
	ytitle("") xtitle("") xscale(range(0.7 3.3)) ///
	ylab(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", nogrid) ///
	xlab(1 "Increase" 2 "Decrease" 3 "Stay the same", nogrid) ///
	graphregion(color(white)) plotregion(color(white))
	
	graph export "$dir_graphs/figure_a28.png", replace width(2400)


* Pass through substantial or small?
*-------------------------------------------------------------------------------
	
/* Do you expect the pass-through rate of the VAT cut to prices to be 
   substantial or small? */
   
* Load datset
use "$final_experts/experts_survey_processed.dta" , clear

twoway histogram sub_small , percent discrete width(0.5) gap(20) ///
	title("Do you expect the pass-through rate of the VAT cut to prices to be substantial or small?", size(medsmall)) ///
	fcolor("$my_green%80") lcolor("$my_green") lwidth(medthick) ///
	ytitle("") xtitle("") xscale(range(0.7 2.3)) ///
	ylab(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", nogrid) ///
	xlab(1 "Substantial" 2 "Small", nogrid) ///
	graphregion(color(white)) plotregion(color(white))
	
	graph export "$dir_graphs/figure_a29.png", replace width(2400)

* Why Pass through substantial?
*-------------------------------------------------------------------------------
	
/* If you expect the pass-through rate of the VAT cut to prices to be substantial, ///
what is the main explanation? */
   
* Load datset
use "$final_experts/experts_survey_processed.dta" , clear

twoway histogram substantial , percent discrete horizontal width(0.5) gap(20) ///
	title("If you expect the pass-through rate of the VAT cut to prices to be substantial," ///
	       "what is the main explanation?", size(medsmall))  ///
	fcolor("$my_green%80") lcolor("$my_green") lwidth(medthick) ///
	ytitle("") xtitle("") xscale(range(0.7 2.3)) ///
	xlab(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", nogrid) ///
	ylab(1 `" "Relative" "elasticities" "' 2 `" "High voluntary" "compliance" "' 3 ///
	`" "High pass-through" "from chain to indep." "supermarkets" "' ///
	4 `" "High political" "pressure" "' 5 "High monitoring", nogrid) ///
	graphregion(color(white)) plotregion(color(white))
	
	graph export "$dir_graphs/figure_a30.png", replace width(2400)
	
* Why Pass through small?
*-------------------------------------------------------------------------------
	
/* If you expect the pass-through rate of the VAT cut to prices to be small, ///
what is the main explanation? */
   
* Load datset
use "$final_experts/experts_survey_processed.dta" , clear

twoway histogram small , percent discrete horizontal width(0.5) gap(20) ///
	title("If you expect the pass-through rate of the VAT cut to prices to be small," ///
	       "what is the main explanation?", size(medsmall))  ///
	fcolor("$my_green%80") lcolor("$my_green") lwidth(medthick) ///
	ytitle("") xtitle("") xscale(range(0.7 2.3)) ///
	xlab(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", nogrid) ///
	ylab(1 `" "Relative" "elasticities" "' 2 `" "Low voluntary" "compliance" "' 3 ///
	`" "Low pass-through" "from chain to indep." "supermarkets" "' ///
	4 `" "Low political" "pressure" "' 5 "Low monitoring", nogrid) ///
	graphregion(color(white)) plotregion(color(white))
	
	graph export "$dir_graphs/figure_a31.png", replace width(2400)


* Incidence
*-------------------------------------------------------------------------------

/* How do you think the benefits of the VAT cut will be distributed 
across the income distribution? */

*-- Option A: Bar graph --*

* Load datset
use "$final_experts/experts_survey_processed.dta" , clear

graph  bar (mean) income_1 income_2 income_3 income_4 income_5 , ascategory ///
	yvaroptions(relabel(1 "Quintile 1" 2 "Quintile 2" 3 "Quintile 3" 4 "Quintile 4" 5 "Quintile 5")) ///
	bar(1, bfcolor("$my_green%80") blcolor("$my_green") lwidth(medthick)) ///
	title("How do you think the benefits of the VAT cut will be distributed" ///
	"across the income distribution?", size(medsmall)) ///
	ytitle("Average %") ///
	ylab(0 "0%" 5 "5%" 10 "10%" 15 "15%" 20 "20%" 25 "25%", nogrid) ///
	graphregion(color(white)) plotregion(color(white))
	
	graph export "$dir_graphs/figure_a32.png", replace width(2400)

*-- Option B: Box plot --*

* Load datset
use "$final_experts/experts_survey_processed.dta" , clear

keep income_1 income_2 income_3 income_4 income_5
gen id = _n
reshape long income_, i(id) j(quintile) 
rename income_ incidence

/* quick check that total = 100 (a few individuals have total > 100 because the 
survey was not correctly designed when they responded). Then, there are unfinished 
responses that did not get to this question so they have missing and 0 in total incidence */
egen total_incidence = total(incidence) , by(id)
drop if total_incidence != 100

forvalues x = 1/5 {
	sum incidence if quintile == `x'
	local mean_`x' = string(r(mean), "%9.1fc")
}
* Now each row is a value with a source label
graph hbox incidence,  over(quintile, relabel(1 "Quintile 1"  2 "Quintile 2" 3 "Quintile 3" ///
	4 "Quintile 4" 5 "Quintile 5") label(labsize(medsmall) nogrid) descending ) ///
	title("How do you think the benefits of the VAT cut will be distributed" ///
	"across the income distribution?", size(medsmall)) ///
    ytitle("Incidence of VAT cuts") box(1, color("$my_green%80") lwidth(medthick)) ///
	ylab(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%", nogrid) ///
	text(`mean_5' 100 "Mean:`mean_5'% " , color("$my_green") size(small)) ///
	text(`mean_4' 79 "Mean:`mean_4'% " , color("$my_green") size(small)) ///
	text(`mean_3' 58 "Mean:`mean_3'% " , color("$my_green") size(small)) ///
	text(`mean_2' 37 "Mean:`mean_2'% " , color("$my_green") size(small)) ///
	text(`mean_1' 15.5 "Mean:`mean_1'% " , color("$my_green") size(small)) ///
	marker(1, mfcolor(gs6%50) mlcolor(gs6)) ///
	graphregion(color(white)) plotregion(color(white))
	
	graph export "$dir_graphs/figure_a33.png", replace width(2400)

********************************************************************************
* NOTE: the "level of confidence" histogram is not a paper exhibit and was
* removed. This script outputs Figures A23-A33 (PNG) and Table A5.
********************************************************************************

********************************************************************************
* TABLE A5: background information about the expert prediction survey
*   Percentages are over the complete-response sample (finished == 1); the total
*   and finished counts are captured before that restriction (top of file).
*   Duration is the Qualtrics "Duration (in seconds)" column (durationinseconds).
********************************************************************************

if "${dir_tables}" == "" global dir_tables "."

* Reload the processed data: the figure blocks above left a reshaped subset in memory
use "$final_experts/experts_survey_processed.dta", clear

foreach v in researcher discipline_economics pf_exp incidence_exp ///
             development_exp io_exp {
    quietly summarize `v'
    scalar p_`v' = 100 * r(mean)
}

* experience_geo stores the labeled Qualtrics choice code, not a 0/1 dummy, so
* its raw mean is not a share (that produced the 2538.10 value). Build the
* LMIC-experience indicator from the "Yes"/"No" string label, matching the
* has_country_exp construction in figsA34_A35_experts_hte.do.
tempvar geo_yes
gen `geo_yes' = .
replace `geo_yes' = 1 if experience_geo_label == "Yes"
replace `geo_yes' = 0 if experience_geo_label == "No"
quietly summarize `geo_yes'
scalar p_experience_geo = 100 * r(mean)

* median completion time in minutes (guarded: column name may differ)
scalar med_dur = .
capture confirm variable durationinseconds
if !_rc {
    capture destring durationinseconds, force replace
    quietly summarize durationinseconds, detail
    scalar med_dur = r(p50) / 60
}
else {
    di as error "  Table A5: durationinseconds not found; median duration left blank."
}

tempname f
file open `f' using "${dir_tables}/table_a5.tex", write replace
file write `f' "\begin{tabular}{lc} \midrule" _n
file write `f' " \noalign{\smallskip} Finished (\%) & " %4.2f (100*n_complete/n_total) " \\" _n
file write `f' " Median duration (minutes) & " %4.2f (med_dur) " \\" _n
file write `f' " Researcher (\%) & " %4.2f (p_researcher) " \\" _n
file write `f' " Economics (\%) & " %4.2f (p_discipline_economics) " \\" _n
file write `f' " \shortstack{Research experience in: \\ \quad{Public Finance (\%)}} & " %4.2f (p_pf_exp) " \\" _n
file write `f' " \quad{Tax Incidence (\%)} & " %4.2f (p_incidence_exp) " \\" _n
file write `f' " \quad{Development (\%)} & " %4.2f (p_development_exp) " \\" _n
file write `f' " \quad{Industrial Organization (\%)} & " %4.2f (p_io_exp) " \\" _n
file write `f' " \quad{Low-middle income countries (\%)} & " %4.2f (p_experience_geo) " \\" _n
file write `f' " \midrule Number of responses & " %4.0f (n_total) " \\ Number of complete responses & " %4.0f (n_complete) " \\ \bottomrule \end{tabular}" _n
file close `f'
di as txt "Wrote Table A5 to ${dir_tables}/table_a5.tex"
