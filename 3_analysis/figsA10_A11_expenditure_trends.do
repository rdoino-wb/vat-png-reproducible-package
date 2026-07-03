/*==============================================================================
 figsA10_A11_expenditure_trends.do
 VAT exemption pass-through and incidence (Papua New Guinea) — analysis

 PURPOSE : Reproduce Figure A10 (average monthly expenditure on exempt items)
           and Figure A11 (average monthly expenditure on non-exempt items,
           dropping Petrol and Tinned Beef). Uses Apr-Jul 2025, item-level
           s4q5<code> expenditure, missing/negative coded to zero, converted to
           monthly-equivalent (x 30/14); unweighted means.
 INPUTS  : ${raw_phone}/20260429/PNG_HFPS_Household_weighted_wFood.dta
 OUTPUTS : ${dir_graphs}/figure_a10.{png,pdf};
           ${dir_graphs}/figure_a11.{png,pdf};
           ${dir_tables}/figure_a10_values.csv; ${dir_tables}/figure_a11_values.csv
 DEPENDS : run from main.do after data prep (same phone extract as Table 2)
 CALLED BY: main.do
==============================================================================*/

version 16
clear
set more off

* standalone fallbacks (no effect when run from main.do)
if "${dir_graphs}" == "" global dir_graphs "."
if "${dir_tables}" == "" global dir_tables "."

* pipeline input (same phone extract as Table 2 / Figs 5-6; Apr-Jul 2025 rounds)
local DATA "${raw_phone}/20260429/PNG_HFPS_Household_weighted_wFood.dta"

* clean line palette (readable on white; consistent with the figure_aN family)
local c1 "26 133 255"
local c2 "212 17 89"
local c3 "0 166 118"
local c4 "250 163 7"
local c5 "79 44 153"
local c6 "255 99 51"
local c7 "8 35 76"
local c8 "124 0 21"

*-------------------------------------------------------------------------------
* Item definitions
*-------------------------------------------------------------------------------
local exempt_codes 105 104 116 107 110 108 131 132
local item_105 "Rice"
local item_104 "Cooking Oil"
local item_116 "Chicken"
local item_107 "Tinned Fish"
local item_110 "Flour"
local item_108 "Tea"
local item_131 "Noodles"
local item_132 "Biscuits"

* Updated non-exempt set: drop Petrol (124) and Tinned Beef (114).
local nonex_codes 101 125 115 102 103 111
local item_101 "Sugar"
local item_125 "Phone Credit"
local item_115 "Sausages"
local item_102 "Kaukau"
local item_103 "Bananas"
local item_111 "Aibika"

*-------------------------------------------------------------------------------
* Build compact long file of mean monthly-equivalent expenditure.
*-------------------------------------------------------------------------------
use year month ///
    s4q5105 s4q5104 s4q5116 s4q5107 s4q5110 s4q5108 s4q5131 s4q5132 ///
    s4q5101 s4q5125 s4q5115 s4q5102 s4q5103 s4q5111 ///
    using "`DATA'", clear

keep if year == 2025 & inlist(month, 4, 5, 6, 7)

tempfile results
postfile P str12 group int code str30 item byte month str3 month_label ///
    double mean_expenditure int n_respondents using `results', replace

* Exempt items.
foreach c of local exempt_codes {
    local nm "`item_`c''"
    gen double exp_`c' = s4q5`c'
    replace exp_`c' = 0 if missing(exp_`c') | exp_`c' < 0
    replace exp_`c' = exp_`c' * 30/14

    forvalues m = 4/7 {
        quietly summarize exp_`c' if month == `m', meanonly
        local val = r(mean)
        quietly count if month == `m'
        local n = r(N)
        local mlab = cond(`m'==4,"Apr",cond(`m'==5,"May",cond(`m'==6,"Jun","Jul")))
        post P ("Exempt") (`c') ("`nm'") (`m') ("`mlab'") (`val') (`n')
    }
}

* Non-exempt items, excluding Petrol and Tinned Beef.
foreach c of local nonex_codes {
    local nm "`item_`c''"
    gen double exp_`c' = s4q5`c'
    replace exp_`c' = 0 if missing(exp_`c') | exp_`c' < 0
    replace exp_`c' = exp_`c' * 30/14

    forvalues m = 4/7 {
        quietly summarize exp_`c' if month == `m', meanonly
        local val = r(mean)
        quietly count if month == `m'
        local n = r(N)
        local mlab = cond(`m'==4,"Apr",cond(`m'==5,"May",cond(`m'==6,"Jun","Jul")))
        post P ("Non-exempt") (`c') ("`nm'") (`m') ("`mlab'") (`val') (`n')
    }
}
postclose P

use `results', clear
preserve
    keep if group == "Exempt"
    export delimited using "${dir_tables}/figure_a10_values.csv", replace
restore
preserve
    keep if group == "Non-exempt"
    export delimited using "${dir_tables}/figure_a11_values.csv", replace
restore

*-------------------------------------------------------------------------------
* Prepare wide plotting files.
*-------------------------------------------------------------------------------
tempfile a10data a11data
preserve
    keep if group == "Exempt"
    keep month item mean_expenditure
    replace item = strtoname(item)
    reshape wide mean_expenditure, i(month) j(item) string
    rename mean_expenditureRice rice
    rename mean_expenditureCooking_Oil cooking_oil
    rename mean_expenditureChicken chicken
    rename mean_expenditureTinned_Fish tinned_fish
    rename mean_expenditureFlour flour
    rename mean_expenditureTea tea
    rename mean_expenditureNoodles noodles
    rename mean_expenditureBiscuits biscuits
    sort month
    save `a10data', replace
restore

preserve
    keep if group == "Non-exempt"
    keep month item mean_expenditure
    replace item = strtoname(item)
    reshape wide mean_expenditure, i(month) j(item) string
    rename mean_expenditureSugar sugar
    rename mean_expenditurePhone_Credit phone_credit
    rename mean_expenditureSausages sausages
    rename mean_expenditureKaukau kaukau
    rename mean_expenditureBananas bananas
    rename mean_expenditureAibika aibika
    sort month
    save `a11data', replace
restore

*-------------------------------------------------------------------------------
* Figure A10.
*-------------------------------------------------------------------------------
use `a10data', clear

twoway ///
    (connected rice month,          lcolor("`c1'") mcolor("`c1'") lwidth(medthick) msymbol(O)) ///
    (connected cooking_oil month,   lcolor("`c2'") mcolor("`c2'") lwidth(medthick) msymbol(D)) ///
    (connected chicken month,       lcolor("`c3'") mcolor("`c3'") lwidth(medthick) msymbol(S)) ///
    (connected tinned_fish month,   lcolor("`c4'") mcolor("`c4'") lwidth(medthick) msymbol(T)) ///
    (connected flour month,         lcolor("`c5'") mcolor("`c5'") lwidth(medthick) msymbol(+)) ///
    (connected tea month,           lcolor("`c6'") mcolor("`c6'") lwidth(medthick) msymbol(Th)) ///
    (connected noodles month,       lcolor("`c7'") mcolor("`c7'") lwidth(medthick) msymbol(X)) ///
    (connected biscuits month,      lcolor("`c8'") mcolor("`c8'") lwidth(medthick) msymbol(Dh)), ///
    xline(5.5, lcolor(gs8) lpattern(dash)) ///
    title("Monthly Average Expenditure per Respondent (Kina), Apr-Jul 2025", size(medsmall)) ///
    ytitle("Kina") xtitle("") ///
    xlabel(4 "Apr" 5 "May" 6 "Jun" 7 "Jul") ///
    ylabel(0(5)35, nogrid angle(0)) yscale(range(0 35)) ///
    legend(order(1 "Rice" 2 "Cooking Oil" 3 "Chicken" 4 "Tinned Fish" 5 "Flour" 6 "Tea" 7 "Noodles" 8 "Biscuits") ///
           rows(2) position(6) ring(1) size(small) region(lcolor(none))) ///
    graphregion(color(white)) plotregion(color(white)) ///
    name(figA10, replace)

graph export "${dir_graphs}/figure_a10.png", replace width(2400)

*-------------------------------------------------------------------------------
* Figure A11, with Petrol and Tinned Beef dropped.
*-------------------------------------------------------------------------------
use `a11data', clear

twoway ///
    (connected sugar month,         lcolor("`c1'") mcolor("`c1'") lwidth(medthick) msymbol(O)) ///
    (connected phone_credit month,  lcolor("`c2'") mcolor("`c2'") lwidth(medthick) msymbol(D)) ///
    (connected sausages month,      lcolor("`c3'") mcolor("`c3'") lwidth(medthick) msymbol(S)) ///
    (connected kaukau month,        lcolor("`c4'") mcolor("`c4'") lwidth(medthick) msymbol(T)) ///
    (connected bananas month,       lcolor("`c5'") mcolor("`c5'") lwidth(medthick) msymbol(+)) ///
    (connected aibika month,        lcolor("`c6'") mcolor("`c6'") lwidth(medthick) msymbol(Th)), ///
    xline(5.5, lcolor(gs8) lpattern(dash)) ///
    title("Monthly Average Expenditure per Respondent (Kina), Apr-Jul 2025" "Other Items", size(medsmall)) ///
    ytitle("Kina") xtitle("") ///
    xlabel(4 "Apr" 5 "May" 6 "Jun" 7 "Jul") ///
    ylabel(0(1)8, nogrid angle(0)) yscale(range(0 8)) ///
    legend(order(1 "Sugar" 2 "Phone Credit" 3 "Sausages" 4 "Kaukau" 5 "Bananas" 6 "Aibika") ///
           rows(2) position(6) ring(1) size(small) region(lcolor(none))) ///
    graphregion(color(white)) plotregion(color(white)) ///
    name(figA11, replace)

graph export "${dir_graphs}/figure_a11.png", replace width(2400)

* End.
