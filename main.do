********************************************************************************
* PROJECT: Who Benefits from Food Tax Exemptions in Lower-Income Settings?
*          Evidence on Pass-Through and Incidence (Papua New Guinea VAT exemptions)
*
* MASTER SCRIPT (Stata). Reproducibility package.
*
* HOW TO RUN
*   1. Set ONE path below: the global `root` in Section 1. Nothing else changes.
*   2. Run this file. It installs packages, prepares data, then pauses.
*   3. When prompted, run Code/main.R in R, then return here and press any key.
*
* RUN STRUCTURE (Stata -> R -> Stata)
*   Section 4   Data preparation       Code/1_data_prep/
*   PAUSE       Maps + proximity (R)    Code/main.R  ->  Code/2_maps/
*   Sections 6-9 Analysis, tables, figs Code/3_analysis/, 4_online_appendix/, 5_experts/
*
* The run order below is authoritative. Data-prep files are numbered in run order.
*
* Output locations (set in Section 1):
*   Figures -> Outputs/Figures (scripts create subfolders within)
*   Tables  -> Outputs/Tables
*   Logs    -> logs/
*
* Exhibit -> script mapping: see docs/exhibit_manifest.md and README.md (List of Exhibits).
********************************************************************************

clear all
set more off
set varabbrev off
set linesize 255
version 17

********************************************************************************
* 1. SET DIRECTORIES  --  CHANGE ONLY THIS ONE LINE
********************************************************************************

global root "/Users/rdoino/Library/CloudStorage/OneDrive-WBG/Desktop/VAT Exemption Through PNG"

* Derived paths (do not edit)
global dir_do     "${root}/Code"
global dir_data   "${root}/Data"
global dir_graphs "${root}/Outputs/Figures"
global dir_tables "${root}/Outputs/Tables"
global dir_logs   "${root}/logs"

* Data source folders
global raw_census     "${dir_data}/Raw/census"
global raw_experts    "${dir_data}/Raw/experts_survey"
global raw_phone      "${dir_data}/Raw/phone_survey"
global raw_stores     "${dir_data}/Raw/store_collection"
global raw_e_stores   "${dir_data}/Raw/e_store_collection"
global raw_rpi        "${dir_data}/Raw/rpi"
global raw_nso        "${dir_data}/Raw/nso"
global raw_sentiment  "${dir_data}/Raw/sentiment"       // BPNG Business Sentiment Survey (competition, pass-through)
global phone_extract "${raw_phone}/20260429/PNG_HFPS_Household_weighted_wFood.dta"  // authoritative HFPS extract (29 Apr 2026 pull) used by every script that reads the phone survey. Update the dated subfolder here if a newer pull is used.

global final_census   "${dir_data}/Final/census"
global final_experts  "${dir_data}/Final/experts_survey"
global final_phone    "${dir_data}/Final/phone_survey"
global final_stores   "${dir_data}/Final/store_collection"
global final_e_stores "${dir_data}/Final/e_store_collection"
global final_rpi      "${dir_data}/Final/rpi"
global final_nso      "${dir_data}/Final/nso"
global final_sentiment "${dir_data}/Final/sentiment"

* Create Final data subdirectories if missing (cleaning scripts save here)
cap mkdir "${dir_data}/Final"
cap mkdir "${final_census}"
cap mkdir "${final_experts}"
cap mkdir "${final_phone}"
cap mkdir "${final_stores}"
cap mkdir "${final_e_stores}"
cap mkdir "${final_rpi}"
cap mkdir "${final_nso}"
cap mkdir "${final_sentiment}"

* Create output directories if missing
cap mkdir "${dir_graphs}"
cap mkdir "${dir_tables}"
cap mkdir "${dir_logs}"

********************************************************************************
* 2. LOG
********************************************************************************

local today = string(date(c(current_date), "DMY"), "%tdCCYY-NN-DD")
cap log close
log using "${dir_logs}/main_`today'.log", replace text

display as text "{hline 80}"
display as text "MAIN.DO  started `c(current_date)' `c(current_time)'"
display as text "{hline 80}"

********************************************************************************
* 3. VERIFY USER-WRITTEN PACKAGES
********************************************************************************

local packages "estout gtools winsor2 reghdfe ftools regsave mmat2tex boottest distinct"
foreach pkg of local packages {
    capture which `pkg'
    if _rc {
        display as text "Installing: `pkg'"
        ssc install `pkg', replace
    }
}

********************************************************************************
* 4. DATA PREPARATION  (Code/1_data_prep/)
*    Builds the Final/ datasets from Raw/. Files are numbered in run order.
********************************************************************************

do "${dir_do}/1_data_prep/01_globals.do"            // definitions, labels, colors (no output)
do "${dir_do}/1_data_prep/02_build_phone_panel.do"  // -> Final/phone_survey: final_dataset.dta, product_prices_panel.dta
do "${dir_do}/1_data_prep/03_build_map_inputs.do"   // -> Final/phone_survey: map.csv, map_month.csv, map_monthly_avg.csv
do "${dir_do}/1_data_prep/04_labels_geographic.do"  // geographic value labels (province/district/ward)
do "${dir_do}/1_data_prep/05_build_store_prices.do" // -> Final/store_collection: POM_Prices_Long_Clean.dta/.csv
do "${dir_do}/1_data_prep/06_build_nso_prices.do"   // -> Final/nso: NSO_Prices_Long.dta, WB_Tracking_Prices_Wide.dta
do "${dir_do}/1_data_prep/07_build_cpi_panel.do"    // -> Final/nso: cpi_quarterly_panel.dta (NSO Table 13; used by cpi_did_robustness.do)
do "${dir_do}/1_data_prep/08_build_rpi_panel.do"    // -> Final/rpi: rpi_cleaned_data.dta/.csv (BPNG retail price index)
do "${dir_do}/1_data_prep/09_build_competition.do"  // -> Final/sentiment: competition_long.dta, competition_wide.dta
do "${dir_do}/1_data_prep/10_build_passthrough.do"  // -> Final/sentiment: passthrough_locations.dta, passthrough_groups.dta

display as result _newline "DATA PREPARATION COMPLETE"

********************************************************************************
* 5. PAUSE: run the R stage (maps + supermarket proximity)
*   In R, open Code/main.R, set its `root`, and run it. It produces:
*     Figure 1  Outputs/Figures/figure_1.png  (Port Moresby store proximity map)
*     Figure 2  Outputs/Figures/figure_2.png  (phone-survey respondent map)
*   and it also:
*     - writes Final/phone_survey/png_survey_by_district.dta (used by Table A2), and
*     - adds proximity_tertile to Final/store_collection/POM_Prices_Long_Clean
*       (used below by the store analysis).
*   Then return here and press any key.
********************************************************************************

pause on
display as error "ACTION REQUIRED: run Code/main.R in R, then come back here and run the rest of the script."
pause

********************************************************************************
* 6. DESCRIPTIVES AND CONSUMPTION  (Code/3_analysis/)
********************************************************************************

do "${dir_do}/3_analysis/tableA2_representativeness.do"    // Table A2 (survey vs 2011 census)
do "${dir_do}/3_analysis/figsA1_A7_consumption.do"         // Figs A1-A7 (consumption/expenditure by quintile)
do "${dir_do}/3_analysis/tableA3_familiarity.do"           // Table A3 (familiarity with tax reduction) -> table_a3.{tex,csv}
do "${dir_do}/3_analysis/tableA4_hte_support.do"           // Table A4 (treatment effect on food-tax support by prior policy) -> table_a4.tex
do "${dir_do}/3_analysis/figA22_policy_preferences.do"     // Fig A22 (policy-preference stacked bar, April 2026) -> figure_a22.png
do "${dir_do}/3_analysis/figsA10_A11_expenditure_trends.do" // Figs A10, A11 (monthly expenditure trends) -> figure_a10, figure_a11
do "${dir_do}/3_analysis/figsA17_A18_sentiment.do"         // Figs A17 (pass-through) and A18 (competition change); BPNG sentiment

********************************************************************************
* 7. EVENT STUDIES / PASS-THROUGH  (Code/3_analysis/)
********************************************************************************

* Phone survey
do "${dir_do}/3_analysis/figsA20_A21_raw_trends.do"        // Figs A20, A21 (phone raw price trends)
do "${dir_do}/3_analysis/figA19_event_study_hh.do"         // Fig A19 (phone event studies)
do "${dir_do}/3_analysis/table2_passthrough.do"            // Table 2 (phone pass-through, post; builds panel from raw inline)

* Store census
do "${dir_do}/3_analysis/figsA36_A38_event_study_stores.do"   // Figs A36 (store type), A38 (luxury)
do "${dir_do}/3_analysis/figA37_store_distribution.do"        // Fig A37 (store-by-store distribution) + t-tests
do "${dir_do}/3_analysis/fig4ab_event_study_competition.do"   // Figs 4a, 4b; writes store_competition_groups.dta (needed next)
do "${dir_do}/3_analysis/fig4c_within_chain.do"               // Fig 4c (within Stop and Shop; reads store_competition_groups.dta)

* Combined administrative sources
do "${dir_do}/3_analysis/figs3_A14_A15_combined_passthrough.do" // Figs 3a, 3b and A14, A15 (NSO + RPI + store survey)

* Quarterly CPI robustness (NSO Table 13)
do "${dir_do}/3_analysis/cpi_did_robustness.do"            // cpi_did_table.tex + figure_a12 (event study) + figure_a13 (price index)

* Incidence by income quintile
do "${dir_do}/3_analysis/fig5_incidence.do"                // Figs 5a, 5b (incidence + regressivity decomposition)

* Policy cost comparison
do "${dir_do}/3_analysis/table3_alternative_policies.do"   // Table 3 (alternative-policy cost; calibration, no data input)

********************************************************************************
* 8. EXPERT PREDICTION SURVEY  (Code/5_experts/)
********************************************************************************

do "${dir_do}/5_experts/figsA23_A33_experts_survey.do"     // Figs A23-A33, Table A5; writes experts_survey_processed.dta
do "${dir_do}/5_experts/figsA34_A35_experts_hte.do"        // Figs A34, A35 + expert_heterogeneity_summary.{tex,csv}
do "${dir_do}/5_experts/fig6_actual_vs_expert.do"          // Fig 6 (actual incidence vs expert prediction)

********************************************************************************
* 9. ONLINE STORES (APPENDIX)  (Code/4_online_appendix/)
********************************************************************************

do "${dir_do}/4_online_appendix/build_online_prices.do"       // -> Final/e_store_collection/combined_cleaned_data.dta
do "${dir_do}/4_online_appendix/fig4d_online_vs_instore.do"   // Fig 4d (online vs in-store pass-through)

********************************************************************************
* 10. DONE
********************************************************************************

display as result _newline "ALL ANALYSIS COMPLETE"
display as text "Figures: ${dir_graphs}"
display as text "Tables:  ${dir_tables}"
log close

* NOTES
*  - Figs A17 and A18 are produced by the merged figsA17_A18_sentiment.do.
*  - Tables 2, A3, A4 and Figs 5, 6, A10/A11, A22 rebuild their panels from the
*    raw phone extract (${phone_extract}) inline.
*  - Figs A12, A13 are produced by cpi_did_robustness.do.
*  - The item-level DiD reconstruction is not part of this package and is not run.
*  - See docs/exhibit_manifest.md for the authoritative exhibit -> script -> line map.
********************************************************************************
* END
********************************************************************************
