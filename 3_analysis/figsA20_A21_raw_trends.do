/*==============================================================================
 figsA20_A21_raw_trends.do
 VAT exemption pass-through and incidence (Papua New Guinea) — analysis

 PURPOSE : Plot raw relative-price trends (May 2025 = 1) prior to the event
           studies. Figure A20: treatment vs control for group=fair, always-
           available, weighted. Figure A21: treatment group only, split by store
           type (formal vs informal).
 INPUTS  : ${final_phone}/product_prices_panel.dta;
           ${dir_do}/1_data_prep/01_globals.do (color/palette globals)
 OUTPUTS : $dir_graphs/figure_a20.png; $dir_graphs/figure_a21.png
 DEPENDS : run from main.do after data prep (product_prices_panel built upstream)
 CALLED BY: main.do
==============================================================================*/

********************************************************************************
* Overall raw trends
********************************************************************************

* Labels for graph later
foreach group in all good fair good_nobanana {
	local `group'_label "only `group'"
	if "`group'" == "fair" {
		local `group'_label "only good and fair"
	}
	
}


foreach group in fair { // narrowed to paper spec: Figure A20 uses group=fair
foreach items_availability in always { // narrowed to paper spec: "always" series
foreach weight_type in weight { // narrowed to paper spec: weighted

* Trick 
*local group all
*local items_availability always_and_recent
*local weight_type weight

* Load dataset
use "${final_phone}/product_prices_panel.dta", clear  

do "${dir_do}/1_data_prep/01_globals.do"

* Create treatment/control group category
drop treat 
gen treat = treat_`group'

if "`items_availability'" == "always" {
	// Keep only items for which we have long time series (exclude recently available items)
	keep if always_available == 1 
}

* Collapse by product and time	
collapse (mean) mean_price_w1 = price_w1 mean_price_w5 = price_w5 treat (median) median_price_w1 = price_w1 median_price_w5 = price_w5 ///
		 (sd) sd_price_w1 = price_w1 sd_price_w5 = price_w5 (count) n_w1 = price_w1 n_w5 = price_w5 , by(month_year product)
		
* Keep only treat / control items 	
drop if treat == . | month_year == .
		 
*Trick
local win_level = 5	

* Generate standard error of average prices 
gen se_price_w`win_level' = sd_price_w`win_level' / sqrt(n_w`win_level')
drop sd_*
		
* Generate relative prices (May 2025 = 1)
egen mean_price_may25_w`win_level' = mean(cond(month_year == 23, mean_price_w`win_level', .)) , by(product)
egen median_price_may25_w`win_level' = mean(cond(month_year == 23, median_price_w`win_level', .)) , by(product)
	
gen r_mean_price_w`win_level' = mean_price_w`win_level' / mean_price_may25_w`win_level'
gen r_median_price_w`win_level' = median_price_w`win_level' / median_price_may25_w`win_level'
gen r_se_price_w`win_level' = se_price_w`win_level' / mean_price_may25_w`win_level'

* Create local with weights to collapse using weight/no_weight
if "`weight_type'" == "weight" {
	local weights [aw = n_w`win_level']
} 
if "`weight_type'" == "noweight" {
	local weights
} 
		
* Collapse so we get price series by treatment group over time
collapse (mean) r_mean_price_w`win_level' n_w`win_level' `weights' , by(month_year treat)	
drop if treat == .

* Convert to Stata monthly date
gen stata_month = tm(2023m7) + month_year - 1
format stata_month %tm

* Guard: drop out-of-range month codes so a stray value cannot stretch the
* x-axis (valid waves run through month_year 36 = Jun 2026; see 02_build_phone_panel.do)
drop if month_year < 1 | month_year > 36

* Calculate N values
quietly sum n_w`win_level' if treat == 1
local n_treat = string(r(mean), "%9.0fc")
quietly sum n_w`win_level' if treat == 0
local n_control = string(r(mean), "%9.0fc")

* Get last y-values for label positioning
qui sum stata_month
local last_month = r(max)

qui sum r_mean_price_w`win_level' if treat == 1 & stata_month == `last_month'
local y_treat = r(mean)

qui sum r_mean_price_w`win_level' if treat == 0 & stata_month == `last_month'
local y_control = r(mean)

* Add offset if labels would overlap (within 0.08 of each other)
local offset = 0.02
if abs(`y_treat' - `y_control') < 0.02 {
    if `y_treat' > `y_control' {
        local y_treat = `y_treat' + `offset'
        local y_control = `y_control' - `offset'
    }
    else {
        local y_treat = `y_treat' - `offset'
        local y_control = `y_control' + `offset'
    }
}

* Locals for positioning
local ref_month = tm(2025m5) + 0.5
local text_x_1 = `last_month' + 2
local xmin = tm(2023m10)
local xmax = `last_month' + 5
local xlab_min = tm(2023m12)
local xlab_max = `last_month'
local vat_text = tm(2025m6)

* Graph
twoway (scatter r_mean_price_w`win_level' stata_month if treat == 1, ///
        connect(l) msize(medium) mlcolor("$my_blue") mfcolor("$my_blue*0.5") ///
        lwidth(medthick) lcolor("$my_blue")) ///
       (scatter r_mean_price_w`win_level' stata_month if treat == 0, ///
        connect(l) msize(medium) mlcolor("$my_red") mfcolor("$my_red*0.5") ///
        lwidth(medthick) lcolor("$my_red")), ///
    xtitle("") ytitle("") caption("Price (May 2025 = 1)", pos(11)) ///
    xlabel(`xlab_min'(3)`xlab_max', angle(45) nogrid format(%tmMon_YY)) ///
    ylabel(0.8(0.1)1.2, nogrid format(%6.2f)) ///
    xscale(range(`xmin' `xmax')) ///
    xline(`ref_month', lpattern(dash) lcolor(gs6)) ///
    text(`y_control' `text_x_1' "Control", color("$my_red")) ///
    text(`y_treat' `text_x_1' "Treatment", color("$my_blue")) ///
    text(1.18 `vat_text' "VAT exemptions", color(gs6) box bcolor(white) lcolor(gs6)) ///
    legend(off) ///
    graphregion(color(white) margin(l=2 r=3 t=1 b=0))
	
* Export graph (Figure A20)
graph export "$dir_graphs/figure_a20.png" , replace

} // loop over whether we include item weights by number of observations ends (3)
} // loop over we keep only items for which we have long time series only or not ends (2) 
} // loop over criteria to define treatment and control groups (good and fair) ends (1)


* -----------------------------------------------------------------------------*
* Raw trends – treatment group only, by store type (Formal vs Informal), w5
* -----------------------------------------------------------------------------*
do "${dir_do}/1_data_prep/01_globals.do"

local group              good
local win_level          5
local items_availability always_and_recent
local weight_type        weight

* Load
use "${final_phone}/product_prices_panel.dta", clear

* Treatment group (good items)
keep if treat_`group' == 1
drop if month_year == . | formal_store == .

if "`items_availability'" == "always" {
    keep if always_available == 1
}

* Collapse to product-month-store type
collapse (mean) mean_price_w`win_level' = price_w`win_level' ///
         (sd)   sd_price_w`win_level'   = price_w`win_level' ///
         (count) n_w`win_level'         = price_w`win_level', ///
         by(month_year product formal_store)

drop if n_w`win_level' == . | month_year == .

* Relative prices (May 2025 = 1)
egen base_may25 = mean(cond(month_year==23, mean_price_w`win_level', .)), by(product formal_store)
gen  r_mean_price_w`win_level' = mean_price_w`win_level' / base_may25

* Weights
if "`weight_type'" == "weight" {
    local weights [aw = n_w`win_level']
}
else local weights

* Collapse to month-store type series
collapse (mean) r_mean_price_w`win_level' n_w`win_level' `weights', by(month_year formal_store)

* Date
gen stata_month = tm(2023m7) + month_year - 1
format stata_month %tm

* Guard: drop out-of-range month codes so a stray value cannot stretch the
* x-axis (valid waves run through month_year 36 = Jun 2026; see 02_build_phone_panel.do)
drop if month_year < 1 | month_year > 36

* Avg N labels
quietly sum n_w`win_level' if formal_store==1
local n_formal = string(r(mean), "%9.0fc")
quietly sum n_w`win_level' if formal_store==0
local n_informal = string(r(mean), "%9.0fc")

* Positioning
quietly sum stata_month
local last_month = r(max)

quietly sum r_mean_price_w`win_level' if formal_store==1 & stata_month==`last_month'
local y_formal = r(mean)
quietly sum r_mean_price_w`win_level' if formal_store==0 & stata_month==`last_month'
local y_informal = r(mean)

* Add offset if labels overlap
local offset = 0.03
if abs(`y_formal' - `y_informal') < 0.03 {
    if `y_formal' > `y_informal' {
        local y_formal = `y_formal' + `offset'
        local y_informal = `y_informal' - `offset'
    }
    else {
        local y_formal = `y_formal' - `offset'
        local y_informal = `y_informal' + `offset'
    }
}

local ref_month = tm(2025m5) + 0.5
local text_x_1  = `last_month' + 2
local xmin      = tm(2023m10)
local xmax      = `last_month' + 5
local xlab_min  = tm(2023m12)
local xlab_max  = `last_month'
local vat_text  = tm(2025m6)

* Graph
twoway ///
    (scatter r_mean_price_w`win_level' stata_month if formal_store==1, ///
        connect(l) msize(medium) mlcolor("$my_blue") mfcolor("$my_blue*0.5") ///
        lwidth(medthick) lcolor("$my_blue")) ///
    (scatter r_mean_price_w`win_level' stata_month if formal_store==0, ///
        connect(l) msize(medium) mlcolor("$my_red") mfcolor("$my_red*0.5") ///
        lwidth(medthick) lcolor("$my_red")), ///
    xtitle("") ytitle("") caption("Price (May 2025 = 1)", pos(11)) ///
    xlabel(`xlab_min'(3)`xlab_max', angle(45) nogrid format(%tmMon_YY)) ///
    ylabel(0.8(0.1)1.2, nogrid format(%6.2f)) ///
    xscale(range(`xmin' `xmax')) ///
    xline(`ref_month', lpattern(dash) lcolor(gs6)) ///
    text(`y_formal' `text_x_1' "Treatment" "Formal", color("$my_blue")) ///
    text(`y_informal' `text_x_1' "Treatment" "Informal", color("$my_red")) ///
    text(1.18 `vat_text' "VAT exemptions", color(gs6) box bcolor(white) lcolor(gs6)) ///
    legend(off) ///
    graphregion(color(white) margin(l=2 r=3 t=1 b=0))

graph export "$dir_graphs/figure_a21.png", replace
