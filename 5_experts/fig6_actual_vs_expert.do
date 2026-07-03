/*==============================================================================
 fig6_actual_vs_expert.do
 VAT exemption pass-through and incidence (Papua New Guinea) — analysis

 PURPOSE : Figure 6 — share of foregone revenue by income quintile plus a
           formal-stores group, actual incidence vs expert prediction, with 95%
           CIs. Actual shares A1..A5 = 100 * RFP * bF_q / sum_q bF_q (bF_q =
           quintile benefit under Table 5 pass-through), CIs from a
           household-cluster bootstrap (B=500, percentile); actual formal-stores
           bar = 100 - sum(A), fixed by pass-through (no CI). Expert shares =
           PT * income_q / sum_q income_q, PT = mean of prices_1..prices_4;
           expert formal-stores = 100 - PT, CIs across experts.
 INPUTS  : ${raw_phone}/20260429/PNG_HFPS_Household_weighted_wFood.dta (actual;
           same extract that produced the published figure, see the Table 2 note);
           ${final_experts}/experts_survey_processed.dta (expert); globals
           ${dir_graphs}, ${dir_tables}, colors ${my_blue}, ${my_green}
 OUTPUTS : ${dir_graphs}/figure6.png; ${dir_tables}/figure6_values.csv
 DEPENDS : experts_survey_processed.dta, written by
           figsA23_A33_experts_survey.do, which must run FIRST; and the phone
           extract above. Hardcoded pass-through fractions are from Table 5.
 CALLED BY: main.do
==============================================================================*/

set more off
version 16

*--- project palette (mirrors 01_globals.do; redefined so the file runs alone) ---
global my_blue  "20 97 128"
global my_green "0 166 118"

*--- standalone fallbacks (no effect when run from main.do) ---------------------
if "${dir_graphs}" == "" global dir_graphs "."
if "${dir_tables}" == "" global dir_tables "."

global PT_UF = 7.7/9.1
global PT_UI = 0.2/9.1
global PT_RF = 2.2/9.1
global PT_RI = 1.0/9.1
global RFP   = 5.80/9.1
local EXEMPT 104 105 107 108 110 116 131 132

*==================== PART A: ACTUAL quintile shares + bootstrap CIs =============
local HFPS "${raw_phone}/20260429/PNG_HFPS_Household_weighted_wFood.dta"
use year month weight_hh s5_total_inc_decile urbrur hhid_full s4q5* s4q2* using "`HFPS'", clear
gen mdate = ym(year, month)
keep if inrange(mdate, ym(2023,10), ym(2026,5))
keep if !missing(weight_hh) & weight_hh > 0
keep if !missing(s5_total_inc_decile)
gen quintile = ceil(s5_total_inc_decile/2)
keep if inlist(quintile,1,2,3,4,5)
gen double w = weight_hh
gen byte urban = (urbrur==1)
gen double ef = 0
gen double ei = 0
foreach c of local EXEMPT {
    gen double sp = s4q5`c'
    replace sp = 0 if missing(sp) | sp < 0
    replace ef = ef + sp if s4q2`c'==2
    replace ei = ei + sp if s4q2`c'!=2
    drop sp
}
gen double e_uf = ef*(urban==1)
gen double e_ui = ei*(urban==1)
gen double e_rf = ef*(urban==0)
gen double e_ri = ei*(urban==0)
egen long hhid_num = group(hhid_full)

* point estimates A1..A5
scalar TF = 0
forvalues q=1/5 {
    foreach v in e_uf e_ui e_rf e_ri {
        quietly summ `v' [aw=w] if quintile==`q', meanonly
        scalar m_`v'_`q' = r(mean)
    }
    scalar bF`q' = m_e_uf_`q'*${PT_UF} + m_e_ui_`q'*${PT_UI} + m_e_rf_`q'*${PT_RF} + m_e_ri_`q'*${PT_RI}
    scalar TF = TF + bF`q'
}
forvalues q=1/5 {
    scalar A`q' = 100*${RFP}*bF`q'/TF
}
scalar stores_a = 100 - (A1+A2+A3+A4+A5)   // fixed by pass-through -> no CI

* program returning the five quintile shares, for the household-cluster bootstrap
capture program drop _f6actual
program define _f6actual, rclass
    scalar TFb = 0
    forvalues q=1/5 {
        foreach v in e_uf e_ui e_rf e_ri {
            quietly summ `v' [aw=w] if quintile==`q', meanonly
            scalar mb_`v'_`q' = r(mean)
        }
        scalar bFb`q' = mb_e_uf_`q'*${PT_UF} + mb_e_ui_`q'*${PT_UI} + mb_e_rf_`q'*${PT_RF} + mb_e_ri_`q'*${PT_RI}
        scalar TFb = TFb + bFb`q'
    }
    forvalues q=1/5 {
        return scalar A`q' = 100*${RFP}*bFb`q'/TFb
    }
end

tempfile boot
set seed 20260626
bootstrap A1=r(A1) A2=r(A2) A3=r(A3) A4=r(A4) A5=r(A5), ///
    reps(500) cluster(hhid_num) nowarn nodots saving("`boot'", replace): _f6actual

* percentile 95% CIs from the saved replicates
preserve
use "`boot'", clear
capture confirm variable A1
if _rc {
    forvalues q=1/5 {
        capture rename _bs_`q' A`q'
    }
}
forvalues q=1/5 {
    _pctile A`q', p(2.5 97.5)
    scalar A`q'_lo = r(r1)
    scalar A`q'_hi = r(r2)
}
restore

*==================== PART B: EXPERT shares + across-expert CIs =================
local EXP "${final_experts}/experts_survey_processed.dta"
use "`EXP'", clear
foreach v in income_1 income_2 income_3 income_4 income_5 prices_1 prices_2 prices_3 prices_4 {
    capture confirm numeric variable `v'
    if _rc destring `v', replace force
}
egen double PT     = rowmean(prices_1 prices_2 prices_3 prices_4)
egen double incsum = rowtotal(income_1 income_2 income_3 income_4 income_5)
keep if incsum > 0 & !missing(PT)
forvalues q=1/5 {
    gen double qshare`q' = PT*income_`q'/incsum
    quietly summ qshare`q'
    scalar E`q'    = r(mean)
    scalar E`q'_lo = r(mean) - 1.96*r(sd)/sqrt(r(N))
    scalar E`q'_hi = r(mean) + 1.96*r(sd)/sqrt(r(N))
}
gen double storeshare = 100 - PT
quietly summ storeshare
scalar stores_e    = r(mean)
scalar stores_e_lo = r(mean) - 1.96*r(sd)/sqrt(r(N))
scalar stores_e_hi = r(mean) + 1.96*r(sd)/sqrt(r(N))

*==================== PART C: plotting dataset + grouped bars w/ CIs ============
clear
set obs 6
gen byte cat = _n                  // 1..5 = Q1..Q5 ; 6 = formal stores
gen double actual = .
gen double a_lo = .
gen double a_hi = .
gen double expert = .
gen double e_lo = .
gen double e_hi = .
forvalues q=1/5 {
    replace actual = A`q'    if cat==`q'
    replace a_lo   = A`q'_lo if cat==`q'
    replace a_hi   = A`q'_hi if cat==`q'
    replace expert = E`q'    if cat==`q'
    replace e_lo   = E`q'_lo if cat==`q'
    replace e_hi   = E`q'_hi if cat==`q'
}
replace actual = stores_a    if cat==6     // a_lo/a_hi stay missing -> no error bar
replace expert = stores_e    if cat==6
replace e_lo   = stores_e_lo if cat==6
replace e_hi   = stores_e_hi if cat==6

gen double x_a = cat - 0.205               // grouped offsets
gen double x_e = cat + 0.205

twoway (bar actual x_a, barwidth(0.40) fcolor("$my_blue") lcolor(white)) (bar expert x_e, barwidth(0.40) fcolor("$my_green") lcolor(white)) (rcap a_hi a_lo x_a, lcolor(black) msize(small)) (rcap e_hi e_lo x_e, lcolor(black) msize(small)), legend(order(1 "Actual" 2 "Expert prediction") rows(1) pos(6) region(lcolor(none))) ytitle("Share of foregone revenue (%)", size(small)) ylabel(0(10)60, nogrid angle(0) labsize(small)) xtitle("") xlabel(1 "Q1" 2 "Q2" 3 "Q3" 4 "Q4" 5 "Q5" 6 "Formal stores", noticks labsize(small)) xline(5.5, lpattern(dot) lcolor(gs12)) title("") graphregion(color(white)) plotregion(color(white)) name(figure6, replace)
graph export "${dir_graphs}/figure6.png", replace width(2400)

label define catlbl 1 "Q1" 2 "Q2" 3 "Q3" 4 "Q4" 5 "Q5" 6 "Formal stores"
label values cat catlbl
decode cat, gen(category)
order category actual a_lo a_hi expert e_lo e_hi
export delimited category actual a_lo a_hi expert e_lo e_hi using "${dir_tables}/figure6_values.csv", replace

*===============================================================================
* End
*===============================================================================
