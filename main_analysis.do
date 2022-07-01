
/*

							CODE
						MAIN ANALYSIS
						
Timing of blood draws among hospitalized patients: 
An evaluation of the electronic health records from a large health care system 

Caraballo C, Mahajan S, Krumholz HM, et al.

This .do file uses the special marker **# to facilitate navigation through its contents


*/


u processed_for_analysis,clear

tab four_seven,m

foreach K in four_five five_six six_seven four_seven {
	
	tab `K' race , chi2 col
	tab `K' agecat , chi2 col
	tab `K' gender if gender!="Unknown", chi2 col
	
}

********************************************************************************
********************************************************************************
**# Table and timing distribution, denominator is those between 4 and 7
********************************************************************************
********************************************************************************

tabstat timing if four_seven==1, s(p25 p50 p75 mean sd) 
tabstat timing if four_seven==1, s(p25 p50 p75 mean sd) by(race)
tabstat timing if four_seven==1, s(p25 p50 p75 mean sd) by(gender)
tabstat timing if four_seven==1, s(p25 p50 p75 mean sd) by(agecat)

kwallis timing if four_seven==1, by(race)
kwallis timing if four_seven==1, by(agecat)
kwallis timing if gender!="Unknown" & four_seven==1, by(gender)

foreach K in four_five five_six six_seven  {
	
	tab `K' race if four_seven==1, chi2 col
	tab `K' agecat if four_seven==1, chi2 col
	tab `K' gender if gender!="Unknown" & four_seven==1, chi2 col
	
}

tab four_five if four_seven==1
tab five_six if four_seven==1
tab six_seven if four_seven==1

********************************************************************************
********************************************************************************
**# % at the beginning and end of the study
********************************************************************************
********************************************************************************

foreach K in four_seven four_five five_six six_seven  {
disp "`K' in Nov 2016, percent of all"
tabstat `K' if monthly==682, s(mean sd sem)

disp "`K' in Oct 2019, percent of all"
tabstat `K' if monthly==717, s(mean sd sem)
}

foreach K in four_five five_six six_seven  {
disp "`K' in Nov 2016, percent of 4-7"
tabstat `K' if monthly==682 & four_seven==1, s(mean sd sem)

disp "`K' in Oct 2019, percent of 4-7"
tabstat `K' if monthly==717 & four_seven==1, s(mean sd sem)
}

********************************************************************************
********************************************************************************
**# Trends and change. Denominator: all samples.
********************************************************************************
********************************************************************************

u processed_for_analysis,clear

#delimit ;

collapse  	(mean) four_seven (semean) four_seven_se=four_seven 
			(mean) four_five (semean) four_five_se=four_five
			(mean) five_six (semean) five_six_se=five_six
			(mean) six_seven (semean) six_seven_se=six_seven

			
			, by(monthly)
			;
#delimit cr

save file_monthly_rates_all,replace

** trends, ARIMA

u file_monthly_rates_all, clear

tsset monthly


foreach K in four_seven four_five five_six six_seven  {
arima `K' monthly, ar(1) nolog 

}

** change, proportion of all

u file_monthly_rates_all, clear

keep if inlist(monthly,682,717)
sort monthly


foreach K in four_seven four_five five_six six_seven  {

local zcrit=invnorm(.975)

noi disp " ******** diff in `K', proportion of all"
    local diff=`K'[2]-`K'[1]         
    local SE = sqrt(`K'_se[2]^2+`K'_se[1]^2)
    local lb=`diff'-`zcrit'*`SE'
    local ub=`diff'+`zcrit'*`SE'
    local Pval=(2*(1-normal(abs(`diff'/`SE'))))
    local Pval=cond(`Pval'<0.001,"<0.001",string(`Pval',"%5.3f"))
    noi di "`R'" _col(20) %5.2f `diff'*100 _col(30) "(" %5.2f `lb'*100 "," %5.2f `ub'*100 ")" _col(50) "`Pval'"
}

********************************************************************************
********************************************************************************
**# Trends and change. Denominator: early morning samples
********************************************************************************
********************************************************************************

u processed_for_analysis,clear
keep if four_seven==1

sort monthly

#delimit ;

collapse  	(mean) four_five (semean) four_five_se=four_five
			(mean) five_six (semean) five_six_se=five_six
			(mean) six_seven (semean) six_seven_se=six_seven
			
			, by(monthly)
			;
#delimit cr

save file_monthly_rates_morning,replace

** trends, ARIMA
u file_monthly_rates_morning, clear

tsset monthly


foreach K in four_five five_six six_seven  {
arima `K' monthly, ar(1) nolog 

}

**# change, proportion early morning
keep if inlist(monthly,682,717)
foreach K in four_five five_six six_seven  {

local zcrit=invnorm(.975)

noi disp " ******** diff in `K', proportion of 4-7"
    local diff=`K'[2]-`K'[1]         
    local SE = sqrt(`K'_se[2]^2+`K'_se[1]^2)
    local lb=`diff'-`zcrit'*`SE'
    local ub=`diff'+`zcrit'*`SE'
    local Pval=(2*(1-normal(abs(`diff'/`SE'))))
    local Pval=cond(`Pval'<0.001,"<0.001",string(`Pval',"%5.3f"))
    noi di "`R'" _col(20) %5.2f `diff'*100 _col(30) "(" %5.2f `lb'*100 "," %5.2f `ub'*100 ")" _col(50) "`Pval'"
}

log close

********************************************************************************
********************************************************************************
**# FIGURES
********************************************************************************
********************************************************************************


**# Histogram


u processed_for_analysis,clear
#delimit ;
histogram timing, 
				xlabel( 
						0 "0:00" 	1 "1:00"
						2 "2:00" 	3 "3:00"
						4 "4:00" 	5 "5:00"
						6 "6:00" 	7 "7:00"
						8 "8:00" 	9 "9:00"
						10 "10:00" 	11 "11:00"
						12 "12:00" 	13 "13:00"
						14 "14:00" 	15 "15:00"
						16 "16:00" 	17 "17:00"
						18 "18:00" 	19 "19:00"
						20 "20:00" 	21 "21:00"
						22 "22:00"	23 "23:00", 
						angle(45)
						
							) 
						
				ylabel(0(2)20) percent bin(24) xmtick(##2)  xtitle("Time of blood draw") 
					
		addlabel addlabopts(mlabangle(h) yvarformat(%2.1f)) ;
graph save timing_distribution.gph,replace ;	
	
#delimit cr



**# morning samples distribution by categories

u processed_for_analysis,clear
keep if four_seven==1 

** overall

mylabels 0(10)100, myscale(@/100) local(myla)
graph bar (mean) four_five five_six six_seven  , stack ytitle("Proportion of early morning samples") ylabel(`myla') legend(order(1 "4:00 to 4:59" 2 "5:00 to 5:59" 3 "6:00 to 6:59") title("Timing")) blabel(bar,  position(inside) format(%4.2f)) xsize(3) ysize(4)
graph save morning_samples_all.gph,replace


**# Figure trends, combined

u processed_for_analysis, clear

collapse (mean) four_five (mean) five_six (mean) six_seven, by(monthly)

#delimit ;
mylabels 0(5)50, myscale(@/100) local(myla);
twoway  
	(connected four_five monthly) 
	(connected five_six monthly) 
	(connected six_seven monthly) 
	,
	xlabel(682 "Nov 2016" 688 "May 2017" 694 "Nov 2017" 700 "May 2018" 706 "Nov 2018" 712 "May 2019" 717 "Oct 2019") 
	ylabel(`myla') 
	xtitle("") 
	ytitle("% of all samples") 
	legend(order(1 "4:00 to 4:59" 2 "5:00 to 5:59" 3 "6:00 to 6:59") title("Timing") ring(0) pos(1))
	;
	
graph save figure_trends_four_seven_denom_all.gph,replace ;

#delimit cr


u processed_for_analysis, clear
keep if four_seven==1 
collapse (mean) four_five (mean) five_six (mean) six_seven, by(monthly)

#delimit ;
mylabels 0(5)50, myscale(@/100) local(myla);
twoway  
	(connected four_five monthly) 
	(connected five_six monthly) 
	(connected six_seven monthly) 
 
	,
	xlabel(682 "Nov 2016" 688 "May 2017" 694 "Nov 2017" 700 "May 2018" 706 "Nov 2018" 712 "May 2019" 717 "Oct 2019") 
	ylabel(`myla') 
	xtitle("") 
	ytitle("% of early morning samples") 
	legend(off)
	;
	
graph save figure_trends_four_seven_denom_morning.gph,replace ;

#delimit cr

graph combine figure_trends_four_seven_denom_all.gph figure_trends_four_seven_denom_morning.gph, row(2)

graph save figure_trends_four_seven_combined.gph,replace
