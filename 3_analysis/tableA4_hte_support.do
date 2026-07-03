/*==============================================================================
 tableA4_hte_support.do
 VAT exemption pass-through and incidence (Papua New Guinea) — analysis

 PURPOSE : Reproduce Table A4 (Panel A): heterogeneous treatment effects of the
           May 2026 survey experiment on support for removing the food tax, by
           households' April 2026 preferred support policy. Main estimates are
           unweighted (sample ATE); household-weighted estimates reported as a
           robustness check. Both condition on the question-version indicator and
           use HC1-robust SEs. Outcome support5 (1-5, 5 = strongly support);
           treatment s10q18_TREATCONT; moderator apr_best.
 INPUTS  : ${phone_extract} (standalone fallback: PNG_HFPS_Household_weighted_wFood.dta)
 OUTPUTS : ${dir_tables}/table_a4.tex
 DEPENDS : run from main.do after data prep (uses the May and April 2026 rounds)
 CALLED BY: main.do

 NOTE (fix): Stata's %fmt has no printf-style "+" flag, so "%+5.3f" is invalid
   (file write -> r(120); string() silently returns ""). Signed coefficients are
   built explicitly:  cond(b>=0,"+","") + string(b,"%5.3f")  and stored in
   the globals bs_<nm>_u / bs_<nm>_w, referenced in the display and LaTeX blocks.
==============================================================================*/

clear
set more off
version 16

* standalone fallbacks (no effect when run from main.do)
if "${dir_tables}" == "" global dir_tables "."

local DTA "${phone_extract}"
if "${phone_extract}" == "" local DTA "PNG_HFPS_Household_weighted_wFood.dta"   // standalone fallback (working dir)
local OUT "${dir_tables}/table_a4.tex"

*----------------------------------------------------------------- build data ---
* (1) May 2026 experiment frame
use "`DTA'", clear
keep if year==2026 & month==5 & !missing(s10q18_TREATCONT)
gen double supp_raw = s10q18_1
replace    supp_raw = s10q18_2 if missing(supp_raw)   // each respondent answers one version
gen byte   version2 = !missing(s10q18_2)              // orthogonal question-version factor
gen double support5 = 6 - supp_raw                    // 5 = strongly support ... 1 = strongly oppose
gen byte   treat    = s10q18_TREATCONT
gen double w        = cond(missing(weight_hh), 1, weight_hh)
keep if !missing(supp_raw)
keep hhid_full treat version2 support5 w
tempfile may
save `may'

* (2) April 2026 preferred policy (coalesce the six randomly-ordered versions)
use "`DTA'", clear
keep if year==2026 & month==4
gen double apr_best = S10Q15_1
forvalues i = 2/6 {
    replace apr_best = S10Q15_`i' if missing(apr_best)
}
keep hhid_full apr_best
drop if missing(hhid_full)
duplicates drop hhid_full, force
tempfile apr
save `apr'

* (3) merge April preference onto May experiment respondents
use `may', clear
merge m:1 hhid_full using `apr', keep(master match) nogen
gen byte food = (apr_best==2)        // prefers removing food tax
gen byte cash = (apr_best==1)        // prefers cash transfer
label define pol 1 "Cash transfer (under-5s)" 2 "Remove tax on food" ///
    3 "Remove tax on fuel" 4 "Free textbooks" 5 "Free phone credit"  ///
    6 "Reduce government debt"
label values apr_best pol

di as txt _n "May 2026 experiment: N = " _N
quietly count if !missing(apr_best)
di as txt "Linked to April preference: N = " r(N)

*------------------------------------------------------------------- program ----
* subgroup ATE for one subset: stores UNWEIGHTED (_u) and WEIGHTED (_w) results
* in scalars b_<nm>_*, se_<nm>_*, n_<nm>, stars in globals s_<nm>_*, and
* sign-explicit coefficient strings in globals bs_<nm>_*.
capture program drop _run
program define _run
    syntax anything [if]
    local nm `anything'
    quietly count `if'
    scalar n_`nm' = r(N)
    if r(N) < 25 {
        scalar b_`nm'_u = .
        scalar b_`nm'_w = .
        exit
    }
    quietly regress support5 treat version2 `if', vce(robust)
    scalar b_`nm'_u  = _b[treat]
    scalar se_`nm'_u = _se[treat]
    local pu = 2*ttail(e(df_r), abs(_b[treat]/_se[treat]))
    global s_`nm'_u  = cond(`pu'<.01,"***",cond(`pu'<.05,"**",cond(`pu'<.1,"*","")))
    global bs_`nm'_u = cond(b_`nm'_u>=0,"+","") + string(b_`nm'_u,"%5.3f")
    quietly regress support5 treat version2 [pw=w] `if', vce(robust)
    scalar b_`nm'_w  = _b[treat]
    scalar se_`nm'_w = _se[treat]
    local pw = 2*ttail(e(df_r), abs(_b[treat]/_se[treat]))
    global s_`nm'_w  = cond(`pw'<.01,"***",cond(`pw'<.05,"**",cond(`pw'<.1,"*","")))
    global bs_`nm'_w = cond(b_`nm'_w>=0,"+","") + string(b_`nm'_w,"%5.3f")
end

* interaction (treat x moderator): stores _u and _w coefficients/SE/p
capture program drop _int
program define _int
    args nm modvar
    quietly regress support5 i.treat##i.`modvar' version2 if !missing(apr_best), vce(robust)
    scalar b_`nm'_u  = _b[1.treat#1.`modvar']
    scalar se_`nm'_u = _se[1.treat#1.`modvar']
    scalar p_`nm'_u  = 2*ttail(e(df_r), abs(b_`nm'_u/se_`nm'_u))
    global s_`nm'_u  = cond(p_`nm'_u<.01,"***",cond(p_`nm'_u<.05,"**",cond(p_`nm'_u<.1,"*","")))
    global bs_`nm'_u = cond(b_`nm'_u>=0,"+","") + string(b_`nm'_u,"%5.3f")
    quietly regress support5 i.treat##i.`modvar' version2 [pw=w] if !missing(apr_best), vce(robust)
    scalar b_`nm'_w  = _b[1.treat#1.`modvar']
    scalar se_`nm'_w = _se[1.treat#1.`modvar']
    scalar p_`nm'_w  = 2*ttail(e(df_r), abs(b_`nm'_w/se_`nm'_w))
    global s_`nm'_w  = cond(p_`nm'_w<.01,"***",cond(p_`nm'_w<.05,"**",cond(p_`nm'_w<.1,"*","")))
    global bs_`nm'_w = cond(b_`nm'_w>=0,"+","") + string(b_`nm'_w,"%5.3f")
end

*----------------------------------------------------------------- estimates ----
_run overall
_run food  if food==1
_run other if food==0 & !missing(apr_best)
forvalues k = 1/6 {
    _run g`k' if apr_best==`k'
}
_int iF food
_int iC cash

* joint test across the six policy groups (base = remove food tax)
quietly regress support5 i.treat##ib2.apr_best version2 if !missing(apr_best), vce(robust)
quietly testparm i.treat#i.apr_best
scalar pJ_u = r(p)
quietly regress support5 i.treat##ib2.apr_best version2 [pw=w] if !missing(apr_best), vce(robust)
quietly testparm i.treat#i.apr_best
scalar pJ_w = r(p)

*------------------------------------------------------------------- display ----
di as txt _n "{hline 78}"
di as txt %-30s "Subgroup" "  N" _col(40) "Unweighted" _col(60) "Weighted"
di as txt "{hline 78}"
foreach r in overall food other g1 g6 g4 g3 g5 {
    local lbl "`r'"
    if "`r'"=="overall" local lbl "Overall (ATE)"
    if "`r'"=="food"    local lbl "Prefers food tax"
    if "`r'"=="other"   local lbl "Prefers another policy"
    if "`r'"=="g1"      local lbl "  Cash transfer (u5)"
    if "`r'"=="g6"      local lbl "  Reduce govt debt"
    if "`r'"=="g4"      local lbl "  Free textbooks"
    if "`r'"=="g3"      local lbl "  Remove fuel tax"
    if "`r'"=="g5"      local lbl "  Free phone credit"
    if !missing(b_`r'_u) {
        local u  = "${bs_`r'_u}"+" ("+string(se_`r'_u,"%4.3f")+")${s_`r'_u}"
        local wt = "${bs_`r'_w}"+" ("+string(se_`r'_w,"%4.3f")+")${s_`r'_w}"
    }
    else {
        local u "--"
        local wt "--"
    }
    di as txt %-30s "`lbl'" as res %4.0f n_`r' _col(40) "`u'" _col(60) "`wt'"
}
di as txt "{hline 78}"
local u  = "${bs_iF_u}"+" ("+string(se_iF_u,"%4.3f")+")${s_iF_u}"
local wt = "${bs_iF_w}"+" ("+string(se_iF_w,"%4.3f")+")${s_iF_w}"
di as txt %-30s "Food tax x Treat" _col(40) as res "`u'" _col(60) "`wt'"
local u  = "${bs_iC_u}"+" ("+string(se_iC_u,"%4.3f")+")${s_iC_u}"
local wt = "${bs_iC_w}"+" ("+string(se_iC_w,"%4.3f")+")${s_iC_w}"
di as txt %-30s "Cash x Treat" _col(40) as res "`u'" _col(60) "`wt'"
di as txt %-30s "Joint test (p)" _col(40) as res %5.3f pJ_u _col(60) %5.3f pJ_w
di as txt "{hline 78}"

*----------------------------------------------------------------- write LaTeX --
* (\$ writes a literal dollar sign for LaTeX math; ${...} expands the star and
*  sign-explicit-coefficient globals)
tempname f
file open `f' using "`OUT'", write replace
file write `f' "\begin{tabular}{lc r@{\hspace{3pt}}l r@{\hspace{3pt}}l}" _n "\toprule" _n
file write `f' " & & \multicolumn{2}{c}{Unweighted} & \multicolumn{2}{c}{Weighted} \\" _n
file write `f' "\cmidrule(lr){3-4}\cmidrule(lr){5-6}" _n
file write `f' "Subgroup & \$N\$ & \multicolumn{2}{c}{(robust SE)} & \multicolumn{2}{c}{(robust SE)} \\" _n "\midrule" _n

* -- estimate rows --
file write `f' "Overall (ATE) & " %4.0f (n_overall) " & \$${bs_overall_u}^{${s_overall_u}}\$ & \$(" %4.3f (se_overall_u) ")\$ & \$${bs_overall_w}^{${s_overall_w}}\$ & \$(" %4.3f (se_overall_w) ")\$ \\" _n
file write `f' "\addlinespace" _n
file write `f' "\multicolumn{6}{l}{\textit{Preferred way to support households (April 2026):}}\\" _n
file write `f' "\quad Prefers removing food tax & " %4.0f (n_food) " & \$${bs_food_u}^{${s_food_u}}\$ & \$(" %4.3f (se_food_u) ")\$ & \$${bs_food_w}^{${s_food_w}}\$ & \$(" %4.3f (se_food_w) ")\$ \\" _n
file write `f' "\quad Prefers another policy & " %4.0f (n_other) " & \$${bs_other_u}^{${s_other_u}}\$ & \$(" %4.3f (se_other_u) ")\$ & \$${bs_other_w}^{${s_other_w}}\$ & \$(" %4.3f (se_other_w) ")\$ \\" _n
file write `f' "\addlinespace" _n
file write `f' "\multicolumn{6}{l}{\quad\textit{Another policy, by type:}}\\" _n
foreach k in 1 6 4 3 5 {
    local lbl : label pol `k'
    if !missing(b_g`k'_u) {
        file write `f' "\quad\quad `lbl' & " %4.0f (n_g`k') " & \$${bs_g`k'_u}^{${s_g`k'_u}}\$ & \$(" %4.3f (se_g`k'_u) ")\$ & \$${bs_g`k'_w}^{${s_g`k'_w}}\$ & \$(" %4.3f (se_g`k'_w) ")\$ \\" _n
    }
    else {
        file write `f' "\quad\quad `lbl' & " %4.0f (n_g`k') " & \multicolumn{2}{c}{--} & \multicolumn{2}{c}{--} \\" _n
    }
}
file write `f' "\addlinespace" _n
file write `f' "\multicolumn{6}{l}{\textit{Interaction tests:}}\\" _n
file write `f' "\quad Prefers food tax \$\times\$ Treat & & \$${bs_iF_u}^{${s_iF_u}}\$ & \$(" %4.3f (se_iF_u) ")\$ & \$${bs_iF_w}^{${s_iF_w}}\$ & \$(" %4.3f (se_iF_w) ")\$ \\" _n
file write `f' "\quad Prefers cash \$\times\$ Treat & & \$${bs_iC_u}^{${s_iC_u}}\$ & \$(" %4.3f (se_iC_u) ")\$ & \$${bs_iC_w}^{${s_iC_w}}\$ & \$(" %4.3f (se_iC_w) ")\$ \\" _n
file write `f' "\quad Joint test, all groups (\$F\$) & & \multicolumn{2}{c}{\$p=" %5.3f (pJ_u) "\$} & \multicolumn{2}{c}{\$p=" %5.3f (pJ_w) "\$} \\" _n
file write `f' "\bottomrule" _n "\end{tabular}" _n
file close `f'
di as txt _n "Wrote two-column table body to `OUT'."
di as txt "Wrap in \begin{table}...\caption...\end{table} with the booktabs and amsmath packages."

*===============================================================================
* End
*===============================================================================
