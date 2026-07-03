/*==============================================================================
 figsA34_A35_experts_hte.do
 VAT exemption pass-through and incidence (Papua New Guinea) — analysis

 PURPOSE : Expert prediction survey heterogeneity analysis — pass-through and
           incidence predictions split by expert characteristics (research field,
           LMIC experience, confidence, seniority), with Welch t-tests
           (Figures A34 and A35). Sample: complete responses (finished == 1),
           Survey Preview rows dropped.
 INPUTS  : ${final_experts}/experts_survey_processed.dta (cleaned expert survey);
           globals ${dir_graphs}, ${dir_tables}, colors ${my_blue}, ${my_orange}
 OUTPUTS : ${dir_graphs}/figure_a34.png, figure_a35.png;
           ${dir_tables}/expert_heterogeneity_summary.tex (+ .csv backup)
 DEPENDS : experts_survey_processed.dta, written by
           figsA23_A33_experts_survey.do, which must run FIRST.
 CALLED BY: main.do
==============================================================================*/

clear
set more off

* --- Standalone fallbacks (harmless when run from main.do) ---------------------
if "${dir_graphs}"  == "" global dir_graphs  "Outputs/Figures"
if "${dir_tables}"  == "" global dir_tables  "Outputs/Tables"
if "${my_blue}"     == "" {
    global my_blue   "20 97 128"
    global my_red    "150 39 23"
    global my_green  "0 166 118"
    global my_orange "237 106 90"
    global my_purple "93 87 107"
}
set scheme s2color
capture mkdir "${dir_tables}"


/*==============================================================================
  1. IMPORT AND CLEAN
==============================================================================*/

use "${final_experts}/experts_survey_processed.dta", clear

* Drop survey previews (outcome variables are already numeric in the cleaned file)
drop if status_label == "Survey Preview"

di "Observations after cleaning: " _N

capture destring durationinseconds, replace force


/*==============================================================================
  2. CONSTRUCT EXPERT-CHARACTERISTIC INDICATORS
==============================================================================*/

* --- Research-field experience (comma-separated multi-select) ---
gen has_tax_incidence = strpos(experience_label, "Tax Incidence") > 0 ///
    if experience_label != ""
replace has_tax_incidence = 0 if has_tax_incidence == . & experience_label == ""

gen has_dev_econ = strpos(experience_label, "Development") > 0 ///
    if experience_label != ""
replace has_dev_econ = 0 if has_dev_econ == . & experience_label == ""

gen has_IO = strpos(experience_label, "Industrial Organization") > 0 ///
    if experience_label != ""
replace has_IO = 0 if has_IO == . & experience_label == ""

* --- Country experience in low-/middle-income setting ---
gen has_country_exp = (experience_geo_label == "Yes")

* --- High confidence (Very or Extremely confident) ---
gen high_confidence = inlist(sspp_confidence_label, ///
    "Very confident", "Extremely confident")

* --- Senior academic (Professor / Faculty, excluding students) ---
gen is_senior = (strpos(socreswhi_label, "Professor") > 0 ///
              | strpos(socreswhi_label, "Faculty") > 0) ///
              & strpos(socreswhi_label, "PhD Student") == 0 ///
              & strpos(socreswhi_label, "Masters") == 0 ///
    if socreswhi_label != ""
replace is_senior = 0 if is_senior == .

label var has_tax_incidence "Tax incidence experience"
label var has_dev_econ      "Development economics experience"
label var has_IO            "Industrial organization experience"
label var has_country_exp   "LMIC country experience"
label var high_confidence   "High confidence"
label var is_senior         "Senior (Prof)"

di _n "=== Characteristic prevalence ==="
foreach v in has_tax_incidence has_dev_econ has_IO ///
             has_country_exp high_confidence is_senior {
    qui sum `v'
    di "  `: var label `v'': " %4.0f r(sum) " (" %5.1f r(mean)*100 "%)"
}


/*==============================================================================
  3. T-TESTS AND SUMMARY TABLE
==============================================================================*/

tempname memhold
tempfile results_file
postfile `memhold' str20 characteristic str12 outcome ///
    mean_yes n_yes mean_no n_no diff pval str4 sig ///
    ci_yes ci_no ///
    using `results_file', replace

local chars    "has_tax_incidence has_dev_econ has_IO has_country_exp high_confidence is_senior"
local charlabs `" "Tax Incidence" "Dev Econ" "IO" "Country exp" "High confidence" "Senior (Prof)" "'

local outcomes_pt    "prices_1 prices_3 hetero_pass_1 hetero_pass_3"
local outcomes_inc   "income_1 income_2 income_3 income_4 income_5"
local outcomes       "`outcomes_pt' `outcomes_inc'"
local outlabs  `" "PT Phone" "PT Census" "PT Chain" "PT Informal" "Q1" "Q2" "Q3" "Q4" "Q5" "'

local c = 0
foreach char of local chars {
    local ++c
    local clab : word `c' of `charlabs'

    local o = 0
    foreach out of local outcomes {
        local ++o
        local olab : word `o' of `outlabs'

        * Group means and SEs
        qui sum `out' if `char' == 1
        local m1 = r(mean)
        local n1 = r(N)
        local se1 = r(sd) / sqrt(r(N))
        local ci1 = 1.96 * `se1'

        qui sum `out' if `char' == 0
        local m0 = r(mean)
        local n0 = r(N)
        local se0 = r(sd) / sqrt(r(N))
        local ci0 = 1.96 * `se0'

        local d = `m1' - `m0'

        * Welch t-test
        capture ttest `out', by(`char') unequal
        if _rc == 0 {
            local p = r(p)
        }
        else {
            local p = 1
        }

        * Significance stars
        local s = ""
        if `p' < 0.10 local s = "*"
        if `p' < 0.05 local s = "**"
        if `p' < 0.01 local s = "***"

        post `memhold' ("`clab'") ("`olab'") ///
            (`m1') (`n1') (`m0') (`n0') (`d') (`p') ("`s'") ///
            (`ci1') (`ci0')
    }
}
postclose `memhold'

* Display significant differences
preserve
use `results_file', clear
format mean_yes mean_no diff %6.1f
format pval %7.3f
format ci_yes ci_no %6.1f
list if sig != "", noobs separator(0)
di _n "=== All significant differences (p < 0.10) listed above ==="
restore


/*==============================================================================
  4. FIGURES: BUILD PLOTTING DATASET
==============================================================================*/

tempfile plotdata

preserve
use `results_file', clear

encode characteristic, gen(char_id)

* PT outcomes vs incidence outcomes
gen is_pt = inlist(outcome, "PT Phone", "PT Census", "PT Chain", "PT Informal")

* Outcome ordering within panel
gen out_order = .
replace out_order = 1 if outcome == "PT Phone"
replace out_order = 2 if outcome == "PT Census"
replace out_order = 3 if outcome == "PT Chain"
replace out_order = 4 if outcome == "PT Informal"
replace out_order = 1 if outcome == "Q1"
replace out_order = 2 if outcome == "Q2"
replace out_order = 3 if outcome == "Q3"
replace out_order = 4 if outcome == "Q4"
replace out_order = 5 if outcome == "Q5"

* Characteristic ordering (panel layout)
gen char_order = .
replace char_order = 1 if characteristic == "Tax Incidence"
replace char_order = 2 if characteristic == "Dev Econ"
replace char_order = 3 if characteristic == "IO"
replace char_order = 4 if characteristic == "Country exp"
replace char_order = 5 if characteristic == "High confidence"
replace char_order = 6 if characteristic == "Senior (Prof)"

* Bar positions: Yes offset left, No offset right
gen x_yes = out_order - 0.18
gen x_no  = out_order + 0.18

* CI bounds
gen ci_lo_yes = mean_yes - ci_yes
gen ci_hi_yes = mean_yes + ci_yes
gen ci_lo_no  = mean_no  - ci_no
gen ci_hi_no  = mean_no  + ci_no

* Star position (top of highest CI + offset)
gen star_y = max(ci_hi_yes, ci_hi_no) + 1.5
replace star_y = max(ci_hi_yes, ci_hi_no) + 0.8 if is_pt == 0

save "`plotdata'", replace
restore


/*==============================================================================
  5. FIGURE A34: PASS-THROUGH PREDICTIONS BY EXPERT CHARACTERISTICS
==============================================================================*/

preserve
use "`plotdata'", clear
keep if is_pt == 1

local panels ""

forvalues p = 1/6 {
    local plab : word `p' of `charlabs'

    local xlabs `" 1 `""PT" "Phone""' 2 `""PT" "Census""' 3 `""PT" "Chain""' 4 `""PT" "Informal""' "'

    * Star annotations for this panel
    local star_opts ""
    qui count if char_order == `p' & sig != ""
    if r(N) > 0 {
        qui levelsof out_order if char_order == `p' & sig != "", local(star_positions)
        foreach sp of local star_positions {
            qui sum star_y if char_order == `p' & out_order == `sp'
            local sy = r(mean)
            qui levelsof sig if char_order == `p' & out_order == `sp', local(stext) clean
            local star_opts `"`star_opts' text(`sy' `sp' "`stext'", color(red) size(medlarge) place(c))"'
        }
    }

    twoway (bar mean_yes x_yes if char_order == `p', ///
                barwidth(0.32) color("$my_blue") lcolor(white)) ///
           (bar mean_no  x_no  if char_order == `p', ///
                barwidth(0.32) color("$my_orange") lcolor(white)) ///
           (rcap ci_lo_yes ci_hi_yes x_yes if char_order == `p', ///
                lcolor(gs3) lwidth(medthin)) ///
           (rcap ci_lo_no  ci_hi_no  x_no  if char_order == `p', ///
                lcolor(gs3) lwidth(medthin)) ///
        , ///
        legend(order(1 "Yes" 2 "No") pos(2) ring(0) rows(1) size(small) region(lstyle(none))) ///
        title("`plab'", size(medium)) ///
        yscale(range(0 70)) ylabel(0(10)70, labsize(small) nogrid) ///
        xlabel(`xlabs', labsize(vsmall)) xtitle("") ytitle("") ///
        graphregion(color(white)) plotregion(margin(small) color(white)) ///
        `star_opts' ///
        name(pt_`p', replace) nodraw

    local panels "`panels' pt_`p'"
}

graph combine `panels', rows(2) cols(3) ///
    title("Pass-through predictions by expert characteristics", size(medium)) ///
    graphregion(color(white)) plotregion(color(white)) ///
    xsize(10) ysize(6.5) imargin(2 2 2 2)

graph export "${dir_graphs}/figure_a34.png", replace width(2400)
di "Saved: ${dir_graphs}/figure_a34.png"

restore


/*==============================================================================
  6. FIGURE A35: PREDICTED BENEFIT DISTRIBUTION BY EXPERT CHARACTERISTICS
==============================================================================*/

preserve
use "`plotdata'", clear
keep if is_pt == 0

local panels ""

forvalues p = 1/6 {
    local plab : word `p' of `charlabs'

    local xlabs `" 1 "Q1" 2 "Q2" 3 "Q3" 4 "Q4" 5 "Q5" "'

    * Star annotations
    local star_opts ""
    qui count if char_order == `p' & sig != "" & is_pt == 0
    if r(N) > 0 {
        qui levelsof out_order if char_order == `p' & sig != "", local(star_positions)
        foreach sp of local star_positions {
            qui sum star_y if char_order == `p' & out_order == `sp'
            local sy = r(mean)
            qui levelsof sig if char_order == `p' & out_order == `sp', local(stext) clean
            local star_opts `"`star_opts' text(`sy' `sp' "`stext'", color(red) size(medlarge) place(c))"'
        }
    }

    twoway (bar mean_yes x_yes if char_order == `p', ///
                barwidth(0.32) color("$my_blue") lcolor(white)) ///
           (bar mean_no  x_no  if char_order == `p', ///
                barwidth(0.32) color("$my_orange") lcolor(white)) ///
           (rcap ci_lo_yes ci_hi_yes x_yes if char_order == `p', ///
                lcolor(gs3) lwidth(medthin)) ///
           (rcap ci_lo_no  ci_hi_no  x_no  if char_order == `p', ///
                lcolor(gs3) lwidth(medthin)) ///
           (function y = 20, range(0.5 5.5) lcolor(gs8) lpattern(dash) lwidth(vthin)) ///
        , ///
        legend(order(1 "Yes" 2 "No") pos(2) ring(0) rows(1) size(small) region(lstyle(none))) ///
        title("`plab'", size(medium)) ///
        yscale(range(0 35)) ylabel(0(5)35, labsize(small) nogrid) ///
        xlabel(`xlabs', labsize(small)) xtitle("") ytitle("") ///
        graphregion(color(white)) plotregion(margin(small) color(white)) ///
        `star_opts' ///
        name(inc_`p', replace) nodraw

    local panels "`panels' inc_`p'"
}

graph combine `panels', rows(2) cols(3) ///
    title("Predicted benefit distribution by expert characteristics", size(medium)) ///
    graphregion(color(white)) plotregion(color(white)) ///
    xsize(10) ysize(6.5) imargin(2 2 2 2)

graph export "${dir_graphs}/figure_a35.png", replace width(2400)
di "Saved: ${dir_graphs}/figure_a35.png"

restore


/*==============================================================================
  7. LATEX SUMMARY TABLE (no dependencies; uses file write)
==============================================================================*/

preserve
use "`plotdata'", clear
sort char_order out_order

capture file close texf
file open texf using "${dir_tables}/expert_heterogeneity_summary.tex", write replace

file write texf "\begin{tabular}{llrrrrrr}" _n
file write texf "\hline" _n
file write texf "Characteristic & Outcome & Yes mean & N(Yes) & No mean & N(No) & Diff & p-value \\" _n
file write texf "\hline" _n

local N_out = _N
forvalues i = 1/`N_out' {
    local ch = characteristic[`i']
    local ou = outcome[`i']
    local my : di %5.1f mean_yes[`i']
    local ny : di %4.0f n_yes[`i']
    local mn : di %5.1f mean_no[`i']
    local nn : di %4.0f n_no[`i']
    local df : di %5.1f diff[`i']
    local pv : di %6.3f pval[`i']
    local sg = sig[`i']

    file write texf "`ch' & `ou' & `my' & `ny' & `mn' & `nn' & `df' & `pv'`sg' \\" _n
}

file write texf "\hline" _n
file write texf "\end{tabular}" _n
file close texf

* CSV backup
export delimited characteristic outcome mean_yes n_yes mean_no n_no ///
    diff pval sig using "${dir_tables}/expert_heterogeneity_summary.csv", replace

di "Saved: ${dir_tables}/expert_heterogeneity_summary.tex"
di "Saved: ${dir_tables}/expert_heterogeneity_summary.csv"
restore

di _n "===================================================================="
di    "Expert heterogeneity analysis complete (Figures A34, A35)."
di    "===================================================================="
