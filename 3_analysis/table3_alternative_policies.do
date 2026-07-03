/*==============================================================================
 table3_alternative_policies.do
 VAT exemption pass-through and incidence (Papua New Guinea) — analysis

 PURPOSE : Table 3. Cost of delivering the same benefit to the poorest quintile
           as the VAT exemption, under alternative policies. Pure calibration:
           no data input, no cleaning.
 INPUTS  : none (calibration parameters set inline below)
 OUTPUTS : ${dir_tables}/table_3.tex
 DEPENDS : run from main.do (standalone otherwise; writes to working dir)
 CALLED BY: main.do

 Parameter provenance (set deliberately, not estimated here):
   - foregone_m  = 150  : total foregone VAT revenue, USD millions. External
                          (administrative). Document the source in the README.
   - q1_share    = 0.08 : share of the benefit accruing to the poorest quintile.
                          If this is an estimated incidence quantity rather than an
                          assumption, source it from the incidence analysis instead
                          of hardcoding, so the table updates when the estimate does.
   - leakage_rate= 0.50 : assumed leakage in the leakage scenario.
==============================================================================*/

version 17.0
clear            // not "clear all": that wipes globals set by main.do (e.g. ${dir_tables})
set more off

* standalone fallback: if run outside main.do, write to the working directory
if "${dir_tables}" == "" global dir_tables "."

*----------------------------*
* 1. Core assumptions
*----------------------------*
local foregone_m          150       // Total foregone revenue, USD millions
local q1_share            0.08      // Share accruing to poorest quintile
local universal_groups    5         // Five quintiles
local leakage_rate        0.50      // Leakage in the leakage scenario

*----------------------------*
* 2. Derived quantities
*----------------------------*
local q1_benefit_m = `foregone_m' * `q1_share'

local perfect_cost_m       = `q1_benefit_m'
local universal_cost_m     = `q1_benefit_m' * `universal_groups'
local leakage_cost_m       = `universal_cost_m' / (1 - `leakage_rate')
local child_grant_cost_m   = `foregone_m'
local vat_cost_m           = `foregone_m'

local perfect_share        = 100 * `perfect_cost_m'     / `foregone_m'
local universal_share      = 100 * `universal_cost_m'   / `foregone_m'
local leakage_share        = 100 * `leakage_cost_m'     / `foregone_m'
local child_grant_share    = 100 * `child_grant_cost_m' / `foregone_m'
local vat_share            = 100 * `vat_cost_m'         / `foregone_m'
local q1_cents             = 100 * `q1_share'

*----------------------------*
* 3. Formatting helpers
*----------------------------*
local q1_benefit_s      : display %9.0f `q1_benefit_m'
local perfect_cost_s    : display %9.0f `perfect_cost_m'
local universal_cost_s  : display %9.0f `universal_cost_m'
local leakage_cost_s    : display %9.0f `leakage_cost_m'
local child_grant_s     : display %9.0f `child_grant_cost_m'
local vat_cost_s        : display %9.0f `vat_cost_m'

local perfect_share_s     : display %9.0f `perfect_share'
local universal_share_s   : display %9.0f `universal_share'
local leakage_share_s     : display %9.0f `leakage_share'
local child_grant_share_s : display %9.0f `child_grant_share'
local vat_share_s         : display %9.0f `vat_share'
local q1_cents_s          : display %9.0f `q1_cents'

foreach x in q1_benefit_s perfect_cost_s universal_cost_s leakage_cost_s ///
             child_grant_s vat_cost_s perfect_share_s universal_share_s ///
             leakage_share_s child_grant_share_s vat_share_s q1_cents_s {
    local `x' = trim("``x''")
}

*----------------------------*
* 4. Write LaTeX table
*----------------------------*
file open fout using "${dir_tables}/table_3.tex", write replace

file write fout "\begin{table}[!htbp]" _n
file write fout "\centering" _n
file write fout "\caption{Cost of delivering USD `q1_benefit_s' million to the poorest quintile under alternative policies}" _n
file write fout "\label{tab:alternative_policies}" _n
file write fout "\begin{tabular}{lcc}" _n
file write fout "\toprule" _n
file write fout "Policy & Cost to deliver & Share of foregone revenue \\" _n
file write fout "\midrule" _n
file write fout "Perfect targeting (Q1 only) & USD `perfect_cost_s' million & `perfect_share_s'\% \\" _n
file write fout "Universal transfer (no targeting) & USD `universal_cost_s' million & `universal_share_s'\% \\" _n
file write fout "Universal transfer (50\% leakage) & USD `leakage_cost_s' million & `leakage_share_s'\% \\" _n
file write fout "Child grant and nutrition program & USD `child_grant_s' million & `child_grant_share_s'\% \\" _n
file write fout "VAT exemption (actual) & USD `vat_cost_s' million & `vat_share_s'\% \\" _n
file write fout "\bottomrule" _n
file write fout "\end{tabular}" _n
file write fout "\vspace{0.3em}" _n
file write fout "\begin{minipage}{0.86\linewidth}" _n
file write fout "\footnotesize \textit{Notes:} This table compares the fiscal cost of alternative policies that would deliver the same monetary benefit to the poorest quintile as the VAT exemption reform. The benchmark assumes that the actual VAT exemption delivers approximately USD `q1_benefit_s' million to the poorest quintile, or about `q1_cents_s' cents of each dollar of foregone revenue. The alternative rows report stylized transfer schemes under different targeting assumptions and implied leakage." _n
file write fout "\end{minipage}" _n
file write fout "\end{table}" _n

file close fout

display as result "Wrote ${dir_tables}/table_3.tex"
display as text   "Q1 benefit: 8% of USD 150 million = USD `q1_benefit_s' million"
