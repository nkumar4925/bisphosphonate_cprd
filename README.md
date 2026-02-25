# Code lists to ascertain fragility and atypical femoral fractures and analytic code for ONJ adjudication (CPRD/HES)

This repository contains:
- **Code lists** used to ascertain fragility fractures and atypical femoral fractures in CPRD and HES in CSV format.
- **Stata analytic scripts** used to derive outcomes and run ONJ ascertainment processing for 3-year and 5-year treatment cohorts, using the selection algorithm as developed by Persson et al (DOI: 10.1007/s00198-024-07262-7). Note that ONJ codelists are available from Persson et al in Supplement 1 and were replicated in our code. 

This repository does not include any patient-level CPRD/HES data. The Stata scripts reference dataset and variable names as found in a licensed CPRD/HES workspace and should be used appropriately.

## Source files
The original manuscript of this work is submitted for publication to BMJ Medicine and is entitled "Fragility fractures, atypical femoral fractures, and osteonecrosis of jaw after initial bisphosphonate treatment for 3 and 5 years: Linked English primary care, hospitalisation and mortality data" authored by: Georgina Nakafero, Tricia McKeever, Niraj S Kumar, Victoria Walsh, Sara Muller, Abhishek Abhishek. 
This repository is cited within the manuscript and serves as supplementary material.

## Contents

### Code lists (Table S1)
- `fragility_fractures_cprd_medcodes.csv`
- `fragility_fractures_icd10_codes.csv`
- `atypical_fractures_cprd_medcodes.csv`
- `atypical_fractures_icd10_codes.csv`
- `data_dictionary.csv` (columns and definitions)

The CSVs contain the codelists used to 

### Analytic code
- `00_setup.do` – sets the project directory
- `ONJanalysis_3yr.do` – 3-year treatment cohort workflow
- `ONJanalysis_5yr.do` – 5-year treatment cohort workflow

## How to run (licensed data users)

1. Download/clone this repository.
2. Open Stata.
3. Edit `code/00_setup.do` and set:
   - `global projectdir "PATH_TO_PROJECT"`
4. Run:
   - `do "code/00_setup.do"`
5. Then run:
   - `do "code/ONJanalysis_3yr.do"`
   - `do "code/ONJanalysis_5yr.do"`

## Data access
CPRD/HES data are not publicly shareable. Reproducing the full pipeline requires authorised access to CPRD and linked data, and an appropriate secure analysis environment. This authorisation is granted by application only.

## Licenses
- Code lists and documentation: see `LICENSE_CODELISTS.txt` (CC BY 4.0)

## Funding
This work was funded by the National Institute for Health and Care Research (NIHR) Research for Patient Benefit (RfPB) programme (Award: NIHR205348). The views expressed are those of the author(s) and not necessarily those of the NIHR or the Department of Health and Social Care.





