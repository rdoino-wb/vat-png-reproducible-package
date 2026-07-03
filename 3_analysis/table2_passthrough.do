/*==============================================================================
 table2_passthrough.do
 VAT exemption pass-through and incidence (Papua New Guinea) — analysis

 PURPOSE : Build the post-only Table 2 VAT pass-through estimates from the raw
           PNG HFPS phone-survey data (five specifications: basic, formal, urban,
           rural, urban x formal).
 INPUTS  : ${phone_extract} pull (${raw_phone}/20260429/PNG_HFPS_Household_weighted_wFood.dta,
           set in main.do); the item-level price panel is rebuilt inline below.
 OUTPUTS : ${dir_tables}/table_2.csv; table_2.tex; table_2_long.dta;
           table_2_numeric_long.dta; table_2_numeric_long.csv
 DEPENDS : run from main.do after data prep (reads the raw phone extract directly)
 CALLED BY: main.do

 Note on the input extract:
   This script reads the phone_extract (the 20260429 pull configured in main.do)
   and rebuilds the item-level panel inline from the raw survey file.

 Notes on construction:
   - Outcome: 100 * (PricePerUnit / item mean PricePerUnit in May 2025 - 1).
   - Post estimate: simple average of post-reform event-study coefficients for
     June 2025-May 2026.
   - SEs: clustered by product/item using Stata's conventional finite-sample
     correction for vce(cluster code).
   - Stars use normal cutoffs, to match the Python table.
   - No wild-cluster bootstrap or randomization inference is used here.
   - Required external packages: none.
==============================================================================*/

version 16.0
clear all
set more off
set linesize 255
set varabbrev off

*------------------------------*
* User paths                   *
*------------------------------*
* Pipeline paths. Ensure the file below is the extract that produced Table 2.
local DATA "${raw_phone}/20260429/PNG_HFPS_Household_weighted_wFood.dta"
local OUTDIR "${dir_tables}"

*------------------------------*
* Item definitions             *
*------------------------------*
local treat_codes   104 105 107 108 110 116 131 132
local control_codes 101 102 103 111 115 125 129 130
local codes `treat_codes' `control_codes'

local label_104 "Cooking oil"
local label_105 "Rice"
local label_107 "Tinned fish"
local label_108 "Tea"
local label_110 "Flour"
local label_116 "Whole live chicken"
local label_131 "Noodles"
local label_132 "Biscuits"
local label_101 "Sugar"
local label_102 "Kaukau"
local label_103 "Bananas"
local label_111 "Aibika"
local label_115 "Sausages"
local label_125 "Phone credit"
local label_129 "Butter"
local label_130 "Milo"

local BASE = ym(2025,5)
local START = ym(2023,10)
local END = ym(2026,5)

*------------------------------*
* Build long item-level data   *
*------------------------------*
tempfile longdata onelong
local first = 1

foreach c of local codes {
    use year month urbrur s4q2`c' PricePerUnit`c' using "`DATA'", clear

    rename s4q2`c'       shop
    rename PricePerUnit`c' price

    gen int code = `c'
    gen byte treatment = inlist(code, 104,105,107,108,110,116,131,132)
    gen str30 item = "`label_`c''"

    gen int mdate = ym(year, month)
    format mdate %tm
    keep if inrange(mdate, `START', `END')

    * Drop non-purchases / invalid price entries, including negative survey codes.
    keep if !missing(price) & price > 0

    * Store formality: supermarket is formal. All other positive-price purchase locations are informal.
    gen byte formal = (shop == 2)
    gen byte urban  = (urbrur == 1)

    keep code item treatment mdate price formal urban

    if `first' {
        save `longdata', replace
        local first = 0
    }
    else {
        save `onelong', replace
        use `longdata', clear
        append using `onelong'
        save `longdata', replace
    }
}

use `longdata', clear

* Item-specific May 2025 base price and normalized outcome.
bysort code: egen double base_price = mean(cond(mdate == `BASE', price, .))
drop if missing(base_price)
gen double y = 100 * (price / base_price - 1)

* Stable item/date identifiers for fixed effects.
egen int code_id = group(code), label
egen int date_id = group(mdate), label
quietly summarize date_id if mdate == `BASE', meanonly
local base_date_id = r(mean)
fvset base 1 code_id
fvset base `base_date_id' date_id

save "`OUTDIR'/table_2_long.dta", replace

*------------------------------*
* Helper program               *
*------------------------------*
capture program drop _post_table_spec
program define _post_table_spec
    version 16.0
    syntax, COL(integer) MODEL(string) COVERAGE(string) [URBANONLY(integer -1)]

    preserve

    if `urbanonly' == 1 keep if urban == 1
    if `urbanonly' == 0 keep if urban == 0

    local base = ym(2025,5)
    levelsof mdate, local(dates)

    local rhs "i.code_id i.date_id"
    local post_tr ""
    local post_tf ""
    local post_tu ""
    local post_tfu ""

    if "`model'" == "basic" {
        foreach d of local dates {
            if `d' != `base' {
                gen double tr_`d' = treatment * (mdate == `d')
                local rhs "`rhs' tr_`d'"
                if `d' > `base' local post_tr "`post_tr' tr_`d'"
            }
        }
    }
    else if "`model'" == "formal" {
        gen double treat_formal = treatment * formal
        local rhs "`rhs' formal treat_formal"

        foreach d of local dates {
            if `d' != `base' {
                gen double formal_`d' = formal * (mdate == `d')
                gen double tr_`d'     = treatment * (mdate == `d')
                gen double tf_`d'     = treatment * formal * (mdate == `d')
                local rhs "`rhs' formal_`d' tr_`d' tf_`d'"
                if `d' > `base' {
                    local post_tr "`post_tr' tr_`d'"
                    local post_tf "`post_tf' tf_`d'"
                }
            }
        }
    }
    else if "`model'" == "urban_formal" {
        gen double formal_urban = formal * urban
        gen double treat_formal = treatment * formal
        gen double treat_urban  = treatment * urban
        gen double treat_formal_urban = treatment * formal * urban

        local rhs "`rhs' formal urban formal_urban treat_formal treat_urban treat_formal_urban"

        foreach d of local dates {
            if `d' != `base' {
                gen double formal_`d'       = formal * (mdate == `d')
                gen double urban_`d'        = urban * (mdate == `d')
                gen double formalurban_`d'  = formal * urban * (mdate == `d')
                gen double tr_`d'           = treatment * (mdate == `d')
                gen double tf_`d'           = treatment * formal * (mdate == `d')
                gen double tu_`d'           = treatment * urban * (mdate == `d')
                gen double tfu_`d'          = treatment * formal * urban * (mdate == `d')

                local rhs "`rhs' formal_`d' urban_`d' formalurban_`d' tr_`d' tf_`d' tu_`d' tfu_`d'"
                if `d' > `base' {
                    local post_tr  "`post_tr' tr_`d'"
                    local post_tf  "`post_tf' tf_`d'"
                    local post_tu  "`post_tu' tu_`d'"
                    local post_tfu "`post_tfu' tfu_`d'"
                }
            }
        }
    }
    else {
        di as error "Unknown model: `model'"
        exit 198
    }

    quietly regress y `rhs', vce(cluster code)
    local N = e(N)

    * Save N/coverage/specification in globals for table writing.
    global N_`col' `N'
    global coverage_`col' "`coverage'"
    global spec_`col' "Post"

    * Inner helper to compute the simple average of a list of post coefficients.
    foreach rowcode in T TF TU TFU {
        if "`rowcode'" == "T"   local terms "`post_tr'"
        if "`rowcode'" == "TF"  local terms "`post_tf'"
        if "`rowcode'" == "TU"  local terms "`post_tu'"
        if "`rowcode'" == "TFU" local terms "`post_tfu'"

        if "`terms'" != "" {
            local nterms : word count `terms'
            local expr ""
            foreach v of local terms {
                if "`expr'" == "" local expr "`v'"
                else local expr "`expr' + `v'"
            }
            quietly lincom (`expr') / `nterms'
            local b = r(estimate)
            local se = r(se)
            local tstat = abs(`b' / `se')
            local star ""
            if `tstat' >= invnormal(0.995) local star "***"
            else if `tstat' >= invnormal(0.975) local star "**"
            else if `tstat' >= invnormal(0.95) local star "*"

            local bf : display %4.1f `b'
            local sf : display %4.1f `se'
            local bf = trim("`bf'")
            local sf = trim("`sf'")

            global b_`rowcode'_`col'  "`bf'`star'"
            global se_`rowcode'_`col' "(`sf')"
            global rawb_`rowcode'_`col' = `b'
            global rawse_`rowcode'_`col' = `se'
        }
    }

    restore
end

*------------------------------*
* Initialize blank cells       *
*------------------------------*
foreach r in T TF TU TFU {
    forvalues c = 1/5 {
        global b_`r'_`c'  "—"
        global se_`r'_`c' ""
        global rawb_`r'_`c'  .
        global rawse_`r'_`c' .
    }
}

*------------------------------*
* Run the five specifications  *
*------------------------------*
_post_table_spec, col(1) model(basic)        coverage("All")
_post_table_spec, col(2) model(formal)       coverage("All")
_post_table_spec, col(3) model(formal)       coverage("Urban") urbanonly(1)
_post_table_spec, col(4) model(formal)       coverage("Rural") urbanonly(0)
_post_table_spec, col(5) model(urban_formal) coverage("All")

*------------------------------*
* Long numeric output          *
*------------------------------*
tempfile longresults
clear
set obs 20
gen byte col = .
gen str45 term = ""
gen double estimate = .
gen double se = .
gen long N = .
gen str10 coverage = ""

local obs = 1
foreach c in 1 2 3 4 5 {
    foreach r in T TF TU TFU {
        if "${rawb_`r'_`c'}" != "." {
            replace col = `c' in `obs'
            if "`r'" == "T"   replace term = "Treatment" in `obs'
            if "`r'" == "TF"  replace term = "Treatment × Formal" in `obs'
            if "`r'" == "TU"  replace term = "Treatment × Urban" in `obs'
            if "`r'" == "TFU" replace term = "Treatment × Formal × Urban" in `obs'
            replace estimate = ${rawb_`r'_`c'} in `obs'
            replace se       = ${rawse_`r'_`c'} in `obs'
            replace N        = ${N_`c'} in `obs'
            replace coverage = "${coverage_`c'}" in `obs'
            local ++obs
        }
    }
}
drop if missing(col)
save "`OUTDIR'/table_2_numeric_long.dta", replace
export delimited using "`OUTDIR'/table_2_numeric_long.csv", replace

*------------------------------*
* CSV output                   *
*------------------------------*
local N1 : display %12.0fc ${N_1}
local N2 : display %12.0fc ${N_2}
local N3 : display %12.0fc ${N_3}
local N4 : display %12.0fc ${N_4}
local N5 : display %12.0fc ${N_5}
local N1 = trim("`N1'")
local N2 = trim("`N2'")
local N3 = trim("`N3'")
local N4 = trim("`N4'")
local N5 = trim("`N5'")

file open csv using "`OUTDIR'/table_2.csv", write replace
file write csv `""Pass-through, p.p.",(1),(2),(3),(4),(5)"' _n
file write csv `"Treatment,${b_T_1},${b_T_2},${b_T_3},${b_T_4},${b_T_5}"' _n
file write csv `",${se_T_1},${se_T_2},${se_T_3},${se_T_4},${se_T_5}"' _n
file write csv `"Treatment × Formal,${b_TF_1},${b_TF_2},${b_TF_3},${b_TF_4},${b_TF_5}"' _n
file write csv `",${se_TF_1},${se_TF_2},${se_TF_3},${se_TF_4},${se_TF_5}"' _n
file write csv `"Treatment × Urban,${b_TU_1},${b_TU_2},${b_TU_3},${b_TU_4},${b_TU_5}"' _n
file write csv `",${se_TU_1},${se_TU_2},${se_TU_3},${se_TU_4},${se_TU_5}"' _n
file write csv `"Treatment × Formal × Urban,${b_TFU_1},${b_TFU_2},${b_TFU_3},${b_TFU_4},${b_TFU_5}"' _n
file write csv `",${se_TFU_1},${se_TFU_2},${se_TFU_3},${se_TFU_4},${se_TFU_5}"' _n
file write csv `"Specification,Post,Post,Post,Post,Post"' _n
file write csv `"Coverage,${coverage_1},${coverage_2},${coverage_3},${coverage_4},${coverage_5}"' _n
file write csv `"N,""`N1'"",""`N2'"",""`N3'"",""`N4'"",""`N5'"""' _n
file close csv

*------------------------------*
* LaTeX output                 *
*------------------------------*
local D = char(36)
file open tex using "`OUTDIR'/table_2.tex", write replace
file write tex "\begin{table}[htbp]" _n
file write tex "\centering" _n
file write tex "\caption{VAT pass-through estimates: phone survey post estimates from raw data (p.p.)}" _n
file write tex "\label{tab:phone_pass_through_post_raw}" _n
file write tex "\scriptsize" _n
file write tex "\begin{threeparttable}" _n
file write tex "\begin{tabular}{lccccc}" _n
file write tex "\toprule" _n
file write tex "Pass-through, p.p. & (1) & (2) & (3) & (4) & (5) \\" _n
file write tex "\midrule" _n
file write tex "Treatment & ${b_T_1} & ${b_T_2} & ${b_T_3} & ${b_T_4} & ${b_T_5} \\" _n
file write tex " & ${se_T_1} & ${se_T_2} & ${se_T_3} & ${se_T_4} & ${se_T_5} \\" _n
file write tex "Treatment `D'\\times`D' Formal & ${b_TF_1} & ${b_TF_2} & ${b_TF_3} & ${b_TF_4} & ${b_TF_5} \\" _n
file write tex " & ${se_TF_1} & ${se_TF_2} & ${se_TF_3} & ${se_TF_4} & ${se_TF_5} \\" _n
file write tex "Treatment `D'\\times`D' Urban & ${b_TU_1} & ${b_TU_2} & ${b_TU_3} & ${b_TU_4} & ${b_TU_5} \\" _n
file write tex " & ${se_TU_1} & ${se_TU_2} & ${se_TU_3} & ${se_TU_4} & ${se_TU_5} \\" _n
file write tex "Treatment `D'\\times`D' Formal `D'\\times`D' Urban & ${b_TFU_1} & ${b_TFU_2} & ${b_TFU_3} & ${b_TFU_4} & ${b_TFU_5} \\" _n
file write tex " & ${se_TFU_1} & ${se_TFU_2} & ${se_TFU_3} & ${se_TFU_4} & ${se_TFU_5} \\" _n
file write tex "\midrule" _n
file write tex "Specification & Post & Post & Post & Post & Post \\" _n
file write tex "Coverage & ${coverage_1} & ${coverage_2} & ${coverage_3} & ${coverage_4} & ${coverage_5} \\" _n
file write tex "`D'N`D' & `N1' & `N2' & `N3' & `N4' & `N5' \\" _n
file write tex "\bottomrule" _n
file write tex "\end{tabular}" _n
file write tex "\begin{tablenotes}[flushleft]" _n
file write tex "\scriptsize" _n
file write tex "\item \textit{Notes:} Coefficients are in p.p. of price change for VAT-exempt vs. control items. Prices are normalized to item-specific May 2025 means. Post is the simple average of post-reform event-study coefficients from June 2025 to May 2026. Full pass-through corresponds to `D'-9.1`D' p.p. Treatment items are cooking oil, rice, tinned fish, tea, flour, whole live chicken, noodles, and biscuits. Control items are sugar, kaukau, bananas, aibika, sausages, phone credit, butter, and Milo. Formal equals supermarket purchase. SEs clustered at product level in parentheses. *** `D'p<0.01`D', ** `D'p<0.05`D', * `D'p<0.10`D'." _n
file write tex "\end{tablenotes}" _n
file write tex "\end{threeparttable}" _n
file write tex "\end{table}" _n
file close tex

*------------------------------*
* Display table in log         *
*------------------------------*
di as txt _n "Table written to: `OUTDIR'/table_2.csv and .tex" _n
type "`OUTDIR'/table_2.csv"
