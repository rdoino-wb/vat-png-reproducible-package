/*===============================================================================
 figsA17_A18_sentiment.do
 BPNG Business Sentiment Survey figures (merged from the former
 2_figure_a17.do and 2_figure_a18.do; estimation code unchanged).

 PART A  Figure A17: pass-through of cost changes (NCD vs Rest of country, H1 2026)
           Left panel : stacked composition of All / Some / None pass-through
           Right panel: forest plot of differences for "Passed NONE" and
                        "Passed ANY", with Wald 95% CIs (independent proportions)
           Input : ${final_sentiment}/passthrough_groups.dta
           Output: ${dir_graphs}/figure_a17.{pdf,png}
                   ${dir_tables}/passthrough_diffs.dta

 PART B  Figure A18: change in reported competition (NCD vs Rest of country)
           Paired firms responding in both H1 2025 and H2 2025; NCD change,
           Rest change, and the difference-in-differences.
           Input : ${final_sentiment}/competition_wide.dta
           Output: ${dir_graphs}/figure_a18.png
                   ${dir_tables}/competition_estimates.dta
===============================================================================*/

* standalone fallbacks (no effect when run from main.do)
if "${dir_graphs}" == ""      global dir_graphs "."
if "${dir_tables}" == ""      global dir_tables "."
if "${final_sentiment}" == "" global final_sentiment "."


/*===============================================================================
 PART A  Figure A17
===============================================================================*/

* ---- Define colors used throughout ----
local C_ALL  "0 166 118"      // my_green
local C_SOME "237 106 90"     // my_orange
local C_NONE "150 39 23"      // my_red
local C_ANY  "20 97 128"      // my_blue

* ============================================================================
* LEFT PANEL: stacked composition
* ============================================================================
use "${final_sentiment}/passthrough_groups.dta", clear

* Express as percentages (0-100)
foreach v of varlist p_all p_some p_none p_any {
    replace `v' = `v' * 100
}

graph bar (asis) p_all p_some p_none, ///
    over(NCD, label(labsize(medium))) ///
    stack ///
    bar(1, color("`C_ALL'")  lcolor(white) lwidth(thin)) ///
    bar(2, color("`C_SOME'") lcolor(white) lwidth(thin)) ///
    bar(3, color("`C_NONE'") lcolor(white) lwidth(thin)) ///
    blabel(bar, position(center) color(white) format(%2.0f) size(medium)) ///
    legend(order(1 "Passed ALL costs through" ///
                 2 "Passed SOME costs through" ///
                 3 "Passed NONE through") ///
           cols(1) position(6) ring(1) size(small) symxsize(4) ///
           region(lstyle(none))) ///
    ytitle("Share of respondents (%)", size(small)) ///
    ylabel(0(20)100, labsize(small) format(%3.0f)) ///
    yscale(range(0 105)) ///
    title("") ///
    graphregion(color(white) margin(small)) ///
    plotregion(color(white) margin(small)) ///
    name(g_pt_bar, replace)

* ============================================================================
* RIGHT PANEL: forest plot of differences
* ============================================================================
use "${final_sentiment}/passthrough_groups.dta", clear

* Pull counts for each group into scalars
quietly summarize n_firms if NCD == 1
scalar n_ncd  = r(mean)
quietly summarize n_firms if NCD == 0
scalar n_rest = r(mean)

quietly summarize k_none if NCD == 1
scalar k_none_ncd  = r(mean)
quietly summarize k_none if NCD == 0
scalar k_none_rest = r(mean)

quietly summarize k_any  if NCD == 1
scalar k_any_ncd   = r(mean)
quietly summarize k_any  if NCD == 0
scalar k_any_rest  = r(mean)

scalar p_none_ncd  = k_none_ncd  / n_ncd
scalar p_none_rest = k_none_rest / n_rest
scalar p_any_ncd   = k_any_ncd   / n_ncd
scalar p_any_rest  = k_any_rest  / n_rest

scalar se_none = sqrt(p_none_ncd*(1-p_none_ncd)/n_ncd ///
                    + p_none_rest*(1-p_none_rest)/n_rest)
scalar se_any  = sqrt(p_any_ncd *(1-p_any_ncd) /n_ncd ///
                    + p_any_rest*(1-p_any_rest)/n_rest)

* Build dataset for plotting
clear
set obs 2
gen str30  label = ""
gen double diff  = .
gen double se    = .
gen byte   order = _n             // 1 = NONE, 2 = ANY
gen double y_pos = .

replace label = "Passed NONE through"     in 1
replace label = "Passed ANY (All + Some)" in 2

replace diff = p_none_ncd - p_none_rest in 1
replace diff = p_any_ncd  - p_any_rest  in 2

replace se = se_none in 1
replace se = se_any  in 2

gen ci_lo = diff - 1.96 * se
gen ci_hi = diff + 1.96 * se

* y-position: NONE on top (y=2), ANY below (y=1)
replace y_pos = 3 - order

* Annotation string with % formatting (manual sign because Stata's
* string() format does not support the C-style '+' flag)
gen str60 valstr = cond(diff  >= 0, "+", "") + string(diff*100,  "%4.1f") + "%  [" ///
                 + cond(ci_lo >= 0, "+", "") + string(ci_lo*100, "%4.1f") + "%, " ///
                 + cond(ci_hi >= 0, "+", "") + string(ci_hi*100, "%4.1f") + "%]"

save "${dir_tables}/passthrough_diffs.dta", replace

twoway ///
    (rcap ci_lo ci_hi y_pos if order==1, horizontal ///
         lcolor("`C_NONE'") lwidth(medthick)) ///
    (scatter y_pos diff if order==1, msymbol(O) msize(medlarge) ///
         mcolor("`C_NONE'") mlcolor(white) mlwidth(medthin)) ///
    (rcap ci_lo ci_hi y_pos if order==2, horizontal ///
         lcolor("`C_ANY'") lwidth(medthick)) ///
    (scatter y_pos diff if order==2, msymbol(O) msize(medlarge) ///
         mcolor("`C_ANY'") mlcolor(white) mlwidth(medthin)) ///
    (scatter y_pos ci_hi, msymbol(none) mlabel(valstr) ///
         mlabposition(3) mlabsize(vsmall) mlabcolor(black)) ///
    , ///
    xline(0, lcolor(gs6) lwidth(thin)) ///
    ylabel(1 "Passed ANY (All + Some)" 2 "Passed NONE through", ///
           angle(0) labsize(small) noticks) ///
    yscale(range(0.5 2.5) noline) ///
    ytitle("") ///
    xlabel(-0.4(0.1)0.5, format(%4.1f) labsize(small)) ///
    xtitle("NCD − Rest of country (percentage points)", size(small)) ///
    legend(off) ///
    graphregion(color(white) margin(small)) ///
    plotregion(color(white) margin(small)) ///
    name(g_pt_forest, replace)

* ---- Combine and export ----
graph combine g_pt_bar g_pt_forest, ///
    cols(2) ///
    imargin(small) ///
    graphregion(color(white)) ///
    xsize(11) ysize(5) ///
    name(figure_a17, replace)

graph export "${dir_graphs}/figure_a17.pdf", as(pdf) replace
graph export "${dir_graphs}/figure_a17.png", as(png) width(2400) replace

display _n as result "Figure A17 saved to: ${dir_graphs}/figure_a17.pdf"


/*===============================================================================
 PART B  Figure A18
===============================================================================*/

use "${final_sentiment}/competition_wide.dta", clear
keep if in_panel == 1

* ---- Group statistics ----
quietly summarize diff_inc if NCD == 1
scalar n_ncd     = r(N)
scalar mean_ncd  = r(mean)
scalar sd_ncd    = r(sd)
scalar se_ncd    = sd_ncd / sqrt(n_ncd)

quietly summarize diff_inc if NCD == 0
scalar n_rest    = r(N)
scalar mean_rest = r(mean)
scalar sd_rest   = r(sd)
scalar se_rest   = sd_rest / sqrt(n_rest)

* ---- Difference-in-differences ----
scalar did    = mean_ncd - mean_rest
scalar did_se = sqrt(se_ncd^2 + se_rest^2)

* ---- Log results ----
display _n as text "{hline 70}"
display as text "Paired analysis: change in P(reported competition increased)"
display as text "{hline 70}"
display as text "NCD       (n=" %2.0f n_ncd  "): Δ = " %6.4f mean_ncd  ///
                "  SE = " %6.4f se_ncd ///
                "  95% CI [" %6.4f mean_ncd  - 1.96*se_ncd  ", " ///
                %6.4f mean_ncd  + 1.96*se_ncd  "]"
display as text "Rest      (n=" %2.0f n_rest "): Δ = " %6.4f mean_rest ///
                "  SE = " %6.4f se_rest ///
                "  95% CI [" %6.4f mean_rest - 1.96*se_rest ", " ///
                %6.4f mean_rest + 1.96*se_rest "]"
display as text "DiD              : Δ = " %6.4f did ///
                "  SE = " %6.4f did_se ///
                "  95% CI [" %6.4f did - 1.96*did_se ", " ///
                %6.4f did + 1.96*did_se "]"
display as text "{hline 70}"

* ---- Build plotting dataset ----
clear
set obs 3
gen str40  label = ""
gen double est   = .
gen double se    = .
gen byte   order = _n
gen double y_pos = .

replace label = "NCD: paired change H2 − H1"             in 1
replace label = "Rest of country: paired change H2 − H1" in 2
replace label = "Difference-in-differences"              in 3

replace est = mean_ncd  in 1
replace est = mean_rest in 2
replace est = did       in 3

replace se = se_ncd  in 1
replace se = se_rest in 2
replace se = did_se  in 3

gen ci_lo = est - 1.96 * se
gen ci_hi = est + 1.96 * se

* Row 1 (NCD) at top y=3, row 3 (DiD) at bottom y=1
replace y_pos = 4 - order

* Annotation string matches the published figure (manual sign formatting
* because Stata's string() format does not support the C-style '+' flag)
gen str60 valstr = cond(est   >= 0, "+", "") + string(est*100,   "%4.1f") + "%  [" ///
                 + cond(ci_lo >= 0, "+", "") + string(ci_lo*100, "%4.1f") + "%, " ///
                 + cond(ci_hi >= 0, "+", "") + string(ci_hi*100, "%4.1f") + "%]"

save "${dir_tables}/competition_estimates.dta", replace

* ---- Forest plot ----
local C_NCD  "20 97 128"      // my_blue
local C_REST "237 106 90"     // my_orange
local C_DID  "93 87 107"      // my_purple

twoway ///
    (rcap ci_lo ci_hi y_pos if order==1, horizontal ///
         lcolor("`C_NCD'") lwidth(medthick)) ///
    (scatter y_pos est if order==1, msymbol(O) msize(large) ///
         mcolor("`C_NCD'") mlcolor(white) mlwidth(medthin)) ///
    (rcap ci_lo ci_hi y_pos if order==2, horizontal ///
         lcolor("`C_REST'") lwidth(medthick)) ///
    (scatter y_pos est if order==2, msymbol(O) msize(large) ///
         mcolor("`C_REST'") mlcolor(white) mlwidth(medthin)) ///
    (rcap ci_lo ci_hi y_pos if order==3, horizontal ///
         lcolor("`C_DID'") lwidth(medthick)) ///
    (scatter y_pos est if order==3, msymbol(O) msize(large) ///
         mcolor("`C_DID'") mlcolor(white) mlwidth(medthin)) ///
    (scatter y_pos ci_hi, msymbol(none) mlabel(valstr) ///
         mlabposition(3) mlabsize(small) mlabcolor(black)) ///
    , ///
    xline(0, lcolor(gs6) lwidth(thin)) ///
    ylabel(1 "Difference-in-differences" ///
           2 "Rest of country: H2 − H1" ///
           3 "NCD: H2 − H1", ///
           angle(0) labsize(small) noticks) ///
    yscale(range(0.5 3.5) noline) ///
    ytitle("") ///
    xlabel(-0.3(0.1)0.65, format(%4.1f) labsize(small)) ///
    xtitle("Change in proportion reporting competition increased", size(small)) ///
    legend(off) ///
    graphregion(color(white) margin(medsmall)) ///
    plotregion(color(white) margin(medsmall)) ///
    xsize(9.5) ysize(5.5) ///
    name(figure_a18, replace)

graph export "${dir_graphs}/figure_a18.png", as(png) width(2400) replace

display _n as result "Figure A18 saved to: ${dir_graphs}/figure_a18.png"
