/*
================================================================================
 build_online_prices.do
 VAT exemption pass-through and incidence (Papua New Guinea)

 PURPOSE : Load, standardize, merge, de-duplicate, and product-map online store
           price data (FoodPro & RH Hypermarkets) into a combined dataset.
 INPUTS  : ${raw_e_stores}/foodpro/*.csv ; ${raw_e_stores}/rh/*.csv
 OUTPUTS : ${final_e_stores}/combined_cleaned_data.dta
           ${final_e_stores}/combined_cleaned_data.csv
 DEPENDS : run after web scraping; globals set in main.do data prep
 CALLED BY: main.do
================================================================================
*/

clear all
set more off

display as text _newline "=== STARTING ONLINE STORE DATA CLEANING ===" _newline

********************************************************************************
* 0. SETUP
********************************************************************************

* Policy date: GST zero-rating started June 1, 2025
global policy_date = td(01jun2025)

* Item codes and names
global item_101 "sugar" 
global item_102 "kaukau" 
global item_103 "bananas" 
global item_104 "cooking oil"
global item_105 "rice" 
global item_107 "tinned fish" 
global item_108 "tea"
global item_110 "flour"
global item_111 "aibika"
global item_114 "tinned beef"
global item_115 "sausages"
global item_116 "whole live chicken"
global item_124 "petrol"
global item_125 "phone credit"
global item_126 "tinned baked beans"
global item_127 "powdered milk"
global item_128 "breakfast cereal"
global item_129 "butter"
global item_130 "milo"
global item_131 "noodles"
global item_132 "biscuits"
global item_133 "coffee"
global item_134 "broccoli"
global item_135 "salt"

capture mkdir "${final_e_stores}"

********************************************************************************
* 1. LOAD AND STANDARDIZE FOODPRO DATA
********************************************************************************

display "Loading FoodPro data..."

local foodpro_files: dir "${raw_e_stores}/foodpro" files "*.csv"
local n_foodpro: word count `foodpro_files'

display "  Found `n_foodpro' FoodPro files"

* Create empty dataset with proper structure
clear
gen product_name = ""
gen product_code = ""
gen product_category = ""
gen price = .
gen stock_quantity = .
gen extraction_date = .
format extraction_date %td
gen source = ""
drop if _n > 0

tempfile foodpro_all
save `foodpro_all', replace emptyok

if `n_foodpro' > 0 {
    local counter = 0
    foreach file of local foodpro_files {
        local counter = `counter' + 1
        
        * Extract date from filename
        local has_date = regexm("`file'", "([0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9])")
        local date_str = regexs(1)
        
        if "`date_str'" == "" {
            display as error "  Warning: No date found in filename `file', skipping"
            continue
        }
        
        * Import CSV
        capture import delimited "${raw_e_stores}/foodpro/`file'", clear varnames(1) case(preserve) stringcols(_all)
        
        if _rc != 0 {
            display as error "  Warning: Failed to import `file', skipping"
            continue
        }
        
        if _N == 0 {
            display as error "  Warning: File `file' is empty, skipping"
            continue
        }
        
        * Standardize column names (priority order matters)
        * Price columns
        capture confirm variable price_pgk
        if !_rc {
            rename price_pgk price
        }
        else {
            capture confirm variable price_eur
            if !_rc {
                rename price_eur price
            }
            else {
                capture confirm variable price_val
                if !_rc {
                    rename price_val price
                }
            }
        }
        
        * Other columns
        cap rename prod_name product_name
        cap rename product product_name
        cap rename name product_name
        cap rename cat product_category
        cap rename category product_category
        cap rename qty stock_quantity
        cap rename quantity stock_quantity
        cap rename stock stock_quantity
        cap rename stock_qty stock_quantity
        
        * Ensure all required columns exist
        foreach var in product_name product_code product_category {
            cap confirm variable `var'
            if _rc {
                gen `var' = ""
            }
        }
        
        foreach var in price stock_quantity {
            cap confirm variable `var'
            if _rc {
                gen `var' = .
            }
        }
        
        * Standardize types (handle both string and numeric inputs)
        cap confirm string variable price
        if !_rc {
            gen price_num = real(price)
            drop price
            rename price_num price
        }
        
        cap confirm string variable stock_quantity
        if !_rc {
            gen stock_num = real(stock_quantity)
            drop stock_quantity
            rename stock_num stock_quantity
        }
        
        * Add extraction date (drop first if it exists in the CSV)
        cap drop extraction_date
        gen extraction_date = date("`date_str'", "YMD")
        format extraction_date %td
        
        * Add source (drop first if it exists in the CSV)
        cap drop source
        gen source = "foodpro"
        
        * Keep only standardized columns
        keep product_name product_code product_category price stock_quantity extraction_date source
        
        * Save to tempfile (much faster than repeated append/save)
        tempfile foodpro_`counter'
        quietly save `foodpro_`counter'', replace
        
        if mod(`counter', 10) == 0 {
            display "  Processed `counter'/`n_foodpro' files..."
        }
    }
    
    * Now append all at once (much faster)
    display "  Combining all FoodPro files..."
    use `foodpro_all', clear
    forvalues i = 1/`counter' {
        cap confirm file `foodpro_`i''
        if !_rc {
            quietly append using `foodpro_`i''
        }
    }
    save `foodpro_all', replace
    display "  FoodPro data loaded: " _N " observations"
}
else {
    display "  No FoodPro files found"
}

display "FoodPro data complete" _newline

********************************************************************************
* 2. LOAD AND STANDARDIZE RH DATA
********************************************************************************

display "Loading RH Hypermarkets data..."

local rh_files: dir "${raw_e_stores}/rh" files "*.csv"
local n_rh: word count `rh_files'

display "  Found `n_rh' RH files"

* Create empty dataset with proper structure
clear
gen product_name = ""
gen product_code = ""
gen product_category = ""
gen price = .
gen stock_quantity = .
gen extraction_date = .
format extraction_date %td
gen source = ""
drop if _n > 0

tempfile rh_all
save `rh_all', replace emptyok

if `n_rh' > 0 {
    local counter = 0
    foreach file of local rh_files {
        local counter = `counter' + 1
        
        * Extract date from filename
        local has_date = regexm("`file'", "([0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9])")
        local date_str = regexs(1)
        
        if "`date_str'" == "" {
            display as error "  Warning: No date found in filename `file', skipping"
            continue
        }
        
        * Import CSV
        capture import delimited "${raw_e_stores}/rh/`file'", clear varnames(1) case(preserve) stringcols(_all)
        
        if _rc != 0 {
            display as error "  Warning: Failed to import `file', skipping"
            continue
        }
        
        if _N == 0 {
            display as error "  Warning: File `file' is empty, skipping"
            continue
        }
        
        * Standardize column names (priority order matters)
        * Price columns
        capture confirm variable price_pgk
        if !_rc {
            rename price_pgk price
        }
        else {
            capture confirm variable price_eur
            if !_rc {
                rename price_eur price
            }
            else {
                capture confirm variable price_val
                if !_rc {
                    rename price_val price
                }
            }
        }
        
        * Other columns  
        cap rename prod_name product_name
        cap rename product product_name
        cap rename name product_name
        cap rename cat product_category
        cap rename category product_category
        cap rename qty stock_quantity
        cap rename quantity stock_quantity
        cap rename stock stock_quantity
        cap rename stock_qty stock_quantity
        
        * Ensure all required columns exist
        foreach var in product_name product_code product_category {
            cap confirm variable `var'
            if _rc {
                gen `var' = ""
            }
        }
        
        foreach var in price stock_quantity {
            cap confirm variable `var'
            if _rc {
                gen `var' = .
            }
        }
        
        * Standardize types
        cap confirm string variable price
        if !_rc {
            gen price_num = real(price)
            drop price
            rename price_num price
        }
        
        cap confirm string variable stock_quantity
        if !_rc {
            gen stock_num = real(stock_quantity)
            drop stock_quantity
            rename stock_num stock_quantity
        }
        
        * Add extraction date (drop first if it exists in the CSV)
        cap drop extraction_date
        gen extraction_date = date("`date_str'", "YMD")
        format extraction_date %td
        
        * Add source (drop first if it exists in the CSV)
        cap drop source
        gen source = "rh"
        
        * Keep only standardized columns
        keep product_name product_code product_category price stock_quantity extraction_date source
        
        * Save to tempfile
        tempfile rh_`counter'
        quietly save `rh_`counter'', replace
        
        if mod(`counter', 10) == 0 {
            display "  Processed `counter'/`n_rh' files..."
        }
    }
    
    * Append all at once
    display "  Combining all RH files..."
    use `rh_all', clear
    forvalues i = 1/`counter' {
        cap confirm file `rh_`i''
        if !_rc {
            quietly append using `rh_`i''
        }
    }
    save `rh_all', replace
    display "  RH data loaded: " _N " observations"
}
else {
    display "  No RH files found"
}

display "RH data complete" _newline

********************************************************************************
* 3. MERGE & CLEAN
********************************************************************************

display "Merging and cleaning data..."

use `foodpro_all', clear
quietly append using `rh_all'

if _N == 0 {
    display as error "ERROR: No data loaded from any source"
    exit 2000
}

display "  Total observations after merge: " _N

* Remove exact duplicates
quietly duplicates drop product_name product_code product_category price stock_quantity extraction_date source, force
display "  After removing exact duplicates: " _N

* Drop observations with missing price or date
quietly drop if missing(price) | missing(extraction_date)
display "  After dropping missing price/date: " _N

* Create product identifier
gen product_name_clean = strtrim(stritrim(product_name))
gen product_code_clean = strtrim(stritrim(product_code))
gen prod_id = product_code_clean
replace prod_id = product_name_clean if missing(product_code_clean) | product_code_clean == ""

* Deduplicate by source-product-date (keep first occurrence)
sort source prod_id extraction_date price
quietly bysort source prod_id extraction_date: keep if _n == 1
display "  After deduplicating by source-product-date: " _N _newline

********************************************************************************
* 4. MAP TO STANDARD PRODUCT CODES
********************************************************************************

display "Mapping to standard product codes..."

gen product_name_lower = lower(product_name_clean)
gen product_category_lower = lower(product_category)
gen product = .

* -----------------------------------------------------------------------------
* TREATED ITEMS (GST Zero-Rated)
* -----------------------------------------------------------------------------

* 104: Cooking oil
quietly replace product = 104 if product_category_lower == "oil"
quietly replace product = 104 if regexm(product_name_lower, ///
    "cooking.*oil|vegetable.*oil|palm.*oil|sunflower.*oil|canola.*oil") ///
    & missing(product)

* 105: Rice
quietly replace product = 105 if product_category_lower == "rice"
quietly replace product = 105 if regexm(product_category_lower, "rice-flour|rice-noodles") ///
    & regexm(product_name_lower, "rice") & missing(product)
quietly replace product = 105 if regexm(product_name_lower, ///
    "\\brice\\b|jasmine.*rice|basmati|skel.*rice|trukai.*rice|roots.*rice") ///
    & missing(product)

* 107: Tinned fish
quietly replace product = 107 if product_category_lower == "canned-goods" ///
    & regexm(product_name_lower, "mackerel|tuna|sardine|tinned.*fish|canned.*fish") ///
    & missing(product)
quietly replace product = 107 if regexm(product_name_lower, ///
    "tinned.*fish|canned.*fish|mackerel|\\btuna\\b|sardine|pilchard") ///
    & !regexm(product_name_lower, "sauce|stock") & missing(product)

* 108: Tea
quietly replace product = 108 if product_category_lower == "tea" & missing(product)
quietly replace product = 108 if product_category_lower == "coffee-tea-sugar" ///
    & regexm(product_name_lower, "\\btea\\b|teabag") & missing(product)
quietly replace product = 108 if regexm(product_name_lower, ///
    "\\btea\\b|teabag|tea.*bag|black.*tea|green.*tea") ///
    & !regexm(product_name_lower, "iced.*tea") & missing(product)

* 110: Flour
quietly replace product = 110 if product_category_lower == "flour"
quietly replace product = 110 if regexm(product_category_lower, "rice-flour") ///
    & regexm(product_name_lower, "flour") & missing(product)
quietly replace product = 110 if regexm(product_name_lower, ///
    "\\bflour\\b|plain.*flour|self.*raising|wheat.*flour") & missing(product)

* 114: Tinned beef/meat
quietly replace product = 114 if product_category_lower == "canned-goods" ///
    & regexm(product_name_lower, ///
    "corned.*beef|luncheon.*meat|tulip|ox.*palm|tinned.*meat|tinned.*beef|canned.*meat") ///
    & missing(product)
quietly replace product = 114 if regexm(product_name_lower, ///
    "tinned.*beef|tinned.*meat|canned.*meat|corned.*beef|luncheon.*meat|spam") ///
    & missing(product)

* 116: Chicken
quietly replace product = 116 if inlist(product_category_lower, ///
    "meat-products", "dairy-poultry", "frozen-meat") ///
    & regexm(product_name_lower, "chicken|\\broll\\b") ///
    & !regexm(product_name_lower, "stock|cube|flavou?r|luncheon|beef|pork") & missing(product)
quietly replace product = 116 if regexm(product_name_lower, ///
    "\\bchicken\\b|zenag.*kaikai|chicken.*roll|tablebird|kwik.*kai|mumu.*kakaruk") ///
    & !regexm(product_name_lower, "stock|cube|flavou?r|sauce|noodle") ///
    & missing(product)

* 131: Noodles (instant only)
quietly replace product = 131 if inlist(product_category_lower, ///
    "pasta-noodles", "rice-noodles") ///
    & regexm(product_name_lower, ///
    "indomie|maggi|nongshim|mama|pop.*mie|knorr.*noodle|instant|kakaruk|ramen|ramyun") ///
    & !regexm(product_name_lower, "spaghetti|macaroni|penne|pasta|vermicelli") ///
    & missing(product)
quietly replace product = 131 if regexm(product_name_lower, ///
    "indomie|maggi.*noodle|nongshim|mama.*noodle|pop.*mie|kakaruk|instant.*noodle|ichiban|supermi|snax.*noodle|bowl.*noodle") ///
    & !regexm(product_name_lower, "spaghetti|vermicelli|bean.*thread") ///
    & missing(product)

* 132: Biscuits
quietly replace product = 132 if product_category_lower == "snacks-biscuits" ///
    & regexm(product_name_lower, "biscuit|cracker") ///
    & !regexm(product_name_lower, "chocolate|choc") & missing(product)
quietly replace product = 132 if regexm(product_name_lower, "biscuit|cracker") ///
    & !regexm(product_name_lower, "chocolate|choc") & missing(product)

* 133: Coffee
quietly replace product = 133 if product_category_lower == "coffee-tea-sugar" ///
    & regexm(product_name_lower, "coffee|nescafe|kopiko|niugini.*coffee") ///
    & !regexm(product_name_lower, "coffeemate") & missing(product)
quietly replace product = 133 if regexm(product_name_lower, ///
    "\\bcoffee\\b|nescafe|kopiko|niugini.*coffee|instant.*coffee") ///
    & !regexm(product_name_lower, "coffeemate|creamer") & missing(product)

* -----------------------------------------------------------------------------
* CONTROL ITEMS (Still Subject to GST)
* -----------------------------------------------------------------------------

* 129: Butter (includes margarine)
quietly replace product = 129 if regexm(product_name_lower, "\\bbutter\\b|margarine") ///
    & !regexm(product_name_lower, "peanut.*butter|almond.*butter") ///
    & missing(product)

* 102: Kaukau (sweet potato)
quietly replace product = 102 if regexm(product_name_lower, "kaukau|sweet.*potato") ///
    & missing(product)

* 126: Tinned baked beans
quietly replace product = 126 if product_category_lower == "canned-goods" ///
    & regexm(product_name_lower, "baked.*bean|bean.*tomato") & missing(product)
quietly replace product = 126 if regexm(product_name_lower, ///
    "baked.*bean|tinned.*bean") & missing(product)

* 134: Broccoli
quietly replace product = 134 if regexm(product_name_lower, "broccoli") ///
    & missing(product)

* 101: Sugar
quietly replace product = 101 if product_category_lower == "coffee-tea-sugar" ///
    & regexm(product_name_lower, "sugar") & missing(product)
quietly replace product = 101 if regexm(product_name_lower, ///
    "\\bsugar\\b|caster.*sugar|white.*sugar|brown.*sugar") ///
    & !regexm(product_name_lower, "free|substitute") & missing(product)

* 115: Sausages
quietly replace product = 115 if inlist(product_category_lower, ///
    "meat-products", "processed-meat", "frozen-meat") ///
    & regexm(product_name_lower, "sausage|saveloy") & missing(product)
quietly replace product = 115 if regexm(product_name_lower, ///
    "sausage|saveloy|frankfurter|bratwurst") & missing(product)

* 127: Powdered milk
quietly replace product = 127 if inlist(product_category_lower, ///
    "milk-cereals", "coffee-tea-sugar") ///
    & regexm(product_name_lower, "milk|devondale|sunshine|indomilk") ///
    & missing(product)
quietly replace product = 127 if regexm(product_name_lower, ///
    "powdered.*milk|milk.*powder|instant.*milk|full.*cream.*milk|condensed.*milk|evaporated.*milk") ///
    & missing(product)

* 128: Breakfast cereal
quietly replace product = 128 if product_category_lower == "milk-cereals" ///
    & regexm(product_name_lower, "cereal|corn.*flake|weet.*bix|muesli|oat|granola|carman") ///
    & missing(product)
quietly replace product = 128 if regexm(product_name_lower, ///
    "cereal|corn.*flake|weet.*bix|muesli|porridge|oat.*meal|granola|carman") ///
    & missing(product)

* 103: Bananas
quietly replace product = 103 if regexm(product_name_lower, "banana") ///
    & missing(product)

* 130: Milo
quietly replace product = 130 if regexm(product_name_lower, "milo") ///
    & missing(product)

* Report mapping results
quietly count if !missing(product)
local mapped = r(N)
display "  Products successfully mapped: `mapped' / " _N

* Create product category name for clustering
gen product_category_name = ""
quietly replace product_category_name = "cooking oil" if product == 104
quietly replace product_category_name = "rice" if product == 105
quietly replace product_category_name = "tinned fish" if product == 107
quietly replace product_category_name = "tea" if product == 108
quietly replace product_category_name = "flour" if product == 110
quietly replace product_category_name = "tinned beef" if product == 114
quietly replace product_category_name = "chicken" if product == 116
quietly replace product_category_name = "noodles" if product == 131
quietly replace product_category_name = "biscuits" if product == 132
quietly replace product_category_name = "coffee" if product == 133
quietly replace product_category_name = "sugar" if product == 101
quietly replace product_category_name = "kaukau" if product == 102
quietly replace product_category_name = "bananas" if product == 103
quietly replace product_category_name = "sausages" if product == 115
quietly replace product_category_name = "baked beans" if product == 126
quietly replace product_category_name = "powdered milk" if product == 127
quietly replace product_category_name = "cereal" if product == 128
quietly replace product_category_name = "butter" if product == 129
quietly replace product_category_name = "milo" if product == 130
quietly replace product_category_name = "broccoli" if product == 134

label variable product_category_name "Product category for clustering"

drop product_name_lower product_category_lower

********************************************************************************
* 5. CREATE TREATMENT ASSIGNMENT
********************************************************************************

display "Creating treatment assignment..."

quietly gen treat = .
quietly replace treat = 1 if inlist(product, 104, 105, 107, 108, 110, 114, 116, 131, 132, 133)
quietly replace treat = 0 if inlist(product, 101, 102, 103, 115, 126, 127, 128, 129, 130, 134)

quietly count if treat == 1
display "  Treated products: " r(N)
quietly count if treat == 0
display "  Control products: " r(N)

display "Treatment assignment complete" _newline

********************************************************************************
* 6. FINAL CHECKS AND SUMMARY
********************************************************************************

display "Final data summary:"
display "  Sources:"
quietly count if source == "foodpro"
display "    - FoodPro: " r(N)
quietly count if source == "rh"
display "    - RH: " r(N)
display "  Products: " _N " total observations"
display "  Unique products: "
quietly tab product
display ""

********************************************************************************
* 7. SAVE
********************************************************************************

display "Saving final dataset..."

label variable product_name "Product name"
label variable product_code "Product code (if available)"
label variable product_category "Product category"
label variable price "Price (PGK)"
label variable stock_quantity "Stock quantity"
label variable extraction_date "Scrape/extraction date"
label variable source "Data source (foodpro or rh)"
label variable prod_id "Product identifier"
label variable product "Standard product code (101-135)"
label variable product_category_name "Product category for clustering"
label variable treat "Treatment status (1=treated, 0=control)"

label define treat_lbl 0 "Control" 1 "Treated"
label values treat treat_lbl

label define product_lbl ///
    101 "Sugar" ///
    102 "Kaukau" ///
    103 "Bananas" ///
    104 "Cooking oil" ///
    105 "Rice" ///
    107 "Tinned fish" ///
    108 "Tea" ///
    110 "Flour" ///
    114 "Tinned beef" ///
    115 "Sausages" ///
    116 "Chicken" ///
    126 "Baked beans" ///
    127 "Powdered milk" ///
    128 "Cereal" ///
    129 "Butter" ///
    130 "Milo" ///
    131 "Noodles" ///
    132 "Biscuits" ///
    133 "Coffee" ///
    134 "Broccoli"
    
label values product product_lbl

order source product product_category_name treat prod_id extraction_date price stock_quantity product_name product_code product_category
sort source product prod_id extraction_date

save "${final_e_stores}/combined_cleaned_data.dta", replace
export delimited "${final_e_stores}/combined_cleaned_data.csv", replace

display "Dataset saved: combined_cleaned_data.dta" _newline
display as text "=== SCRIPT COMPLETED SUCCESSFULLY ===" _newline

********************************************************************************
* END
********************************************************************************
