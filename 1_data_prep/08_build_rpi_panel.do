/*==============================================================================
 08_build_rpi_panel.do
 VAT exemption pass-through and incidence (Papua New Guinea) — data preparation

 PURPOSE : Import and clean the Bank of Papua New Guinea Retail Price Index data,
           reshape to a long item-month panel, assign treatment status, normalize
           prices to May 2025, and add time and group-average variables.
 INPUTS  : ${raw_rpi}/World_Bank__RPI_Data_Request.xlsx (Central Bank RPI data)
 OUTPUTS : ${final_rpi}/rpi_cleaned_data.dta (cleaned monthly panel)
           ${final_rpi}/rpi_cleaned_data.csv (CSV version)
 DEPENDS : none (reads Raw/)
 CALLED BY: main.do
==============================================================================*/

clear all
set more off

********************************************************************************
* 0. SETUP
********************************************************************************

display as text _newline "{hline 80}"
display as result "CLEANING CENTRAL BANK RPI DATA"
display as text "{hline 80}"

* Policy date
global policy_date = td(01jun2025)
global ref_month = mofd(td(15may2025))

* Create output directory
capture mkdir "${final_rpi}"

********************************************************************************
* 1. IMPORT RAW RPI DATA FROM EXCEL
********************************************************************************

display as text _newline "Step 1: Importing RPI data from Excel..."

* Import simplified Excel
import excel "${raw_rpi}/World_Bank__RPI_Data_Request.xlsx", ///
    sheet("Prices_Essential Household Item") firstrow clear

* Drop first row if it says "Months"
drop if _n == 1

* Convert date (string MDY to Stata date)
gen date = date(Months, "MDY")
format date %td
drop Months

* Verify dates
assert year(date) >= 2024
display as text "  ✓ Imported " _N " monthly observations"
list date in 1/3

********************************************************************************
* 2. RESHAPE FROM WIDE TO LONG FORMAT
********************************************************************************

display as text _newline "Step 2: Stacking all items to long format..."

* Save list of item columns
ds date, not
local items `r(varlist)'
local n_items: word count `items'

* Force item columns to numeric (one text cell makes the whole column string)
destring `items', replace force

display as text "  Items found: `n_items'"

* Stack manually
tempfile all_data
local first = 1
foreach item of local items {
    preserve
    keep date `item'
    rename `item' price
    gen item_name = "`item'"
    drop if missing(price)
    if `first' {
        save `all_data', replace
        local first = 0
    }
    else {
        append using `all_data'
        save `all_data', replace
    }
    restore
}

* Load stacked data
use `all_data', clear

display as text "  ✓ Reshaped to " _N " item-month observations"

********************************************************************************
* 3. CREATE TREATMENT INDICATOR (KEEP ALL ITEMS)
********************************************************************************

display as text _newline "Step 3: Assigning treatment status..."

* Clean item names for matching
gen item_name_clean = subinstr(item_name, " ", "", .)
replace item_name_clean = lower(trim(item_name_clean))

* Initialize treatment = 0 (control) for ALL items
gen treat = 0

* Mark treatment items (VAT exempt) = 1
replace treat = 1 if regexm(item_name_clean, "biscuit")
replace treat = 1 if regexm(item_name_clean, "flour")
replace treat = 1 if regexm(item_name_clean, "rice")
replace treat = 1 if regexm(item_name_clean, "cookingoil")
replace treat = 1 if regexm(item_name_clean, "tinnedfish")
replace treat = 1 if regexm(item_name_clean, "chicken")
replace treat = 1 if regexm(item_name_clean, "instantcoffee")
replace treat = 1 if regexm(item_name_clean, "tea")
replace treat = 1 if regexm(item_name_clean, "tinnedmeat")
replace treat = 1 if regexm(item_name_clean, "pasta")

* Summary
quietly count if treat == 1
local n_treat = r(N)
quietly count if treat == 0
local n_control = r(N)

display as text "  ✓ Treatment items: " %9.0fc `n_treat' " observations"
display as text "  ✓ Control items: " %9.0fc `n_control' " observations"

* Show treatment items
display as text _newline "Treatment items (VAT exempt):"
preserve
    keep if treat == 1
    collapse (first) item_name, by(item_name_clean)
    list, clean noobs
restore

label define treat_lbl 0 "Control (no VAT exemption)" 1 "Treatment (VAT exempt)"
label values treat treat_lbl

********************************************************************************
* 4. CREATE TIME VARIABLES
********************************************************************************

display as text _newline "Step 4: Creating time variables..."

* Month variable
gen month = mofd(date)
format month %tm

* Post-treatment indicator
gen post = (date >= $policy_date)

* Event time (months relative to June 2025)
gen event_time = month - mofd($policy_date)

* Interaction
gen treat_post = treat * post

display as text "  ✓ Time span: " %tm month[1] " to " %tm month[_N]
quietly sum event_time
display as text "  ✓ Event time range: " r(min) " to " r(max) " months"

********************************************************************************
* 5. NORMALIZE PRICES TO MAY 2025
********************************************************************************

display as text _newline "Step 5: Normalizing prices to May 2025..."

* Create item ID for grouping
egen item_id = group(item_name)

* Find May 2025 price for each item
gen may_2025 = (month == mofd(td(15may2025)))
bysort item_id: egen price_base_temp = mean(price) if may_2025 == 1
bysort item_id: egen price_base = max(price_base_temp)
drop price_base_temp may_2025

* Normalize
gen price_norm = price / price_base

* Log prices
gen log_price = log(price)
gen log_price_norm = log(price_norm)

display as text "  ✓ Prices normalized to May 2025 baseline"

********************************************************************************
* 6. CALCULATE GROUP AVERAGES
********************************************************************************

display as text _newline "Step 6: Calculating group averages..."

bysort month treat: egen price_norm_avg = mean(price_norm)
bysort month treat: egen price_avg = mean(price)

label variable price_norm_avg "Average normalized price by group"
label variable price_avg "Average price by group"

********************************************************************************
* 7. ADD LABELS
********************************************************************************

display as text _newline "Step 7: Adding labels..."

label variable date "Date (monthly)"
label variable month "Month (Stata monthly format)"
label variable item_name "RPI item name from Central Bank"
label variable item_name_clean "Cleaned item name (lowercase, no spaces)"
label variable item_id "Item ID"
label variable price "Price (PGK geometric mean)"
label variable price_norm "Normalized price (May 2025 = 1)"
label variable price_base "Base price (May 2025)"
label variable log_price "Log price"
label variable log_price_norm "Log normalized price"
label variable treat "Treatment status (1=VAT exempt, 0=not exempt)"
label variable post "Post-policy indicator (June 2025 onwards)"
label variable event_time "Months relative to June 2025"
label variable treat_post "Treatment × Post interaction"

label define post_lbl 0 "Pre-policy" 1 "Post-policy"
label values post post_lbl

notes: Data source: Bank of Papua New Guinea Retail Price Index
notes: Extraction date: `c(current_date)'
notes: Policy date: June 1, 2025 (VAT exemption on essential food items)

********************************************************************************
* 8. DATA QUALITY CHECKS
********************************************************************************

display as text _newline "Step 8: Running data quality checks..."

* Check for duplicates
duplicates report item_id date
assert r(unique_value) == r(N)

* Verify date range
quietly sum date
assert r(min) >= td(01jan2024)
assert r(max) <= td(30apr2026)
display as text "  ✓ Date range verified"

* Verify all items have pre and post
preserve
    collapse (count) n_obs = price (sum) n_post = post, by(item_id)
    assert n_post > 0
    assert n_post < n_obs
restore
display as text "  ✓ All items have pre and post observations"

********************************************************************************
* 9. SAVE CLEANED DATA
********************************************************************************

display as text _newline "Step 9: Saving cleaned data..."

sort item_id date

order date month item_name item_name_clean item_id treat post event_time treat_post ///
      price price_norm log_price log_price_norm price_base ///
      price_avg price_norm_avg

save "${final_rpi}/rpi_cleaned_data.dta", replace
display as text "  ✓ Saved: ${final_rpi}/rpi_cleaned_data.dta"

export delimited "${final_rpi}/rpi_cleaned_data.csv", replace 
display as text "  ✓ Saved: ${final_rpi}/rpi_cleaned_data.csv"
