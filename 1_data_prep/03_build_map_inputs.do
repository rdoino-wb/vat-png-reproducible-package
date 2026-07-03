/*==============================================================================
 03_build_map_inputs.do
 VAT exemption pass-through and incidence (Papua New Guinea) — data preparation

 PURPOSE : Build map input files: household geographic locations (province,
           district, ward) and the distribution of households across districts.
 INPUTS  : ${final_phone}/final_dataset.dta
 OUTPUTS : ${final_phone}/map.csv
           ${final_phone}/map_month.csv
           ${final_phone}/map_monthly_avg.csv
 DEPENDS : 02_build_phone_panel.do
 CALLED BY: main.do
==============================================================================*/

* Load dataset
use "${final_phone}/final_dataset.dta" , clear

* Keep one observation per HH and conserve the province, district, and ward
collapse (max) province district ward , by(hhid_full)

* Apply geographic labels (already defined in master globals)
label values province s1q13 
label values district s1q14 
label values ward s1q15

* Clean variables a bit 
replace ward = . if ward >= 90000001
    
* Save dataset in csv format
export delimited using "${final_phone}/map.csv" , replace

* Another option exporting distribution of HHs in a given month of the survey
*-------------------------------------------------------------------------------

* Load dataset
use "${final_phone}/final_dataset.dta" , clear

* Keep observations of only one month (baseline month)
keep if month_year == 23
keep province district ward hhid_full

* Apply geographic labels (already defined in master globals)
label values province s1q13 
label values district s1q14 
label values ward s1q15

* Clean variables a bit 
replace ward = . if ward >= 90000001
    
* Save dataset in csv format
export delimited using "${final_phone}/map_month.csv" , replace

* Another option exporting the monthly average distribution of HHs in the survey
*-------------------------------------------------------------------------------

* Load dataset
use "${final_phone}/final_dataset.dta" , clear

* Keep one observation per HH and conserve the province, district, and ward
collapse (max) province (count) hh_n = province , by(district month_year)
drop if month_year == .
collapse (max) province (mean) hh_n , by(district)
drop if district == .

* Apply geographic labels (already defined in master globals)
label values province s1q13 
label values district s1q14 

* Save dataset in csv format
export delimited using "${final_phone}/map_monthly_avg.csv" , replace
