/*==============================================================================
 tableA3_familiarity.do
 VAT exemption pass-through and incidence (Papua New Guinea) — analysis

 PURPOSE : Reproduce Table A3, familiarity with the government's tax-reduction
           efforts (s5q19), from the awareness module (Dec 2025 + Jan 2026);
           unweighted frequencies, percentages, and cumulative percentages.
 INPUTS  : ${raw_phone}/20260429/PNG_HFPS_Household_weighted_wFood.dta
 OUTPUTS : ${dir_tables}/table_a3.tex; ${dir_tables}/table_a3.csv
 DEPENDS : run from main.do after data prep (uses the same extract as Table 2)
 CALLED BY: main.do
==============================================================================*/

version 16

* pipeline input (same extract as Table 2; awareness module = Dec 2025 + Jan 2026)
local DATA "${raw_phone}/20260429/PNG_HFPS_Household_weighted_wFood.dta"
if "${dir_tables}" == "" global dir_tables "."   // standalone fallback

cap confirm file "`DATA'"
if _rc {
    di as error "Could not find raw data: `DATA'"
    di as error "Place PNG_HFPS_Household_weighted_wFood.dta in the package root and rerun do run_all.do"
    exit 601
}

*-------------------------------------------------------------------------------
* Reproduce Table A3 from the raw survey data
*-------------------------------------------------------------------------------
use "`DATA'", clear

keep year month s5q19
keep if (year == 2025 & month == 12) | (year == 2026 & month == 1)
keep if !missing(s5q19)

label define s5q19lbl 1 "Not at all" 2 "A little" 3 "Somewhat" 4 "Very Familiar", replace
label values s5q19 s5q19lbl

contract s5q19, freq(freq)
sort s5q19

egen total = total(freq)
gen double percent = 100*freq/total
gen double cum = sum(percent)
format percent cum %9.2f

decode s5q19, gen(response)
order response freq percent cum

preserve
    keep response freq percent cum
    rename response Response
    rename freq Freq
    rename percent Percent
    rename cum Cum
    export delimited using "${dir_tables}/table_a3.csv", replace
restore

* LaTeX table: current raw replication
file open fh using "${dir_tables}/table_a3.tex", write replace text
file write fh "\\begin{table}[htbp]" _n
file write fh "\\centering" _n
file write fh "\\caption{Familiarity with National Government's Efforts to Reduce Tax}" _n
file write fh "\\label{tab:table_a3}" _n
file write fh "\\begin{tabular}{lccc}" _n
file write fh "\\toprule" _n
file write fh "Response & Freq. & Percent & Cum. \\\\" _n
file write fh "\\midrule" _n
forvalues i = 1/`=_N' {
    local resp = response[`i']
    local f : display %9.0fc freq[`i']
    local p : display %9.2f percent[`i']
    local c : display %9.2f cum[`i']
    local f = trim("`f'")
    local p = trim("`p'")
    local c = trim("`c'")
    file write fh "`resp' & `f' & `p' & `c' \\\\" _n
}
local N = total[1]
local Ns : display %9.0fc `N'
local Ns = trim("`Ns'")
file write fh "\\midrule" _n
file write fh "Total & `Ns' & 100.00 & \\\\" _n
file write fh "\\bottomrule" _n
file write fh "\\end{tabular}" _n
file write fh "\\end{table}" _n
file close fh

di as txt _n "Wrote table_a3.{tex,csv} to ${dir_tables}."
