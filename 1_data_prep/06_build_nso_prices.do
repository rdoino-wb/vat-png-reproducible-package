/*==============================================================================
 06_build_nso_prices.do
 VAT exemption pass-through and incidence (Papua New Guinea) — data preparation

 PURPOSE : Extract NSO administrative price-tracking data from two workbooks
           (control and GST-exempt items), reshape to a long item-month panel
           with treatment and post-reform indicators.
 INPUTS  : ${raw_nso}/Comparision_Group.xlsx                     (control, treat=0)
           ${raw_nso}/GST exempt goods WB tracking - Edited.xlsx (exempt, treat=1)
 OUTPUTS : ${final_nso}/WB_Tracking_Prices_Wide.dta  (one row per product)
           ${final_nso}/NSO_Prices_Long.dta          (long item-month panel)
 DEPENDS : none (reads Raw/)
 CALLED BY: main.do

 NOTES:
   Each sheet (verified on the control workbook): row 1 = monthly date headers
   with cols A,B BLANK and dates in col C onward (Dec 2023 .. Dec 2026, 37 cols);
   row 2 onward = product rows, cols A,B = Category, Item, col C onward = prices.
   Below the price block: a blank gap, then a percentage-change block (with
   #DIV/0!), which is excluded.

   Price columns are detected and renamed by position; dates map from
   price1 = Dec 2023 (col C). month_year uses Jan 2023 = 1, so Dec 2023 = 12,
   May 2025 = 29, June 2025 = 30 (reform). Confirmed against the workbook header.

   SELECTION (header row has blank A,B, so select on product rows, not row number):
     - Control: keep the first product row (first row with non-missing Item).
     - Treated: keep the contiguous price block from the first product row up to
       the first blank row after it. The header (Item missing) sits above the first
       product and is excluded automatically.
==============================================================================*/

clear all
set more off

********************************************************************************
* PART 1: CONTROL ITEMS (treat = 0). Keep first product row per sheet.
********************************************************************************

display _newline "CONTROL ITEMS..."

local sheets `""Kaukau - Sweet Potatoe" "Brocoli" "Aibika -commom leafy Veg" "Bananas" "Butter" "Tinned Baked Beans" "Sugar" "Sausages" "Powdered Milk" "Breakfast Cereals" "Milo" "Salt""'

tempfile control_wide
local first = 1
foreach sheet of local sheets {
    display "  control: `sheet'"
    capture import excel "${raw_nso}/Comparision_Group.xlsx", sheet("`sheet'") allstring clear
    if _rc {
        display as error "    Could not read sheet `sheet' (rc=`=_rc')"
        continue
    }
    rename A Category
    rename B Item
	
    * keep the contiguous price block: first product row to the first blank row
    gen long _rn = _n
    quietly summarize _rn if !missing(Item)
    local firstprod = r(min)
    gen byte _blank = missing(Category) & missing(Item)
    quietly summarize _rn if _blank & _rn > `firstprod'
    local cut = cond(r(N) > 0, r(min), _N + 1)
    quietly keep if _rn >= `firstprod' & _rn < `cut'
    drop _rn _blank
	
    * destring price columns (everything except Category, Item)
    foreach v of varlist _all {
        if !inlist("`v'", "Category", "Item") destring `v', replace force
    }
    gen byte treat = 0

    if `first' == 1 {
        quietly save `control_wide', replace
        local first = 0
    }
    else {
        quietly append using `control_wide'
        quietly save `control_wide', replace
    }
}
if `first' == 1 {
    display as error "No control sheets could be read from Comparision_Group.xlsx."
    exit 459
}
use `control_wide', clear
quietly count
display "  Control rows: " r(N)
tempfile all_control
quietly save `all_control'

********************************************************************************
* PART 2: TREATED ITEMS (treat = 1). Keep the contiguous price block.
********************************************************************************

display _newline "TREATED ITEMS..."

local sheets `""Biscuits" "Flour" "Rice" "Instant noodles" "Chicken" "Tinned meat" "Tinned fish" "Cooking Oil" "Coffee" "Tea" "Soap" "Baby diapers""'

tempfile treated_wide
local first = 1
foreach sheet of local sheets {
    display "  treated: `sheet'"
    capture import excel "${raw_nso}/GST exempt goods WB tracking - Edited.xlsx", sheet("`sheet'") allstring clear
    if _rc {
        display as error "    Could not read sheet `sheet' (rc=`=_rc')"
        continue
    }
    rename A Category
    rename B Item
    gen long _rn = _n
    * first product row (skips the blank-A,B date header above it)
    quietly summarize _rn if !missing(Item)
    local firstprod = r(min)
    * first fully blank row at or after the first product = end of the price block
    gen byte _blank = missing(Category) & missing(Item)
    quietly summarize _rn if _blank & _rn > `firstprod'
    local cut = cond(r(N) > 0, r(min), _N + 1)
    quietly keep if _rn >= `firstprod' & _rn < `cut'
    drop _rn _blank
    foreach v of varlist _all {
        if !inlist("`v'", "Category", "Item") destring `v', replace force
    }
    gen byte treat = 1

    if `first' == 1 {
        quietly save `treated_wide', replace
        local first = 0
    }
    else {
        quietly append using `treated_wide'
        quietly save `treated_wide', replace
    }
}
if `first' == 1 {
    display as error "No treated sheets could be read from GST exempt goods WB tracking - Edited.xlsx."
    exit 459
}
use `treated_wide', clear
quietly count
display "  Treated rows: " r(N)
tempfile all_treated
quietly save `all_treated'

********************************************************************************
* PART 3: Combine, rename price columns by position, save wide
********************************************************************************

display _newline "Combining datasets..."

use `all_control', clear
append using `all_treated'

* Rename the month columns (everything except Category, Item, treat) to
* price1..priceK in dataset (left-to-right) order. price1 = col C = Dec 2023.
ds
local vars `r(varlist)'
local pnum = 0
foreach v of local vars {
    if inlist("`v'", "Category", "Item", "treat") continue
    local ++pnum
    rename `v' price`pnum'
}
local K = `pnum'
display "  Month columns detected: `K'"

replace Item     = strtrim(Item)
replace Category = strtrim(Category)

save "${final_nso}/WB_Tracking_Prices_Wide.dta", replace
quietly count
display "Total products: " r(N)

********************************************************************************
* PART 4: Reshape wide to long
********************************************************************************

display _newline "Reshaping to long..."

gen long product_id = _n
reshape long price, i(product_id) j(month_num)
drop if missing(price)
rename price Price

********************************************************************************
* PART 5: Dates. price1 (month_num 1) = Dec 2023, confirmed against the header.
*   month_year uses Jan 2023 = 1: Dec 2023 = 12, May 2025 = 29, June 2025 = 30.
********************************************************************************

gen int month_year = 11 + month_num
gen int year  = 2023 + floor((month_year - 1) / 12)
gen int month = mod(month_year - 1, 12) + 1
gen int post  = (month_year >= 30)            // post = June 2025 onward

gen date = mdy(month, 1, year)
format date %td
gen str7 month_str = string(year) + "-" + string(month, "%02.0f")

label variable Item       "Product name"
label variable Category   "Product category"
label variable Price      "Price (PGK)"
label variable treat      "1=Treated (exempt), 0=Control"
label variable date       "Date"
label variable month_year "Month-year (Jan 2023 = 1)"
label variable post       "Post-June 2025 reform"

order Item Category Price treat date month year month_str month_year post
sort treat Item month_year
drop product_id month_num

********************************************************************************
* PART 6: Summary, checks, save
********************************************************************************

quietly count
display _newline "Total observations: " r(N)
assert r(N) > 0

quietly count if treat == 0
display "  Control obs: " r(N)
quietly count if treat == 1
display "  Treated obs: " r(N)

quietly summ month_year
display "Month-year range: " r(min) " to " r(max)

* May 2025 must be present for the pass-through normalization (month_year == 29)
quietly count if month_year == 29
display _newline "Rows in May 2025 (month_year==29): " r(N)
assert r(N) > 0

save "${final_nso}/NSO_Prices_Long.dta", replace

display "{hline 80}"
display "NSO EXTRACTION COMPLETE"
display "{hline 80}"
********************************************************************************
