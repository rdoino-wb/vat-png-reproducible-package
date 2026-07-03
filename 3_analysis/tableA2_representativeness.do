/*==============================================================================
 tableA2_representativeness.do
 VAT exemption pass-through and incidence (Papua New Guinea) — analysis

 PURPOSE : Compare the phone-survey household distribution across provinces with
           the 2011 census to assess sample representativeness (Table A2).
 INPUTS  : ${raw_census}/png_admpop_adm2_2011_v2.csv (2011 census);
           ${final_phone}/png_survey_by_district.dta,
           png_survey_by_district_month.dta,
           png_survey_by_district_monthly_avg.dta
 OUTPUTS : ${final_census}/census_households_by_district.dta (intermediate);
           $dir_tables/survey_census_representativeness.tex
 DEPENDS : run from main.do after data prep (phone survey district aggregates built upstream)
 CALLED BY: main.do
==============================================================================*/

clear all
set more off

*------------------------------------------------------------------------------*
* Import, clean, and save census data
*------------------------------------------------------------------------------*

* Import census data 
import delimited "${raw_census}/png_admpop_adm2_2011_v2.csv", encoding("UTF-8") clear 

/* source
https://data.humdata.org/dataset/cod-ps-png */

* Rename variables
rename adm2_en district
rename adm1_en province
rename t_tl persons
rename m_tl male_persons
rename f_tl female_persons


* Keep only relevant variables
keep district province households persons male_persons female_persons

* Clean district and province names
*-------------------------------------------------------------------------------

* 1) Make uppercase + trim extra spaces
gen strL district_norm = upper(itrim(strtrim(district)))
gen strL province_norm = upper(itrim(strtrim(province)))

* 2) Replace "/" with "-"
replace district_norm = subinstr(district_norm, "/", "-", .)

* 3) Remove the word "DISTRICT" only if it appears at the end
replace district_norm = regexr(district_norm, "\s*DISTRICT\s*$", "") if district_norm != "NATIONAL CAPITAL DISTRICT"
replace province_norm = regexr(province_norm, "\s*PROVINCE\s*$", "") 

* Final tidy (remove any leftover leading/trailing spaces)
replace district_norm = itrim(strtrim(district_norm))
* And spaces between words and dash
replace district_norm = ustrregexra(district_norm, "[[:space:]]*-[[:space:]]*", "-")

* Individual fixes
replace province_norm = "BOUGAINVILLE" if province_norm == "AUTONOMOUS REGION OF BOUGAINVILLE"
replace province_norm = "CHIMBU" if province_norm == "CHIMBU (SIMBU)"

* Harmonize string format to merge later 
gen str80 district_norm_str = district_norm
drop district_norm
rename district_norm_str district_norm

gen str80 province_norm_str = province_norm
drop province_norm
rename province_norm_str province_norm

* Generate percent of HHs by district
gegen total_hh = total(households)
gen hh_pct_census = (households / total_hh) * 100
drop total_hh

	// There are 87 districts in 2011 census 

* Save dataset 
*-------------------------------------------------------------------------------
save "${final_census}/census_households_by_district.dta" , replace


*------------------------------------------------------------------------------*
* Use phone survey HHs by district and merge with census data
*------------------------------------------------------------------------------*

use "${final_phone}/png_survey_by_district.dta" , clear
merge 1:1 district_norm using "${final_phone}/png_survey_by_district_month.dta"  
drop _merge 
merge 1:1 district_norm using "${final_phone}/png_survey_by_district_monthly_avg.dta" 
drop _merge 


* Clean province names 
*-------------------------------------------------------------------------------
rename NAME_1 province
* 1) Make uppercase + trim extra spaces
gen strL province_norm = upper(itrim(strtrim(province)))

* Harmonize string format to merge later 
gen str80 district_norm_str = district_norm
drop district_norm
rename district_norm_str district_norm

gen str80 province_norm_str = province_norm
drop province_norm
rename province_norm_str province_norm

* Adjust a few variables
replace hh_pct = hh_pct * 100
replace hh_month_pct = hh_month_pct * 100
replace hh_monthly_avg_pct = hh_monthly_avg_pct * 100

* Harmonize names to match with those in the census data 
replace district_norm = "AMBUNTI-DREKIKIER" if district_norm == "AMBUNTI-DREIKIKIR"
replace district_norm = "FINSCHAFEN" if district_norm == "FINSCHHAFEN" 
replace district_norm = "KAINANATU" if district_norm == "KAINANTU"  
replace district_norm = "KOMPIAM" if district_norm == "KOMPIAM-AMBUM"
replace district_norm = "LAGAIP-POGERA" if district_norm == "LAGAIP-PORGERA"
replace district_norm = "MT HAGEN" if district_norm == "MOUNT HAGEN"
replace district_norm = "SINA SINA YONGGOMUGL" if district_norm == "SINA SINA-YONGGOMUGL"
replace district_norm = "TAWAE-SIASSI" if district_norm == "TEWAE-SIASSI"
replace district_norm = "UNGGAI-BENNA" if district_norm == "UNGGAI-BENA" 
replace district_norm = "USINO BUNDI" if district_norm == "USINO-BUNDI"  
replace district_norm = "WOSERA GAWI" if district_norm == "WOSERA-GAWI"
replace district_norm = "YANGORU SAUSSIA" if district_norm == "YANGORO-SAUSSIA" 

replace province_norm = "NORTHERN (ORO)" if province_norm == "ORO"
replace province_norm = "WEST SEPIK (SANDAUN)" if province_norm == "SANDAUN"

* Merge with census data at the district level
merge 1:1 district_norm province_norm using "${final_census}/census_households_by_district.dta" , gen(mer_census)
drop mer_census

* Keep only district names and relevant variables for table 
keep province_norm district_norm hh_pct hh_month_pct hh_monthly_avg_pct hh_pct_census

* Prepare data for table at the province level 
collapse (sum) hh_pct hh_month_pct hh_monthly_avg_pct hh_pct_census , by(province_norm)

* Table 
*-------------------------------------------------------------------------------
format hh_pct  hh_month_pct hh_monthly_avg_pct hh_pct_census  %14.2f

tostring province_norm hh_pct hh_month_pct hh_monthly_avg_pct hh_pct_census, force replace usedisplayformat

putmata  province_norm hh_pct hh_month_pct hh_monthly_avg_pct hh_pct_census ,  replace

mata table = (province_norm, hh_pct, hh_month_pct, hh_monthly_avg_pct, hh_pct_census)

* Export table to LaTeX. mmat2tex mishandles spaces in the file path (the project
* folder name contains spaces), so cd into the output folder, write with a relative
* filename, then restore the original working directory so the rest of the pipeline
* is unaffected.
local _cwd "`c(pwd)'"
cd "$dir_tables"
mmat2tex table using "survey_census_representativeness.tex", replace ///
preheader("\begin{tabular}{lcccc} \toprule & \multicolumn{3}{c}{Survey} & Census \\" ///
		  "\cmidrule(lr){2-4} \cmidrule(lr){5-5} & All months & 1-month & Monthly average &  \\ " ///
		  "\midrule") ///
bottom ("\bottomrule \end{tabular}")
cd "`_cwd'"
