/*==============================================================================
 figA22_policy_preferences.do
 VAT exemption pass-through and incidence (Papua New Guinea) — analysis

 PURPOSE : Build the stacked bar chart of 1st- and 2nd-choice policy preferences
           (Figure A22). Pools the six split S10Q15_* columns into first_choice
           (and S10Q16_* into second_choice), computes each policy's share of
           respondents as 1st and 2nd choice, and plots sorted by top-2 share.
 INPUTS  : ${raw_phone}/20260429/PNG_HFPS_Household_weighted_wFood.dta (April 2026 round)
 OUTPUTS : ${dir_graphs}/figure_a22.png
 DEPENDS : run from main.do after data prep (same extract/construction as Table A4)
 CALLED BY: main.do

 Note on survey weights:
     Shares below are UNWEIGHTED. To use survey weights, replace the
     `count if X == p' blocks with svy: tab calls after svyset, e.g.:
         svyset [pw=hh_weight]
         svy: tab first_choice
     and pull the percentages from r(table).
==============================================================================*/

clear
set more off

* standalone fallback (no effect when run from main.do)
if "${dir_graphs}" == "" global dir_graphs "."

* house palette
global my_blue  "20 97 128"
global my_green "0 166 118"

* same extract as Table A4 (Panel A); April 2026 module
local DTA "${raw_phone}/20260429/PNG_HFPS_Household_weighted_wFood.dta"

*------- 1. Load: April 2026 round -------------------------------------------
use "`DTA'", clear
keep if year==2026 & month==4
local N = _N
display _newline "Sample size: N = `N'"

*------- 2. Construct first_choice and second_choice -------------------------
* The six S10Q15_* columns are a split-form encoding: each respondent has one
* non-missing value identifying the chosen policy (codes 1-6). The column
* index reflects the randomized position the option appeared in.

egen first_choice  = rowfirst(S10Q15_1 S10Q15_2 S10Q15_3 S10Q15_4 S10Q15_5 S10Q15_6)
egen second_choice = rowfirst(S10Q16_1 S10Q16_2 S10Q16_3 S10Q16_4 S10Q16_5 S10Q16_6)

label define policy_lab ///
    1 "Cash transfer (under-5 families)" ///
    2 "Remove tax on basic food" ///
    3 "Remove tax on petrol/fuel" ///
    4 "Free textbooks for schools" ///
    5 "Free phone credit" ///
    6 "Reduce govt debt"
label values first_choice  policy_lab
label values second_choice policy_lab

* Sanity checks
display _newline "--- First-choice tab ---"
tabulate first_choice,  missing
display _newline "--- Second-choice tab ---"
tabulate second_choice, missing

* Verify: should be 0 respondents picking the same policy for 1st and 2nd
qui count if first_choice == second_choice & !missing(first_choice)
assert r(N) == 0
display "OK: no respondent picked the same policy for both 1st and 2nd choice."

*------- 3. Compute percentages ---------------------------------------------
forvalues p = 1/6 {
    qui count if first_choice  == `p'
    local pct_first_`p'  = 100 * r(N) / `N'
    qui count if second_choice == `p'
    local pct_second_`p' = 100 * r(N) / `N'
}

*------- 4. Build a small 6-row dataset for the chart ------------------------
tempfile rawdata
save `rawdata'

drop _all   // wipes variables but KEEPS the value-label definitions
set obs 6
gen policy = _n
gen pct_first  = .
gen pct_second = .
forvalues p = 1/6 {
    replace pct_first  = `pct_first_`p''  if policy == `p'
    replace pct_second = `pct_second_`p'' if policy == `p'
}
gen pct_total = pct_first + pct_second

label values policy policy_lab
format pct_first pct_second pct_total %4.1f

display _newline "--- Per-policy shares (sorted by top-2, descending) ---"
gsort -pct_total
list policy pct_first pct_second pct_total, ///
    sep(0) noobs abbreviate(20)

*------- 5. Draw the stacked bar --------------------------------------------
* House palette: 1st choice = my_blue, 2nd choice = my_green.

graph bar (asis) pct_first pct_second, ///
    over(policy, sort(pct_total) descending ///
                 relabel(1 `""Cash transfer" "(under-5 families)""' ///
                         2 `""Remove tax on" "basic food""' ///
                         3 `""Remove tax on" "petrol/fuel""' ///
                         4 `""Free textbooks" "for schools""' ///
                         5 `""Free phone" "credit""' ///
                         6 `""Reduce" "govt debt""') ///
                 label(labsize(small) angle(0))) ///
    stack ///
    bar(1, fcolor("$my_blue")  lcolor(white) lwidth(medthick)) ///
    bar(2, fcolor("$my_green") lcolor(white) lwidth(medthick)) ///
    blabel(bar, position(center) format(%4.1f) ///
                color(white) size(small)) ///
    ytitle("Share of respondents (%)", size(small) margin(small)) ///
    ylabel(0(10)80, angle(0) format(%2.0f) labsize(small) nogrid) ///
    legend(order(1 "1st choice" 2 "2nd choice") ///
           rows(1) position(6) ring(1) ///
           region(lstyle(none)) ///
           size(small)) ///
    graphregion(color(white) margin(medium)) ///
    plotregion(color(white) lcolor(white)) ///
    bgcolor(white)

graph export "${dir_graphs}/figure_a22.png", replace width(2400)


*------- 6. Restore the analytic dataset (in case it's needed downstream) ----
use `rawdata', clear
