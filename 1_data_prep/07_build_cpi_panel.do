/*==============================================================================
 07_build_cpi_panel.do
 VAT exemption pass-through and incidence (Papua New Guinea) — data preparation

 PURPOSE : Import NSO CPI Table 13 from raw Excel and construct an item × quarter
           price-index panel with treatment, comparable-food, and DiD indicators.
 INPUTS  : ${raw_nso}/Table_13_December_Qtr_2025.xlsx  (sheet "Table 13")
 OUTPUTS : ${final_nso}/cpi_quarterly_panel.dta  (built from NSO Table 13; now
           wired into main.do)
 DEPENDS : none (reads Raw/ NSO Table 13)
 CALLED BY: main.do

 STRUCTURE:
   - 39 items (10 treatment + 28 comparable food + 1 All CPI) × 15 quarters
   - Sample restricted to June Quarter 2022 – December Quarter 2025
   - Treatment date: March Quarter 2025
==============================================================================*/

clear
set more off

* ══════════════════════════════════════════════════════════════════════════════
* STEP 1: Import raw Excel
* ══════════════════════════════════════════════════════════════════════════════

* Import full sheet as strings to avoid type mismatches
import excel using "${raw_nso}/Table_13_December_Qtr_2025.xlsx", ///
    sheet("Table 13") allstring clear

* Row number = Excel row number (obs 1 = row 1 of spreadsheet)
gen excel_row = _n

* ══════════════════════════════════════════════════════════════════════════════
* STEP 2: Keep only items of interest
* ══════════════════════════════════════════════════════════════════════════════

* Treatment group (10 items — yellow-highlighted VAT-exempt):
*   Row  9: Biscuits
*   Row 13: Flour
*   Row 14: Rice
*   Row 15: Pasta
*   Row 19: Chicken
*   Row 23: Tinned Meat
*   Row 27: Tinned Fish
*   Row 39: Cooking Oil
*   Row 56: Instant Coffee
*   Row 58: Tea-Bags

* Comparable food items (28 items — non-exempt food sub-items):
*   Row 10: Bread              Row 32: Cheese
*   Row 12: Breakfast Cereal   Row 33: Fresh and Flavoured Milk
*   Row 16: Chips              Row 34: Powdered Milk
*   Row 18: Beef               Row 35: Condensed Milk
*   Row 20: Lamb               Row 37: Eggs
*   Row 21: Pork               Row 40: Butter and Margarine
*   Row 22: Sausages           Row 41: Peanut Butter
*   Row 24: Tinned Curried Ch. Row 44: Jam
*   Row 26: Frozen Fish        Row 45: Sugarcane
*   Row 29: Fruits             Row 46: Sugar
*   Row 30: Vegetables         Row 47: Chocolate, Candy & Chewing Gum
*   Row 48: Ice-cream          Row 50: Tomato and Soy Sauce
*   Row 51: Tomato & Chk Soup  Row 57: Milo
*   Row 59: Juice Drinks       Row 60: Soft Drink

* All Groups CPI (1 series):
*   Row  5: All Groups

keep if inlist(excel_row, 5, 9, 10, 12, 13, 14, 15, 16, 18, 19) | ///
        inlist(excel_row, 20, 21, 22, 23, 24, 26, 27, 29, 30, 32) | ///
        inlist(excel_row, 33, 34, 35, 37, 39, 40, 41, 44, 45, 46) | ///
        inlist(excel_row, 47, 48, 50, 51, 56, 57, 58, 59, 60)

di as res "  Kept " as txt _N " items"

* ══════════════════════════════════════════════════════════════════════════════
* STEP 3: Rename variables
* ══════════════════════════════════════════════════════════════════════════════

* Column A = item names
rename A item_name
replace item_name = strtrim(stritrim(item_name))

* Columns B–BD = 55 quarterly price indices (Jun 2012 – Dec 2025)
* Stata auto-names imported columns: A, B, ..., Z, AA, ..., AZ, BA, ..., BD
local colnames B C D E F G H I J K L M N O P Q R S T U V W X Y Z ///
              AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ  ///
              AR AS AT AU AV AW AX AY AZ BA BB BC BD
local i = 1
foreach v of local colnames {
    cap rename `v' q`i'
    local ++i
}

* ══════════════════════════════════════════════════════════════════════════════
* STEP 4: Destring price indices
* ══════════════════════════════════════════════════════════════════════════════

destring q1-q55, replace force

* ══════════════════════════════════════════════════════════════════════════════
* STEP 5: Create group indicators (before reshape, while rows are identifiable)
* ══════════════════════════════════════════════════════════════════════════════

* Treatment group
gen treatment = inlist(excel_row, 9, 13, 14, 15, 19, 23, 27, 39, 56, 58)

* Curated comparable subset (6 of the 28 comparable items)
gen curated_ctrl = inlist(excel_row, 12, 22, 34, 40, 46, 57)

* All Groups CPI
gen allcpi = (excel_row == 5)

* Use excel_row as stable item identifier
rename excel_row item_id

* ══════════════════════════════════════════════════════════════════════════════
* STEP 6: Reshape wide → long
* ══════════════════════════════════════════════════════════════════════════════

reshape long q, i(item_id item_name treatment curated_ctrl allcpi) j(quarter)
rename q price_index

* Drop missing values (quarters with no data)
drop if price_index == .

* ══════════════════════════════════════════════════════════════════════════════
* STEP 7: Create time variables
* ══════════════════════════════════════════════════════════════════════════════

* Quarterly date (base = Jun 2012 = 2012q2 = quarter 1)
gen qdate = tq(2012q2) + quarter - 1
format qdate %tq
label variable qdate "Quarter"

* Post-treatment indicator
* March 2025 = quarter 52 (last pre-treatment). Post = quarters 53–55.
gen post = (quarter > 52)
label variable post "Post March 2025"
label define post_lbl 0 "Pre (Jun 2012 – Mar 2025)" 1 "Post (Jun – Dec 2025)"
label values post post_lbl

* DiD interaction
gen did = treatment * post
label variable did "Treatment x Post (DiD)"

* ══════════════════════════════════════════════════════════════════════════════
* STEP 8: Labels and panel declaration
* ══════════════════════════════════════════════════════════════════════════════

label variable price_index  "Price Index (Jun 2012 = 100)"
label variable treatment    "Treatment group (VAT-exempt items)"
label variable curated_ctrl "Curated comparable item"
label variable allcpi       "All Groups CPI"
label variable item_name    "Item name"
label variable item_id      "Item identifier (Excel row)"

tsset item_id qdate

* ══════════════════════════════════════════════════════════════════════════════
* STEP 9: Save and summarise
* ══════════════════════════════════════════════════════════════════════════════

compress
save "${final_nso}/cpi_quarterly_panel.dta", replace

* ── Verification ──────────────────────────────────────────────────────────────
di _n as txt _dup(72) "-"
di as res "  Panel constructed: " as txt _N " observations"
di as txt _dup(72) "-"

di _n as res "  Group counts (items):"
preserve
collapse (first) treatment curated_ctrl allcpi, by(item_id item_name)
count if treatment == 1
di as txt "    Treatment:           " as res r(N) " items"
count if treatment == 0 & allcpi == 0
di as txt "    Comparable food:     " as res r(N) " items"
count if curated_ctrl == 1
di as txt "      of which curated:  " as res r(N) " items"
count if allcpi == 1
di as txt "    All Groups CPI:      " as res r(N) " series"
restore

di _n as res "  Time coverage:"
tab post, nolabel
