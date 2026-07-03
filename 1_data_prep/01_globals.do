/*==============================================================================
 01_globals.do
 VAT exemption pass-through and incidence (Papua New Guinea) — data preparation

 PURPOSE : Configuration only. Defines project-wide globals (settings, paths),
           food/product item definitions, graph color schemes, and variable
           and geographic labels used across the data-prep scripts.
 CALLED BY: main.do

 CONTENTS:
   1. Project Settings & Paths
   2. Food & Product Item Definitions
   3. Color Schemes for Graphs
   4. Panel Variable Labels
   5. Expert Survey Variable Labels
   6. Geographic Labels (Census/Survey Codes)
==============================================================================*/

set more off
set varabbrev off
set linesize 255

********************************************************************************
* SECTION 1: PROJECT SETTINGS & PATHS
********************************************************************************

display as text "{hline 80}"
display as text "Loading Master Globals File"
display as text "Date: `c(current_date)' at `c(current_time)'"
display as text "User: `c(username)'"
display as text "{hline 80}"

* Date formats
global date_fmt = "%tdDD/NN/CCYY"

* Significance levels for tables
global sig_levels = "* 0.10 ** 0.05 *** 0.01"

* Regression options (examples - adjust as needed)
global reg_opts = "absorb(district month) vce(cluster district)"

* Event study window (if applicable)
global event_pre  = -12  // months before event
global event_post = 12   // months after event

* Number format for tables
global num_fmt = "%9.3f"

* Graph scheme
set scheme s2color

********************************************************************************
* SECTION 2: FOOD & PRODUCT ITEM DEFINITIONS
********************************************************************************

display as text _newline "Loading food & product item definitions..."

* Food items with descriptions (for display)
global good_101 "sugar (per 1 kg)" 
global good_102 "kaukau (sweet potato) (per 1 piece)" 
global good_103 "bananas (per 1 bundle/bunch)" 
global good_104 "cooking oil (per 100 mililitres)"
global good_105 "rice (per 1 kg)" 
global good_107 "tinned fish (per 100 grams)" 
global good_108 "tea (per 1 bag)"
global good_110 "flour (per 1 kg)"
global good_111 "aibika (per 1 bundle/bunch)"
global good_114 "tinned beef (per 100 grms)"
global good_115 "sausages (per 1 piece)"
global good_116 "whole live chicken (per unit)"
global good_124 "petrol (per 1 liter)"
global good_125 "phone credit (per 1 kina)"
global good_126 "tinned baked beans"
global good_127 "powdered milk"
global good_128 "breakfast cereal"
global good_129 "butter"
global good_130 "milo"
global good_131 "noodles"
global good_132 "biscuits"
global good_133 "coffee"
global good_134 "broccoli"
global good_135 "salt"

* Food items (short names for variables)
global food_101 "sugar"
global food_102 "kaukau"
global food_103 "bananas"
global food_104 "cooking_oil"
global food_105 "rice"
global food_107 "tinned_fish"
global food_108 "tea"
global food_110 "flour"
global food_111 "aibika"
global food_114 "tinned_beef"
global food_115 "sausages"
global food_116 "whole_live_chicken"
global food_124 "petrol"
global food_125 "phone_credit"
global food_126 "tinned_baked_beans"
global food_127 "powdered_milk"
global food_128 "breakfast_cereal"
global food_129 "butter"
global food_130 "milo"
global food_131 "noodles"
global food_132 "biscuits"
global food_133 "coffee"
global food_134 "broccoli"
global food_135 "salt"

* Item codes (for referencing)
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

********************************************************************************
* SECTION 3: COLOR SCHEMES FOR GRAPHS
********************************************************************************

display as text "Loading color schemes..."

* Project color palette (RGB values)
global my_blue "20 97 128"
global my_red "150 39 23"
global my_green "0 166 118"
global my_orange "237 106 90"
global my_purple "93 87 107"

* Additional color definitions for different graph types
global color_treated   = "navy"
global color_control   = "maroon"
global color_neutral   = "gs8"
