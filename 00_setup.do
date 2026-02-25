*******************************************************
* 00_setup.do
* Project setup for ONJ codelists + adjudication code
*
* 1) Set your local project directory path below
* 2) Keep the folder structure as in this repository
*******************************************************

clear all
set more off

* EDIT THIS LINE:
global projectdir "CHANGE_ME_TO_YOUR_LOCAL_PATH"

cd "$projectdir"

**Note you will need CPRD access and to have created a CPRD database of patients receiving oral bisphosphonates as specified in our manuscript.

**The files contained in the following do-file are created by merging the cohort of bisphosphonate patients with a CPRD extract containing all of the prior CPRD records or HES records for those patients. These are then labelled accordingly - for example bispho-3yr-hes contains patients prescribed bisphosphonates for 3 years, then merged back with the HES data linkage for those patients.  