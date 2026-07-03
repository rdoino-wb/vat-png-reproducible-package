/*==============================================================================
 10_build_passthrough.do
 VAT exemption pass-through and incidence (Papua New Guinea) — data preparation

 PURPOSE : Clean BPNG Business Sentiment Survey pass-through data (H1 2026),
           aggregate to NCD vs Rest of country, and save analysis datasets.
 INPUTS  : ${raw_sentiment}/World_Bank_request.xlsx
 OUTPUTS : ${final_sentiment}/passthrough_locations.dta
           ${final_sentiment}/passthrough_groups.dta
 DEPENDS : none (reads Raw/)
 CALLED BY: main.do
==============================================================================*/

import excel using "${raw_sentiment}/World_Bank_request.xlsx", sheet("Sheet1") ///
    cellrange(A2:F14) clear

* Row 1 has labels; data start row 2
drop in 1
rename A location
rename B n_firms
rename C p_all
rename D p_some
rename E p_none

keep location n_firms p_all p_some p_none
drop if mi(location) | location == "Grand Total"

destring n_firms p_all p_some p_none, replace force

* Convert proportions to integer counts (rounded)
gen int k_all  = round(p_all  * n_firms)
gen int k_some = round(p_some * n_firms)
gen int k_none = round(p_none * n_firms)

* Sanity check
gen int k_total = k_all + k_some + k_none
assert k_total == n_firms

label var location "Survey location"
label var n_firms  "Number of respondents at location"
label var k_all    "# firms passing ALL costs through"
label var k_some   "# firms passing SOME costs through"
label var k_none   "# firms passing NONE through"

save "${final_sentiment}/passthrough_locations.dta", replace

* ---- Aggregate to NCD vs Rest of country ----
gen byte NCD = location == "NCD"
collapse (sum) n_firms k_all k_some k_none, by(NCD)
gen byte k_any = k_all + k_some

* Proportions (group level)
foreach c in all some none any {
    gen double p_`c' = k_`c' / n_firms
}

label var p_all  "Share passing ALL costs through"
label var p_some "Share passing SOME costs through"
label var p_none "Share passing NONE through"
label var p_any  "Share passing ANY costs through (All + Some)"

label define ncd_lbl 0 "Rest of country" 1 "NCD"
label values NCD ncd_lbl

order NCD n_firms k_all k_some k_none k_any p_all p_some p_none p_any
save "${final_sentiment}/passthrough_groups.dta", replace

* ---- Quick check ----
display _n as text "{hline 70}"
display as text "Pass-through groups (H1 2026):"
list NCD n_firms k_all k_some k_none k_any, sepby(NCD) noobs
display as text "{hline 70}"
