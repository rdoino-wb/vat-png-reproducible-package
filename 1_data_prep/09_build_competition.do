/*==============================================================================
 09_build_competition.do
 VAT exemption pass-through and incidence (Papua New Guinea) — data preparation

 PURPOSE : Clean BPNG Business Sentiment Survey competition data for H1 2025 and
           H2 2025, build a balanced panel of firms responding in both periods,
           and save firm-period long and firm-level wide datasets for paired
           analysis.
 INPUTS  : ${raw_sentiment}/Copy_of_Wholesale_retail_competition.xlsx
 OUTPUTS : ${final_sentiment}/competition_long.dta   (one row per firm-period)
           ${final_sentiment}/competition_wide.dta   (one row per firm)
 DEPENDS : none (reads Raw/)
 CALLED BY: main.do
==============================================================================*/

local infile  "${raw_sentiment}/Copy_of_Wholesale_retail_competition.xlsx"
local sheets  "H1_2025_data H2_2025_data"

tempfile h1 h2

forvalues p = 1/2 {
    local sheet : word `p' of `sheets'

    * Import without firstrow; column positions are reliable, names are not
    * because H1 sheet has trailing spaces and arrow glyphs in headers.
    import excel using "`infile'", sheet("`sheet'") cellrange(A1) ///
        allstring clear

    * Drop header row, keep needed positional columns
    drop in 1
    rename A firm
    rename D region
    rename E increase
    rename F decrease
    rename G stay
    keep firm region increase decrease stay
    drop if mi(firm)

    * Coerce response indicators to 0/1
    foreach v of varlist increase decrease stay {
        destring `v', replace force
        replace `v' = 0 if mi(`v')
    }

    * Clean firm and region strings
    replace firm   = strtrim(strupper(firm))
    replace region = strtrim(strupper(region))

    * Indicators
    gen byte period    = `p'
    gen byte responded = (increase + decrease + stay) > 0
    gen byte inc_bin   = (increase == 1) if responded
    gen byte dec_bin   = (decrease == 1) if responded
    gen byte same_bin  = (stay     == 1) if responded
    gen byte NCD       = region == "NCD"

    if `p' == 1 save `h1', replace
    else         save `h2', replace
}

* ---- Combine into long panel ----
use `h1', clear
append using `h2'

label define period_lbl 1 "H1 2025" 2 "H2 2025"
label values period period_lbl

label var firm      "Firm name (anonymised)"
label var region    "Region"
label var NCD       "1 if firm in NCD, 0 otherwise"
label var period    "Survey period"
label var responded "1 if firm gave any response in this period"
label var inc_bin   "1 if firm reported competition increased"
label var dec_bin   "1 if firm reported competition decreased"
label var same_bin  "1 if firm reported competition unchanged"

order firm region NCD period responded inc_bin dec_bin same_bin
sort firm period

* ---- Handle duplicate firm entries ----
* "MALAMA ENTERPRISES LTD" is listed twice in each sheet (a double-space
* in the name makes the rows look distinct in Excel but they collapse to
* the same string once trimmed). Resolve by taking the firm's strongest
* response across duplicate rows in each period: a firm "responded" if
* any of its rows did, and reported "increase" if any of its rows did.
collapse (max) responded inc_bin dec_bin same_bin, ///
    by(firm region NCD period)

save "${final_sentiment}/competition_long.dta", replace

* ---- Wide panel for paired analysis ----
keep firm region NCD period responded inc_bin
reshape wide responded inc_bin, i(firm region NCD) j(period)

rename responded1 r_h1
rename responded2 r_h2
rename inc_bin1   inc_h1
rename inc_bin2   inc_h2

* The 'exact panel': firms responding in both periods
gen byte in_panel = (r_h1 == 1) & (r_h2 == 1)
gen      diff_inc = inc_h2 - inc_h1 if in_panel

label var in_panel "1 if firm responded in both H1 2025 and H2 2025"
label var diff_inc "Within-firm change in P(increase): H2 minus H1"

save "${final_sentiment}/competition_wide.dta", replace

* ---- Sample size diagnostic ----
display _n as text "{hline 70}"
display as text "Competition panel sample sizes"
display as text "{hline 70}"
count if in_panel
display as text "  Firms responding in both periods: " as result `r(N)'
count if in_panel & NCD == 1
display as text "    NCD:             " as result `r(N)'
count if in_panel & NCD == 0
display as text "    Rest of country: " as result `r(N)'
display as text "{hline 70}"
