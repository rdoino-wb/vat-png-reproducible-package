/*==============================================================================
 05_build_store_prices.do
 VAT exemption pass-through and incidence (Papua New Guinea) — data preparation

 PURPOSE : Extract Port Moresby supermarket price data from a multi-sheet Excel
           workbook, match to store GPS coordinates, parse quantities, assign
           item codes and treatment groups, and build a clean long dataset.
 INPUTS  : ${raw_stores}/POM PRICE COLLECTION.xlsx (multi-sheet: gps_coordinates
           plus one sheet per store)
 OUTPUTS : ${final_stores}/POM_Prices_Long_Clean.dta
           ${final_stores}/POM_Prices_Long_Clean.csv
 DEPENDS : 01_globals.do (item/treatment value labels)
 CALLED BY: main.do
==============================================================================*/

clear all
set more off

********************************************************************************
* 1. SETUP
********************************************************************************

* Set file path
local excel_file "${raw_stores}/POM PRICE COLLECTION.xlsx"

* SET NUMBER OF MONTHS TO EXTRACT - UPDATE THIS!
* 3 = May, June, July
* 4 = May, June, July, August
* 5 = May, June, July, August, September
* etc.
local num_months = 6

* Check if file exists
capture confirm file "`excel_file'"
if _rc {
    display as error "ERROR: Excel file not found"
    exit 601
}

* Create temporary file to store combined data
tempfile combined_data
local first_append = 1

********************************************************************************
* 2. EXTRACT GPS COORDINATES AND SUPERMARKET NAMES
********************************************************************************

import excel "`excel_file'", sheet("gps_coordinates") firstrow clear
keep if !missing(lat) & !missing(lng)
destring lat lng, replace force
keep if lat < 0 & lat > -15 & lng > 140 & lng < 160
gen gps_index = _n

* Keep store_type variable (Independent vs Chain)
capture confirm variable store_type
if _rc == 0 {
    * Clean and standardize store_type values
    replace store_type = proper(trim(store_type))
    replace store_type = "Independent" if inlist(lower(store_type), "independent", "independant")
    replace store_type = "Chain" if inlist(lower(store_type), "chain")
}
else {
    gen store_type = ""
}

keep gps_index Name Suburb lat lng store_type
tempfile gps_data
save `gps_data', replace

********************************************************************************
* 3. DEFINE SHEET NAMES
********************************************************************************

local sheet_names `" " SNS Down Town" "Range View" "RH VC" "Eliseo Supermarket Waigani" "Waterfront" "Rainbow Stop and Shop " "Boroko Foodworld" "Tango Tokarara" "1Stop village Shopping Mall" "Stop N Shop Badili" "Meat Haus (Waigani Drive) Port " "SNS Airways" "K Mart Supermarket" "PINGAN Trading " "TANGO (Boroko)" "Kwik Mart Tokarara" "Bro and Sis (TNZ Butchery and W" "Waigani Wholesale " "Bhuiya Waigani" "Eliseo Rainbow" "papindo Gerehu " "RH Gordons " "Navana Holdings" "Desh Besh Gordons" "Eliseo Boroko" "SNS Waigani Central" "SNS Boroko" "SVS 4mile" "Keme Trading #3" "M&S Trading " "Desh Besh Kons" "Thomand" "Mountain friend" "Bulk traders" "Rainbow Cash and Carry (Chinese" "Byron" "Jmart" "SNS 8 Mile" "9 Mile Plaza" "9 Mile Elesio " "Elesio Mosin Plaza " "Wan Mart" "Amart " "Rephen supermarket " "Honyu" "WaDAwADA supermarket " "Manu cash and carry" "Alhamdulillah investment manu" "IFRA" "Shorna Vadavada Taurama" "En Dian Enterprise Taurama " "ASDA Enterprises " "Super City Taurama" "No name (Across from Jannat2)" "Jannat2 (Taurama)" "Rahana Wholesale Morata" "Ekra Enterprise #3 Morata " "Ekra #7 Morata" "Best Gear. Gordons " "Central Supermarket Gordon " "Skel Wan Supermarket Gordons" "Eliseo Wholesale Gordons " "Gordons Wholesale " "Jade Island Gordons" "Plazawan Shopping Centre Gordon" "Eliseo Erima" "Bhuiya Erima" "Supreme Investment 6 mile" "Azmir Cash and Carry" "Happy Supermarket " "Xushang Supermarket 6mile" "Goodlink Wholesale and Supermar" "Shopsmart manu" "Kwik Mart Manu" "RH Kwik Mart Rainbow" "Ivy Waikele" "Ekra Waikele " "Best Price Gerehu " "Badili Mart" "Wayback Supermarket Hanuabada " "New Star Hanuabada" "Maxim Trading Sabama" "Unity Supermarket Sabama" "Shop and save Tokarara" "'

********************************************************************************
* 4. PROCESS DATA SHEETS
********************************************************************************

local sheet_counter = 0

foreach sheet_name of local sheet_names {
    
    local sheet_counter = `sheet_counter' + 1
    
    preserve
    use `gps_data', clear
    qui levelsof Name if gps_index == `sheet_counter', local(gps_name) clean
    restore
    
    if "`gps_name'" == "" {
        local gps_name "`sheet_name'"
    }
    
    capture {
        quietly import excel "`excel_file'", sheet("`sheet_name'") cellrange(A1) clear allstring
    }
    
    if _rc != 0 {
        display as error "ERROR: Sheet `sheet_name' not found"
        continue
    }
    
    if _N < 5 {
        continue
    }
    
    * Get enumerator name from row 2
    local enumerator "Not specified"
    if _N >= 2 & !missing(A[2]) & A[2] != "" {
        local enumerator = A[2]
    }
    
    * Extract month names from row 3 for proper labeling
    forvalues m = 1/`num_months' {
        local col_num = 3 + (`m' * 2) - 1  // D=4, F=6, H=8, J=10, etc.
        
        * Get column letter
        if `col_num' <= 26 {
            local col_letter = substr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", `col_num', 1)
        }
        else {
            local first_letter = substr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", floor((`col_num'-1)/26), 1)
            local second_letter = substr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", mod(`col_num'-1, 26) + 1, 1)
            local col_letter "`first_letter'`second_letter'"
        }
        
        * Get month name from row 3
        capture confirm variable `col_letter'
        if _rc == 0 & _N >= 3 {
            local month_name_`m' = `col_letter'[3]
            if missing("`month_name_`m''") | "`month_name_`m''" == "" {
                local month_name_`m' "Month`m'"
            }
        }
        else {
            local month_name_`m' "Month`m'"
        }
    }
    
    keep if _n >= 5
    
    * Build column list to keep: A, B, C, then Price/Quantity pairs
    local keep_cols "A B C"
    forvalues m = 1/`num_months' {
        local price_col_num = 3 + (`m' * 2) - 1  // D, F, H, J, ...
        local qty_col_num = 3 + (`m' * 2)        // E, G, I, K, ...
        
        * Convert to column letters
        if `price_col_num' <= 26 {
            local price_col = substr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", `price_col_num', 1)
        }
        else {
            local first = substr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", floor((`price_col_num'-1)/26), 1)
            local second = substr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", mod(`price_col_num'-1, 26) + 1, 1)
            local price_col "`first'`second'"
        }
        
        if `qty_col_num' <= 26 {
            local qty_col = substr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", `qty_col_num', 1)
        }
        else {
            local first = substr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", floor((`qty_col_num'-1)/26), 1)
            local second = substr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", mod(`qty_col_num'-1, 26) + 1, 1)
            local qty_col "`first'`second'"
        }
        
        * Check if columns exist before adding to keep list
        capture confirm variable `price_col'
        if _rc == 0 {
            local keep_cols "`keep_cols' `price_col'"
        }
        capture confirm variable `qty_col'
        if _rc == 0 {
            local keep_cols "`keep_cols' `qty_col'"
        }
    }
    
    keep `keep_cols'
    
    * Rename columns - keep column C but we won't use it later
    rename A Item
    rename B Brand  
    capture rename C StandardAmount_unused
    
    * Rename Price and Quantity columns for each month
    forvalues m = 1/`num_months' {
        local price_col_num = 3 + (`m' * 2) - 1
        local qty_col_num = 3 + (`m' * 2)
        
        if `price_col_num' <= 26 {
            local price_col = substr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", `price_col_num', 1)
        }
        else {
            local first = substr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", floor((`price_col_num'-1)/26), 1)
            local second = substr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", mod(`price_col_num'-1, 26) + 1, 1)
            local price_col "`first'`second'"
        }
        
        if `qty_col_num' <= 26 {
            local qty_col = substr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", `qty_col_num', 1)
        }
        else {
            local first = substr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", floor((`qty_col_num'-1)/26), 1)
            local second = substr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", mod(`qty_col_num'-1, 26) + 1, 1)
            local qty_col "`first'`second'"
        }
        
        capture confirm variable `price_col'
        if _rc == 0 {
            rename `price_col' Price_`month_name_`m''
        }
        
        capture confirm variable `qty_col'
        if _rc == 0 {
            rename `qty_col' Quantity_`month_name_`m''
        }
    }
    
    * Remove rows with missing Item
    drop if missing(Item) | Item == ""
    
    * Create long format
    gen sheet_index = `sheet_counter'
    gen Supermarket = "`gps_name'"
    gen Sheet_Tab_Name = "`sheet_name'"
    gen Enumerator = "`enumerator'"
    
    * Reshape to long format
    local price_vars ""
    local qty_vars ""
    forvalues m = 1/`num_months' {
        local price_vars "`price_vars' Price_`month_name_`m''"
        local qty_vars "`qty_vars' Quantity_`month_name_`m''"
    }
    
    reshape long Price_ Quantity_, i(Item Brand sheet_index) j(Month) string
    rename Price_ Price
    rename Quantity_ old_quantity
    
    * Format month to title case (first letter uppercase)
    replace Month = upper(substr(Month, 1, 1)) + lower(substr(Month, 2, .))
    
    * Drop unused standard amount column
    capture drop StandardAmount_unused
    
    * Merge GPS data
    gen gps_index = sheet_index
    merge m:1 gps_index using `gps_data', keep(master match) nogenerate
    drop gps_index
    
    if `first_append' == 1 {
        save `combined_data', replace
        local first_append = 0
    }
    else {
        append using `combined_data'
        save `combined_data', replace
    }
}

********************************************************************************
* 5. CLEAN AND FINALIZE DATA
********************************************************************************

use `combined_data', clear

* Create item code variable (manual assignment to match treatment variables)
gen item_code = .
replace item_code = 103 if lower(Item) == "bananas"
replace item_code = 132 if lower(Item) == "biscuits"
replace item_code = 128 if regexm(lower(Item), "breakfast cereal")
replace item_code = 134 if regexm(lower(Item), "broccol")
replace item_code = 129 if lower(Item) == "butter"
replace item_code = 116 if regexm(lower(Item), "chicken")
replace item_code = 133 if lower(Item) == "coffee"
replace item_code = 104 if regexm(lower(Item), "cooking oil")
replace item_code = 110 if lower(Item) == "flour"
replace item_code = 102 if regexm(lower(Item), "kaukau")
replace item_code = 130 if lower(Item) == "milo"
replace item_code = 131 if lower(Item) == "noodles"
replace item_code = 127 if regexm(lower(Item), "powdered milk")
replace item_code = 105 if lower(Item) == "rice"
replace item_code = 115 if lower(Item) == "sausages"
replace item_code = 101 if lower(Item) == "sugar"
replace item_code = 108 if lower(Item) == "tea"
replace item_code = 126 if regexm(lower(Item), "tinned baked beans")
replace item_code = 114 if regexm(lower(Item), "tinned beef")
replace item_code = 107 if regexm(lower(Item), "tinned fish")
replace item_code = 111 if regexm(lower(Item), "aibika")

* Apply item labels (already defined in master globals)
label val item_code items_lab

* Clean and destring Price
replace Price = "" if Price == "." | Price == "NA" | Price == "N/A"
destring Price, replace force

* Keep only observations with valid prices
keep if !missing(Price) & Price > 0

********************************************************************************
* 6. PARSE QUANTITY - SIMPLIFIED VERSION
********************************************************************************

* Handle special case: if Quantity == "kg", it means 1kg by definition
replace old_quantity = "1kg" if lower(trim(old_quantity)) == "kg"

* Parse Quantity
gen quantity_clean = lower(trim(itrim(old_quantity)))

* Remove extra spaces and clean up
replace quantity_clean = subinstr(quantity_clean, "  ", " ", .)
replace quantity_clean = trim(quantity_clean)

* Fix common typos (specific cases from your data)
replace quantity_clean = "80g" if quantity_clean == "80kg"
replace quantity_clean = "320g" if quantity_clean == "320kg"
replace quantity_clean = "375g" if quantity_clean == "375kg"
replace quantity_clean = "100g" if quantity_clean == "100t"
replace quantity_clean = "900g" if quantity_clean == "900h"

* Remove trailing dots and spaces from units
replace quantity_clean = subinstr(quantity_clean, "g.", "g", .) if regexm(quantity_clean, "g\.$")
replace quantity_clean = subinstr(quantity_clean, "ml.", "ml", .) if regexm(quantity_clean, "ml\.$")
replace quantity_clean = subinstr(quantity_clean, "kg.", "kg", .) if regexm(quantity_clean, "kg\.$")
replace quantity_clean = trim(quantity_clean)

* Handle "per kg" cases (these indicate per-kilogram pricing, not quantity)
replace quantity_clean = "1kg" if regexm(quantity_clean, "^per kg") | quantity_clean == "/kg"

* Extract quantity from descriptive text (e.g., "500g thick sausage", "250 g flora butter")
replace quantity_clean = regexs(1) if regexm(quantity_clean, "^([0-9]+\.?[0-9]* ?(?:kg|g|ml|mls|l))") & regexm(quantity_clean, "[a-z]+ ")

* Handle brand names with quantities (e.g., "kwikai 375g", "Miracle - 250g")
replace quantity_clean = regexs(1) if regexm(quantity_clean, "([0-9]+\.?[0-9]*(?:kg|g|ml|mls|l))$")

* For ranges like "130g/220g", take the first value
replace quantity_clean = regexs(1) if regexm(quantity_clean, "^([0-9]+\.?[0-9]*[a-z]+)/")

* Extract numeric value (first number found)
gen temp_value = real(regexs(1)) if regexm(quantity_clean, "([0-9]+\.?[0-9]*)")

* Extract unit type
gen quantity_unit = ""
replace quantity_unit = "kg" if regexm(quantity_clean, "[0-9] ?kg")
replace quantity_unit = "g" if regexm(quantity_clean, "[0-9] ?g") & quantity_unit == ""
replace quantity_unit = "l" if regexm(quantity_clean, "[0-9] ?l") & quantity_unit == "" & !regexm(quantity_clean, "ml")
replace quantity_unit = "ml" if regexm(quantity_clean, "[0-9] ?(?:ml|mls)")

* For numbers without units < 10, unclear - skip conversion
* For numbers without units between 10-100, likely grams
replace quantity_unit = "g" if quantity_unit == "" & !missing(temp_value) & temp_value >= 10 & temp_value <= 100

* For numbers without units between 100-1000, likely grams
replace quantity_unit = "g" if quantity_unit == "" & !missing(temp_value) & temp_value >= 100 & temp_value < 1000

* For numbers without units >= 1000, likely grams (not kg because they would write kg)
replace quantity_unit = "g" if quantity_unit == "" & !missing(temp_value) & temp_value >= 1000

* For small decimal numbers (1-5), likely kilograms
replace quantity_unit = "kg" if quantity_unit == "" & !missing(temp_value) & temp_value >= 1 & temp_value <= 5 & mod(temp_value, 1) > 0

* Create final quantity variable - single variable for comparison
gen quantity = .

* Weight conversions to grams
replace quantity = temp_value if quantity_unit == "g"
replace quantity = temp_value * 1000 if quantity_unit == "kg"

* Volume conversions to milliliters  
replace quantity = temp_value if quantity_unit == "ml"
replace quantity = temp_value * 1000 if quantity_unit == "l"

* Label quantity variables
label variable old_quantity "Quantity purchased (original text)"
label variable quantity_unit "Unit of measure (g, kg, ml, l)"
label variable quantity "Standardized quantity (grams or milliliters)"

* Clean up temporary variables
drop quantity_clean temp_value

********************************************************************************
* 7. CREATE TREATMENT VARIABLES
********************************************************************************

* Create numeric treatment variables (not string)
gen treat = .
replace treat = 1 if item_code == 104 | item_code == 105 | item_code == 107 | item_code == 108 ///
                   | item_code == 110 | item_code == 114 | item_code == 116 | item_code == 131 ///
                   | item_code == 132 | item_code == 133
replace treat = 0 if item_code == 102 | item_code == 111 | item_code == 101 | item_code == 115 ///
                   | item_code == 103 | item_code == 126 | item_code == 127 | item_code == 128 ///
                   | item_code == 129 | item_code == 130 | item_code == 134 | item_code == 135

gen treat_good = .
replace treat_good = 1 if item_code == 104 | item_code == 105 | item_code == 107 | item_code == 108 ///
                        | item_code == 110 | item_code == 116 | item_code == 131 | item_code == 132
replace treat_good = 0 if item_code == 102 | item_code == 111 | item_code == 101 | item_code == 115 ///
                        | item_code == 103 | item_code == 134 | item_code == 135

gen treat_fair = .
replace treat_fair = 1 if item_code == 104 | item_code == 105 | item_code == 107 | item_code == 108 ///
                        | item_code == 110 | item_code == 116 | item_code == 131 | item_code == 132
replace treat_fair = 0 if item_code == 102 | item_code == 111 | item_code == 101 | item_code == 115 ///
                        | item_code == 103 | item_code == 129 | item_code == 130 | item_code == 134 | item_code == 135

gen treat_good_nobanana = .
replace treat_good_nobanana = 1 if item_code == 104 | item_code == 105 | item_code == 107 | item_code == 108 ///
                                 | item_code == 110 | item_code == 116 | item_code == 131 | item_code == 132
replace treat_good_nobanana = 0 if item_code == 102 | item_code == 111 | item_code == 101 | item_code == 115 ///
                                 | item_code == 134 | item_code == 135

gen treat_all = treat
gen item_group = .
replace item_group = 1 if treat == 1
replace item_group = 2 if treat == 0
replace item_group = 3 if treat == .

* Ensure all treatment variables are numeric (replace any empty strings with missing)
foreach var of varlist treat treat_good treat_fair treat_good_nobanana treat_all item_group {
    capture confirm numeric variable `var'
    if _rc {
        destring `var', replace force
    }
    replace `var' = . if `var' == .
}

* Define luxury goods classification
* Luxury good definition: quintile 1 consumption share < 1/3 of quintile 5 share
* Based on household expenditure survey data
gen luxury = .
replace luxury = 1 if inlist(item_code, 114, 116, 126, 127, 128, 129, 130, 133, 134)  // Quasi-luxury items
replace luxury = 0 if inlist(item_code, 101, 102, 103, 104, 105, 107, 108, 110, 111, 115, 131, 132, 135)  // Basic items
replace luxury = 2 if luxury == .  // Other/unclassified

* Apply value labels (already defined in master globals)
label values treat treat_lab
label values treat_good treat_lab
label values treat_fair treat_lab
label values treat_good_nobanana treat_lab
label values treat_all treat_lab
label values item_group group_lab
label values luxury lux_lab

********************************************************************************
* 8. FINALIZE AND SAVE
********************************************************************************

* Reorder variables
order Supermarket store_type Sheet_Tab_Name sheet_index Enumerator Item item_code treat treat_all ///
      treat_good treat_fair treat_good_nobanana item_group luxury Brand ///
      Month Price old_quantity quantity_unit quantity ///
      lat lng Name Suburb

* Label variables
label variable Item "Product item (original name)"
label variable item_code "Product item code"
label variable Brand "Product brand"
label variable Price "Price in local currency"
label variable Month "Month of observation"
label variable Supermarket "Supermarket name (from GPS list)"
label variable store_type "Store type (Independent vs Chain)"
label variable treat "Dummy indicating treatment group (1 if treated, 0 if control)"
label variable treat_good "Treatment indicator based on good items only"
label variable treat_fair "Treatment indicator based on good and fair items only"
label variable treat_all "Treatment indicator based on all items"
label variable treat_good_nobanana "Treatment indicator based on good items only, excluding bananas"
label variable item_group "Item group category: treatment, control, none"
label variable luxury "Luxury good (quintile 1 share < 1/3 of quintile 5 share)"

* Save final dataset
save "${final_stores}/POM_Prices_Long_Clean.dta", replace
export delimited "${final_stores}/POM_Prices_Long_Clean.csv", replace

********************************************************************************
