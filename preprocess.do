
/*

							CODE
						PREPROCESSING
						
Timing of blood draws among hospitalized patients: 
An evaluation of the electronic health records from a large health care system 

Caraballo C, Mahajan S, Krumholz HM, et al.

This .do file uses the special marker **# to facilitate navigation through its contents


*/

u BLOOD_SPECIMEN_DATA_140715.dta, clear

**# time variables

gen double sample_taken = clock(specimentakendttm, "YMD hms" )
format sample_take %tc

replace admissiontime = subinstr(admissiontime, ".", "",.)
replace admissiontime = subinstr(admissiontime, ":000000000", "",.)
gen admission_dt = admissiondate + " " + admissiontime
gen double patient_admitted = clock(admission_dt, "YMD hm" )
format patient_admitted %tc
drop admission_dt

sort patient_admitted

replace dischargetime = subinstr(dischargetime, ".", "",.)
replace dischargetime = subinstr(dischargetime, ":000000000", "",.)
gen discharged_dt = dischargedate + " " + dischargetime
gen double patient_discharged = clock(discharged_dt, "YMD hm" )
format patient_discharged %tc
drop discharged_dt

replace specimentakentime = subinstr(specimentakentime, ":00.0000000", "",.)
gen drawdaymidnight = specimentakendate + " " + "00:00"
gen double drawday = clock(drawdaymidnight, "YMD hm" )
format drawday %tc

gen timing = clockdiff_frac(drawday, sample_taken, "hour")

drop drawday drawdaymidnight

replace specimentakendate = subinstr(specimentakendate, "-", "",.)
todate specimentakendate, p(yyyymmdd) gen(takendate)

gen year=year(takendate)

gen month=month(takendate)
gen month_frac=(month*30)/365

tostring year month, replace

gen yearmonth= year + "-" + month

generate monthly = monthly(yearmonth, "YM")
format monthly %tm

**# exclusions

drop if monthly==718 // deleting nov 2019 

** samples taken outside the hospitalization

keep if sample_taken >= patient_admitted & sample_taken <= patient_discharged

** samples taken within 24 hours of admission

gen interval_hours = clockdiff_frac(patient_admitted, sample_taken, "hour")

drop if interval_hours<24 

** samples taken in ICUs, EDs, step-down, etc

drop if department== "SRC CENTER 2 OBSERVATION OUTPATIENT" 
drop if department== "SRC SURGICAL INTENSIVE"
drop if department== "SRC VERDI 3 NORTH MICU"
drop if department== "SRC VERDI 3 WEST STEP DOWN"
drop if department== "YNH EMERGENCY ADULT"
drop if department== "YNH NP 10 MICU SD"
drop if department== "YNH NP 9 MICU"
drop if department== "YNH SP 51 CARDIAC ICU HVC"
drop if department== "YNH SP 61 SURGICAL ICU"
drop if department== "YNH SP 62 NEUROSURGERY ICU"
drop if department== "YNH WP 3 CARDIOTHORACIC ICU HVC"
drop if department== "YNH SP 71 SICU"
drop if department== "YNH SP 71 NEURO ICU"
drop if department== "YNH WP 7 PEDIATRIC INTENSIVE CARE"
drop if department== "YNH WP 10 NEONATAL ICU"

**# working variables

gen race_new=0
replace race_new=1 if race =="White or Caucasian"
replace race_new=3 if race =="Black or African American"
replace race_new=5 if race !="White or Caucasian" & race !="Black or African American"
replace race_new=7 if ethnicity=="Hispanic or Latino"
label var race_new "Race/Ethnicity"
label define race_new 1 "White" 3 "Black" 5 "Other" 7 "Latino/Hispanic"
label value race_new race_new
drop race ethnicity
rename race_new race

gen agecat=1
replace agecat=2 if age>35
replace agecat=3 if age>65
replace agecat=4 if age>85
label var agecat "Age category"
label define agecat 1 "18-35" 2 ">35-65" 3 ">65-85" 4 ">85"
label value agecat agecat


gen four_five=0
replace four_five=1 if timing >=4 & timing < 5

gen five_six=0
replace five_six=1 if timing >=5 & timing < 6

gen six_seven=0
replace six_seven=1 if timing >=6 & timing < 7

gen four_seven=0
replace four_seven=1 if timing >=4 & timing < 7

compress

save processed.dta,replace // contains all variables

drop birth_date admissiondate admissiontime dischargedate dischargetime department location principaldiagnosis dischargedisposition orderdescription specimentakendttm specimentakendate specimentakentime specimentype drawtype sample_taken patient_admitted patient_discharged interval_hours sleep_hours takendate year month month_frac yearmonth

save processed_for_analysis.dta,replace // contains only variables needed for the main analysis, smaller size file
