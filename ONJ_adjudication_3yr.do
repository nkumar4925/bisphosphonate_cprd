*******************************************************
* ONJ_adjudication_3yr.do
* Extracted ONJ adjudication logic (3-year follow-up)
*
* Notes:
* - This repository contains NO patient-level data.
* - The script references CPRD/HES-style filenames and variables.
* - To run end-to-end you need authorised access to CPRD/HES and
*   local copies of the required datasets in the expected folders.
* Codelists list 6 and 7 are as specified by Persson et al. (2025) doi.org/10.1007/s00198-024-07262-7
*******************************************************

do "code/00_setup.do"

********************************************************
** Pool of ONJ to be verified with supporting codes
** Strong List 6: within ±365 days of index (before or after)
** Weak   List 7: within ±90  days of index (before or after)
********************************************************

* ---------- STRONG ----------
* HES ICD
use "cohorts\bispho3yr_hes.dta", clear
merge m:1 icd2 using "codes_6_icd.dta"
keep if _merge==3
drop _merge
merge m:m patid using "osteo_excl_clean.dta"
keep if _merge==3
drop _merge

gen temp = date(discharged,"DMY")
format temp %tdDD/NN/CCYY
drop discharged
rename temp discharged
order discharged, after(index_date)

gen days = discharged - index_date
gen strong_hes_icd = 1 if (abs(days)<=365)
keep if strong_hes_icd==1
rename discharged strong_hes_date

save "strong_hes_icd.dta", replace

* HES OPCS
use "cohorts\bispho3yr_hes_opcs.dta", clear
merge m:1 opcs using "codes_6_opcs.dta"
keep if _merge==3
drop _merge
merge m:m patid using "osteo_excl_clean.dta", force
keep if _merge==3
drop _merge

gen temp = date(epiend,"DMY")
format temp %tdDD/NN/CCYY
drop epiend
rename temp epiend
order epiend, after(index_date)

gen days = epiend - index_date
gen strong_hes_opcs = 1 if (abs(days)<=365)
keep if strong_hes_opcs==1
rename epiend strong_hes_opcs_date

save "strong_hes_opcs.dta", replace

* CPRD obs (date = obsdate)
use "cohorts\bispho3yr_obs_cut.dta", clear
merge m:1 medcodeid using "codes_6_medcode.dta"
keep if _merge==3
drop _merge
merge m:m patid using "osteo_excl_clean.dta"
keep if _merge==3
drop _merge

gen temp = date(obsdate,"DMY")
format temp %tdDD/NN/CCYY
drop obsdate
rename temp obsdate
order obsdate, after(index_date)

gen days = obsdate - index_date
gen strong_cprd_med = 1 if (abs(days)<=365)
keep if strong_cprd_med==1
rename obsdate strong_cprd_date

save "strong_cprd_med.dta", replace

* ---------- WEAK ----------
* HES ICD (date = discharged)
use "cohorts\bispho3yr_hes.dta", clear
merge m:1 icd2 using "codes_7_icd.dta"
keep if _merge==3
drop _merge
merge m:m patid using "osteo_excl_clean.dta"
keep if _merge==3
drop _merge

gen temp = date(discharged,"DMY")
format temp %tdDD/NN/CCYY
drop discharged
rename temp discharged
order discharged, after(index_date)

gen days = discharged - index_date
gen weak_hes_icd = 1 if (abs(days)<=90)
keep if weak_hes_icd==1
rename discharged weak_hes_date

save "weak_hes_icd.dta", replace

* HES OPCS (date = epiend)
use "cohorts\bispho3yr_hes_opcs.dta", clear
merge m:1 opcs using "codes_7_opcs.dta"
keep if _merge==3
drop _merge
merge m:m patid using "osteo_excl_clean.dta", force
keep if _merge==3
drop _merge

gen temp = date(epiend,"DMY")
format temp %tdDD/NN/CCYY
drop epiend
rename temp epiend
order epiend, after(index_date)

gen days = epiend - index_date
gen weak_hes_opcs = 1 if (abs(days)<=90)
keep if weak_hes_opcs==1
rename epiend weak_hes_opcs_date

save "weak_hes_opcs.dta", replace

* CPRD obs (date = obsdate)
use "cohorts\bispho3yr_obs_cut.dta", clear
merge m:1 medcodeid using "codes_7_medcode.dta"
keep if _merge==3
drop _merge
merge m:m patid using "osteo_excl_clean.dta"
keep if _merge==3
drop _merge

gen temp = date(obsdate,"DMY")
format temp %tdDD/NN/CCYY
drop obsdate
rename temp obsdate
order obsdate, after(index_date)

gen days = obsdate - index_date
gen weak_cprd_med = 1 if (abs(days)<=90)
keep if weak_cprd_med==1
rename obsdate weak_cprd_date

save "weak_cprd_med.dta", replace

* CPRD drug issue (date = issuedate; prodcodes are weak only)
use "cohorts\bispho3yr_prod_cut.dta", clear
merge m:1 prodcodeid using "codes_7_prodcode.dta"
keep if _merge==3
drop _merge
merge m:m patid using "osteo_excl_clean.dta"
keep if _merge==3
drop _merge

gen temp = date(issuedate,"DMY")
format temp %tdDD/NN/CCYY
drop issuedate
rename temp issuedate
order issuedate, after(index_date)

gen days = issuedate - index_date
gen weak_cprd_prod = 1 if (abs(days)<=90)
keep if weak_cprd_prod==1
rename issuedate weak_cprd_prod_date

save "weak_cprd_prod.dta", replace

********************************************************
** Merge flags and classify
********************************************************
use "osteo_excl_clean.dta", clear

merge m:m patid using "strong_hes_icd.dta", nogenerate force
merge m:m patid using "strong_hes_opcs.dta", nogenerate force
merge m:m patid using "strong_cprd_med.dta", nogenerate force

merge m:m patid using "weak_hes_icd.dta", nogenerate force
merge m:m patid using "weak_hes_opcs.dta", nogenerate force
merge m:m patid using "weak_cprd_med.dta", nogenerate force
merge m:m patid using "weak_cprd_prod.dta", nogenerate force

foreach v in strong_hes_icd strong_hes_opcs strong_cprd_med ///
             weak_hes_icd weak_hes_opcs weak_cprd_med weak_cprd_prod {
    capture confirm variable `v'
    if _rc gen `v' = 0
    replace `v' = 0 if missing(`v')
}

gen strong_any = (strong_hes_icd==1 | strong_hes_opcs==1 | strong_cprd_med==1)
gen weak_any   = (weak_hes_icd==1   | weak_hes_opcs==1   | weak_cprd_med==1 | weak_cprd_prod==1)

gen outcome = 0
replace outcome = 1 if strong_any==1                  // Potential ONJ
replace outcome = 2 if outcome==0 & weak_any==1       // Possible ONJ

label define onj 0 "Not ONJ" 1 "Potential ONJ" 2 "Possible ONJ"
label values outcome onj
tab outcome

drop if outcome==0 //remove any patid with no linked support code// 

save "onj_potential.dta", replace

//We now have a pool of obs, multiple per patid, which need to be filtered for earliest index date with justification//
order strong_hes_date strong_hes_opcs_date strong_cprd_date weak_hes_date weak_hes_opcs_date weak_cprd_date weak_cprd_prod_date, after(first_bispho)

//Keep the earliest patid//
sort patid index_date
by patid: gen epi=_n
by patid: gen epiN=_N
by patid: keep if epi==1 //This will only keep the earliest index date record//
drop epi epiN

save "onj_final.dta", replace

