
/*
							
							CODE
					SUPPLEMENTAL ANALYSIS
						
Timing of blood draws among hospitalized patients: 
An evaluation of the electronic health records from a large health care system 

Caraballo C, Mahajan S, Krumholz HM, et al.

This .do file uses the special marker **# to facilitate navigation through its contents

*/

*******************************************************************************
*******************************************************************************
**# Morning samples distribution by patients' characteristics
*******************************************************************************
*******************************************************************************

u processed_for_analysis,clear
keep if four_seven==1 

** by sex/gender

mylabels 0(10)100, myscale(@/100) local(myla)
graph bar (mean) four_five five_six six_seven if gender!="Unknown" , stack ytitle("Proportion of early morning samples") ylabel(`myla') legend(order(1 "4:00 to 4:59" 2 "5:00 to 5:59" 3 "6:00 to 6:59") title("Timing")) blabel(bar,  position(inside) format(%4.2f)) xsize(3) ysize(4) by(gender, note(""))
graph save morning_samples_all_gender.gph,replace


** by race/ethnicity

mylabels 0(10)100, myscale(@/100) local(myla)
graph bar (mean) four_five five_six six_seven , stack ytitle("Proportion of early morning samples") ylabel(`myla') legend(order(1 "4:00 to 4:59" 2 "5:00 to 5:59" 3 "6:00 to 6:59") title("Timing")) blabel(bar,  position(inside) format(%4.2f)) xsize(3) ysize(4) by(race, note(""))
graph save morning_samples_all_race.gph,replace



** by age group

mylabels 0(10)100, myscale(@/100) local(myla)
graph bar (mean) four_five five_six six_seven, stack ytitle("Proportion of early morning samples") ylabel(`myla') legend(order(1 "4:00 to 4:59" 2 "5:00 to 5:59" 3 "6:00 to 6:59") title("Timing")) blabel(bar,  position(inside) format(%4.2f)) xsize(3) ysize(4) by(agecat, note(""))
graph save morning_samples_all_age.gph,replace

*******************************************************************************
*******************************************************************************
**# Timing distribution, histogram 24h, by patients' characteristics
*******************************************************************************
*******************************************************************************


** by sex/gender

u processed_for_analysis,clear
#delimit ;
histogram timing if gender!="Unknown", 
				xlabel( 
						0 "0:00" 	
						2 "2:00" 	
						4 "4:00" 	
						6 "6:00" 	
						8 "8:00" 	
						10 "10:00" 	
						12 "12:00" 	
						14 "14:00" 	
						16 "16:00" 	
						18 "18:00" 	
						20 "20:00" 	
						22 "22:00"	, 
						angle(45)
						
							) 
						
				ylabel(0(2)20) percent bin(24) xmtick(##2)  xtitle("Time of blood draw") 
					
		by(gender, legend(off) note(""))
		
		;
graph save timing_distribution_gender.gph,replace ;	
	
#delimit cr


** by race/ethnicity


u processed_for_analysis,clear

#delimit ;
histogram timing , 
				xlabel( 
						0 "0:00" 	
						2 "2:00" 	
						4 "4:00" 	
						6 "6:00" 	
						8 "8:00" 	
						10 "10:00" 	
						12 "12:00" 	
						14 "14:00" 	
						16 "16:00" 	
						18 "18:00" 	
						20 "20:00" 	
						22 "22:00"	, 
						angle(45)
						
							) 
						
				ylabel(0(2)20) percent bin(24) xmtick(##2)  xtitle("Time of blood draw") 
					
		by(race, legend(off) note(""))
		
		;
graph save timing_distribution_race.gph,replace ;	
	
#delimit cr


** by age group

u processed_for_analysis,clear

#delimit ;
histogram timing , 
				xlabel( 
						0 "0:00" 	
						2 "2:00" 	
						4 "4:00" 	
						6 "6:00" 	
						8 "8:00" 	
						10 "10:00" 	
						12 "12:00" 	
						14 "14:00" 	
						16 "16:00" 	
						18 "18:00" 	
						20 "20:00" 	
						22 "22:00"	, 
						angle(45)
						
							) 
						
				ylabel(0(2)20) percent bin(24) xmtick(##2)  xtitle("Time of blood draw") 
					
		by(agecat, legend(off) note(""))
		
		;
graph save timing_distribution_age.gph,replace ;	
	
#delimit cr


*******************************************************************************
*******************************************************************************
**# Trends figures by patients' characteristics
*******************************************************************************
*******************************************************************************

** by sex/gender

u processed_for_analysis, clear

keep if gender!="Unknown"

collapse (mean) four_five (mean) five_six (mean) six_seven, by(monthly gender)

#delimit ;
mylabels 0(5)50, myscale(@/100) local(myla);
twoway  
	(connected four_five monthly) 
	(connected five_six monthly) 
	(connected six_seven monthly) 
	,
	xlabel(682 "Nov 2016" 694 "Nov 2017" 706 "Nov 2018" 717 "Oct 2019", angle(45)) 
	ylabel(`myla') 
	xtitle("") 
	ytitle("% of all samples") 
	legend(order(1 "4:00 to 4:59" 2 "5:00 to 5:59" 3 "6:00 to 6:59") title("Timing", size(vsmall)) ring(0) pos(1) size(vsmall))
	
	by(gender, note("") legend(off))
	;
	
graph save figure_trends_four_seven_denom_all_gender.gph,replace ;

#delimit cr

u processed_for_analysis, clear

keep if four_seven==1 & gender!="Unknown"

collapse (mean) four_five (mean) five_six (mean) six_seven, by(monthly gender)

#delimit ;
mylabels 0(5)50, myscale(@/100) local(myla);
twoway  
	(connected four_five monthly) 
	(connected five_six monthly) 
	(connected six_seven monthly) 
	,
	xlabel(682 "Nov 2016" 694 "Nov 2017" 706 "Nov 2018" 717 "Oct 2019", angle(45)) 
	ylabel(`myla') 
	xtitle("") 
	ytitle("% of early morning samples") 
	legend(order(1 "4:00 to 4:59" 2 "5:00 to 5:59" 3 "6:00 to 6:59") title("Timing", size(vsmall)) ring(0) pos(1) size(vsmall))
	
	by(gender, note("") legend(off))
	;
	
graph save figure_trends_four_seven_denom_morning_gender.gph,replace ;

#delimit cr

graph combine figure_trends_four_seven_denom_all_gender.gph figure_trends_four_seven_denom_morning_gender.gph, row(2)

graph save figure_trends_four_seven_combined_gender.gph,replace

** by race/ethnicity

u processed_for_analysis, clear

collapse (mean) four_five (mean) five_six (mean) six_seven, by(monthly race)

#delimit ;
mylabels 0(5)50, myscale(@/100) local(myla);
twoway  
	(connected four_five monthly) 
	(connected five_six monthly) 
	(connected six_seven monthly) 
	,
	xlabel(682 "Nov 2016" 694 "Nov 2017" 706 "Nov 2018" 717 "Oct 2019", angle(45)) 
	ylabel(`myla') 
	xtitle("") 
	ytitle("% of all samples") 
	legend(order(1 "4:00 to 4:59" 2 "5:00 to 5:59" 3 "6:00 to 6:59") title("Timing", size(vsmall)) ring(0) pos(1) size(vsmall))
	
	by(race, note("") legend(off))
	;
	
graph save figure_trends_four_seven_denom_all_race.gph,replace ;

#delimit cr

u processed_for_analysis, clear

keep if four_seven==1 

collapse (mean) four_five (mean) five_six (mean) six_seven, by(monthly race)

#delimit ;
mylabels 0(5)50, myscale(@/100) local(myla);
twoway  
	(connected four_five monthly) 
	(connected five_six monthly) 
	(connected six_seven monthly) 
	,
	xlabel(682 "Nov 2016" 694 "Nov 2017" 706 "Nov 2018" 717 "Oct 2019", angle(45)) 
	ylabel(`myla') 
	xtitle("") 
	ytitle("% of early morning samples") 
	legend(order(1 "4:00 to 4:59" 2 "5:00 to 5:59" 3 "6:00 to 6:59") title("Timing", size(vsmall)) ring(0) pos(1) size(vsmall))
	
	by(race, note("") legend(off))
	;
	
graph save figure_trends_four_seven_denom_morning_race.gph,replace ;

#delimit cr

graph combine figure_trends_four_seven_denom_all_race.gph figure_trends_four_seven_denom_morning_race.gph, row(2)

graph save figure_trends_four_seven_combined_race.gph,replace

** by age groups

u processed_for_analysis, clear

collapse (mean) four_five (mean) five_six (mean) six_seven, by(monthly agecat)

#delimit ;
mylabels 0(5)50, myscale(@/100) local(myla);
twoway  
	(connected four_five monthly) 
	(connected five_six monthly) 
	(connected six_seven monthly) 
	,
	xlabel(682 "Nov 2016" 694 "Nov 2017" 706 "Nov 2018" 717 "Oct 2019", angle(45)) 
	ylabel(`myla') 
	xtitle("") 
	ytitle("% of all samples") 
	legend(order(1 "4:00 to 4:59" 2 "5:00 to 5:59" 3 "6:00 to 6:59") title("Timing", size(vsmall)) ring(0) pos(1) size(vsmall))
	
	by(agecat, note("") legend(off))
	;
	
graph save figure_trends_four_seven_denom_all_agecat.gph,replace ;

#delimit cr

u processed_for_analysis, clear

keep if four_seven==1 

collapse (mean) four_five (mean) five_six (mean) six_seven, by(monthly agecat)

#delimit ;
mylabels 0(5)50, myscale(@/100) local(myla);
twoway  
	(connected four_five monthly) 
	(connected five_six monthly) 
	(connected six_seven monthly) 
	,
	xlabel(682 "Nov 2016" 694 "Nov 2017" 706 "Nov 2018" 717 "Oct 2019", angle(45)) 
	ylabel(`myla') 
	xtitle("") 
	ytitle("% of early morning samples") 
	legend(order(1 "4:00 to 4:59" 2 "5:00 to 5:59" 3 "6:00 to 6:59") title("Timing", size(vsmall)) ring(0) pos(1) size(vsmall))
	
	by(agecat, note("") legend(off))
	;
	
graph save figure_trends_four_seven_denom_morning_agecat.gph,replace ;

#delimit cr

graph combine figure_trends_four_seven_denom_all_agecat.gph figure_trends_four_seven_denom_morning_agecat.gph, row(2)

graph save figure_trends_four_seven_combined_agecat.gph,replace

