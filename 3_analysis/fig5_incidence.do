/*==============================================================================
 fig5_incidence.do
 VAT exemption pass-through and incidence (Papua New Guinea) — analysis

 PURPOSE : Figure 5 — incidence of the VAT exemptions and decomposition of
           regressivity, from HFPS phone-survey microdata, using the survey's
           income decile (s5_total_inc_decile) to form expenditure quintiles.
 INPUTS  : ${raw_phone}/20260429/PNG_HFPS_Household_weighted_wFood.dta (use the
           same extract that produced the published figure; see the Table 2 note);
           globals ${dir_graphs}, ${dir_tables}
 OUTPUTS : ${dir_graphs}/figure5a.png, figure5b.png;
           ${dir_tables}/figure5_incidence_decile_values.csv
 DEPENDS : ${raw_phone}/20260429/PNG_HFPS_Household_weighted_wFood.dta must exist
 CALLED BY: main.do

 Note: hardcoded pass-through fractions below are taken from the paper's Table 5.
==============================================================================*/

*===============================================================================
* Method
*   - Quintiles: ceil(s5_total_inc_decile/2), at the household-wave level. A
*     validation block confirms these reproduce the Figure A2 expenditure totals.
*   - Average exempt-item expenditure per quintile is split by store formality
*     (supermarket s4q2==2 = formal) and location (urbrur==1 = urban).
*   - Pass-through from Table 5, as a fraction of full pass-through (9.1pp):
*       urban formal 7.7/9.1, urban informal 0.2/9.1,
*       rural formal 2.2/9.1, rural informal 1.0/9.1   (location = competition proxy)
*   - Panel (a): VAT is collected only at formal stores, so the foregone-revenue
*     base is formal-store expenditure; bars therefore sum to the formal-store
*     pass-through (5.80/9.1 = 64%, Table 5 col. 2) and are distributed across
*     quintiles by total consumer benefit (households also benefit at informal
*     stores). [To distribute by formal-store benefit only, see the note at *(A)*.]
*   - Panel (b): consumer-side incidence (shares of total benefit) as deviations
*     from an equal 20% per-quintile share, decomposed:
*        blue  = consumption patterns only (uniform pass-through)
*        green = + pass-through heterogeneity by formality
*        red   = + heterogeneity by location/competition
*   - 95% CIs from a household-cluster bootstrap (pass-through held fixed).
*
* Note: the vat_wedge (=0.10/1.10) is omitted because it cancels from every share
* and from the panel-(a) ratio; it changes no reported number.
*
* Output: ${dir_graphs}/figure5a.{png,pdf}, ${dir_graphs}/figure5b.{png,pdf}
*         ${dir_tables}/figure5_incidence_decile_values.csv
*===============================================================================

set more off
version 16
set seed 20260626

*--- project palette (mirrors 01_globals.do; redefined so the file runs alone) ---
global my_blue  "20 97 128"
global my_green "0 166 118"
global my_red   "150 39 23"

*--- input -----------------------------------------------------------------
local DTA "${raw_phone}/20260429/PNG_HFPS_Household_weighted_wFood.dta"
local B   = 500          // bootstrap replications

*--- items ---------------------------------------------------------------------
local exempt   104 105 107 108 110 116 131 132
local allitems 101 102 103 104 105 107 108 110 111 114 115 116 124 125 ///
               126 127 128 129 130 131 132 133 134 135 136 137

*--- pass-through (Table 5), fraction of full pass-through (9.1pp) --------------
local FULL          = 9.1
local pt_uf         = 7.7/`FULL'
local pt_ui         = 0.2/`FULL'
local pt_rf         = 2.2/`FULL'
local pt_ri         = 1.0/`FULL'
local r_formal_pool = 5.80/`FULL'    // Table 5 col.2 pooled formal PT (~64%) = panel (a) total

*===============================================================================
* 1. Load once and build household-wave aggregates
*===============================================================================
use "`DTA'", clear

gen mdate = ym(year, month)
keep if inrange(mdate, ym(2023,10), ym(2026,5))
keep if !missing(weight_hh) & weight_hh > 0
keep if !missing(s5_total_inc_decile)

gen byte quintile = ceil(s5_total_inc_decile/2)
keep if inrange(quintile,1,5)

gen double w     = weight_hh
gen byte   urban = (urbrur==1)

* exempt-item spend split by store formality
gen double exempt_formal   = 0
gen double exempt_informal = 0
foreach c of local exempt {
    gen double sp = s4q5`c'
    replace    sp = 0 if missing(sp) | sp < 0
    replace exempt_formal   = exempt_formal   + sp if s4q2`c'==2
    replace exempt_informal = exempt_informal + sp if s4q2`c'!=2
    drop sp
}
gen double exempt = exempt_formal + exempt_informal
gen double exp_uf = cond(urban==1, exempt_formal,   0)
gen double exp_ui = cond(urban==1, exempt_informal, 0)
gen double exp_rf = cond(urban==0, exempt_formal,   0)
gen double exp_ri = cond(urban==0, exempt_informal, 0)

* full surveyed basket (for the Figure A2 validation only)
* (skip item codes not present in this extract, e.g. 136/137)
gen double basket = 0
foreach c of local allitems {
    capture confirm variable s4q5`c'
    if _rc continue
    gen double sp = s4q5`c'
    replace    sp = 0 if missing(sp) | sp < 0
    replace basket = basket + sp
    drop sp
}

egen hhid_num = group(hhid_full)
keep hhid_num quintile w urban exempt exp_uf exp_ui exp_rf exp_ri basket
tempfile work
save `work'

*===============================================================================
* 2. Validation: per-quintile mean basket expenditure  vs  Figure A2
*    (published Figure A2 totals are approximately 33 / 36 / 45 / 54 / 70)
*===============================================================================
gen double wbask = w*basket
di as txt "--- Figure A2 cross-check: mean basket expenditure by quintile ---"
forvalues q=1/5 {
    quietly summ wbask if quintile==`q', meanonly
    local num = r(sum)
    quietly summ w if quintile==`q', meanonly
    di as res "  Q`q': " %5.1f `num'/r(sum)
}
drop wbask

*===============================================================================
* 3. Program: panel (a) bars and panel (b) deviations
*===============================================================================
global rfp   = `r_formal_pool'
global PT_UF = `pt_uf'
global PT_UI = `pt_ui'
global PT_RF = `pt_rf'
global PT_RI = `pt_ri'

capture program drop fig5_calc
program define fig5_calc, rclass
    * weighted-mean exempt expenditure per quintile, by cell (no collapse/preserve)
    scalar Suf=0
    scalar Sui=0
    scalar Srf=0
    scalar Sri=0
    forvalues q=1/5 {
        quietly summ exempt [aw=w] if quintile==`q', meanonly
        scalar mE`q'=r(mean)
        quietly summ exp_uf [aw=w] if quintile==`q', meanonly
        scalar mUF`q'=r(mean)
        quietly summ exp_ui [aw=w] if quintile==`q', meanonly
        scalar mUI`q'=r(mean)
        quietly summ exp_rf [aw=w] if quintile==`q', meanonly
        scalar mRF`q'=r(mean)
        quietly summ exp_ri [aw=w] if quintile==`q', meanonly
        scalar mRI`q'=r(mean)
        scalar Suf=Suf+mUF`q'
        scalar Sui=Sui+mUI`q'
        scalar Srf=Srf+mRF`q'
        scalar Sri=Sri+mRI`q'
    }
    * expenditure-weighted pooled rates (blue uses pt_all; green uses pt_F, pt_I)
    scalar pt_all=(Suf*$PT_UF+Sui*$PT_UI+Srf*$PT_RF+Sri*$PT_RI)/(Suf+Sui+Srf+Sri)
    scalar pt_F  =(Suf*$PT_UF+Srf*$PT_RF)/(Suf+Srf)
    scalar pt_I  =(Sui*$PT_UI+Sri*$PT_RI)/(Sui+Sri)
    * benefits by quintile + totals
    scalar TF=0
    scalar TC=0
    scalar TG=0
    forvalues q=1/5 {
        scalar bF`q'=mUF`q'*$PT_UF+mUI`q'*$PT_UI+mRF`q'*$PT_RF+mRI`q'*$PT_RI   // red, all-store
        scalar bC`q'=mE`q'*pt_all                                              // blue
        scalar bG`q'=(mUF`q'+mRF`q')*pt_F+(mUI`q'+mRI`q')*pt_I                 // green
        scalar TF=TF+bF`q'
        scalar TC=TC+bC`q'
        scalar TG=TG+bG`q'
    }
    forvalues q=1/5 {
        * *(A)* panel (a): total = formal-store PT, distributed by total benefit bF
        *       (for formal-store benefit only, replace bF`q' with mUF`q'*$PT_UF+mRF`q'*$PT_RF
        *        and TF with the corresponding sum)
        return scalar A`q'  = 100*${rfp}*bF`q'/TF
        return scalar Br`q' = 100*(bF`q'/TF - 0.20)
        return scalar Bb`q' = 100*(bC`q'/TC - 0.20)
        return scalar Bg`q' = 100*(bG`q'/TG - 0.20)
    }
end

*===============================================================================
* 4. Point estimates -> results dataset
*===============================================================================
use `work', clear
fig5_calc

clear
set obs 20
gen str1  panel    = ""
gen str55 series   = ""
gen byte  quintile = .
gen double estimate = .
local row = 1
forvalues q = 1/5 {
    replace panel="A" in `row'
    replace series="Share of foregone revenue accruing to households" in `row'
    replace quintile=`q' in `row'
    replace estimate = r(A`q') in `row'
    local ++row
    replace panel="B" in `row'
    replace series="Consumption patterns" in `row'
    replace quintile=`q' in `row'
    replace estimate = r(Bb`q') in `row'
    local ++row
    replace panel="B" in `row'
    replace series="Consumption patterns + Informality" in `row'
    replace quintile=`q' in `row'
    replace estimate = r(Bg`q') in `row'
    local ++row
    replace panel="B" in `row'
    replace series="Consumption patterns + Informality + Competition" in `row'
    replace quintile=`q' in `row'
    replace estimate = r(Br`q') in `row'
    local ++row
}
tempfile points
save `points'

di as txt "--- Panel (a) bars (sum = formal-store pass-through) ---"
local tot=0
forvalues q=1/5 {
    di as res "  Q`q': " %5.2f r(A`q')
    local tot=`tot'+r(A`q')
}
di as res "  total: " %5.1f `tot'

*===============================================================================
* 5. Household-cluster bootstrap -> 95% CIs
*===============================================================================
tempfile boot ci
use `work', clear
bootstrap ///
    A1=r(A1) A2=r(A2) A3=r(A3) A4=r(A4) A5=r(A5) ///
    Bb1=r(Bb1) Bb2=r(Bb2) Bb3=r(Bb3) Bb4=r(Bb4) Bb5=r(Bb5) ///
    Bg1=r(Bg1) Bg2=r(Bg2) Bg3=r(Bg3) Bg4=r(Bg4) Bg5=r(Bg5) ///
    Br1=r(Br1) Br2=r(Br2) Br3=r(Br3) Br4=r(Br4) Br5=r(Br5) ///
    , reps(`B') cluster(hhid_num) seed(20260626) nodots nowarn ///
      saving("`boot'", replace): fig5_calc

use "`boot'", clear
tempname pf
postfile `pf' str1 panel str55 series byte quintile double ci_low double ci_high using "`ci'", replace
forvalues q=1/5 {
    quietly _pctile A`q',  p(2.5 97.5)
    post `pf' ("A") ("Share of foregone revenue accruing to households") (`q') (r(r1)) (r(r2))
    quietly _pctile Bb`q', p(2.5 97.5)
    post `pf' ("B") ("Consumption patterns") (`q') (r(r1)) (r(r2))
    quietly _pctile Bg`q', p(2.5 97.5)
    post `pf' ("B") ("Consumption patterns + Informality") (`q') (r(r1)) (r(r2))
    quietly _pctile Br`q', p(2.5 97.5)
    post `pf' ("B") ("Consumption patterns + Informality + Competition") (`q') (r(r1)) (r(r2))
}
postclose `pf'

use `points', clear
merge 1:1 panel series quintile using "`ci'", nogen
sort panel series quintile
order panel series quintile estimate ci_low ci_high
export delimited using "${dir_tables}/figure5_incidence_decile_values.csv", replace

*===============================================================================
* 6. Graphs
*===============================================================================
* --- Figure 5a: share of foregone revenue ---
twoway (bar estimate quintile if panel=="A", barwidth(0.62) fcolor("$my_blue") lcolor(white)) ///
       (rcap ci_high ci_low quintile if panel=="A", lcolor(gs6) lwidth(thin) msize(small)) ///
     , legend(off) ///
       title("") ///
       ytitle("Share of total benefits (%)", size(small)) ylabel(0(10)30, nogrid angle(0) labsize(small)) ///
       xtitle("Quintile", size(small)) xlabel(1 2 3 4 5, labsize(small)) ///
       plotregion(color(white)) graphregion(color(white)) name(panelA, replace)
graph export "${dir_graphs}/figure5a.png", replace width(2400)

gen byte sid = .
replace sid = 1 if series=="Consumption patterns"
replace sid = 2 if series=="Consumption patterns + Informality"
replace sid = 3 if series=="Consumption patterns + Informality + Competition"

* --- Figure 5b: decomposition of consumer-side incidence ---
twoway (rcap ci_high ci_low quintile if panel=="B" & sid==1, lcolor("$my_blue*0.6")) ///
       (connected estimate quintile if panel=="B" & sid==1, lcolor("$my_blue") mcolor("$my_blue") msymbol(O)) ///
       (rcap ci_high ci_low quintile if panel=="B" & sid==2, lcolor("$my_green*0.6")) ///
       (connected estimate quintile if panel=="B" & sid==2, lcolor("$my_green") mcolor("$my_green") msymbol(S)) ///
       (rcap ci_high ci_low quintile if panel=="B" & sid==3, lcolor("$my_red*0.6")) ///
       (connected estimate quintile if panel=="B" & sid==3, lcolor("$my_red") mcolor("$my_red") msymbol(O)) ///
     , yline(0, lpattern(dash) lcolor(gs8) lwidth(thin)) ///
       title("") ///
       ytitle("Deviation from neutral incidence (pp)", size(small)) ylabel(-10(5)20, nogrid angle(0) labsize(small)) ///
       xtitle("Quintile", size(small)) xlabel(1 2 3 4 5, labsize(small)) ///
       legend(order(2 "Consumption patterns" 4 "+ Informality" 6 "+ Informality + Competition") ///
              rows(3) size(vsmall) pos(11) ring(0) region(lcolor(gs12) fcolor(white))) ///
       plotregion(color(white)) graphregion(color(white)) name(panelB, replace)
graph export "${dir_graphs}/figure5b.png", replace width(2400)

*===============================================================================
* End
*===============================================================================
