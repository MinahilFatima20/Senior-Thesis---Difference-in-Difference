
* Purpose : Diff-in-Diff Analysis - SPROJ
* Date    : 21st May, 2022
* Author  : Minahil Fatima 

 	clear all
	set more off
	

	* Importing Data 

		import excel "/Users/minahilfatima/Documents/SPROJ/Final Merge copy.xlsx", sheet("Sheet1") firstrow

	* Creating Variables of Interest 
	
		encode District, generate(district)
		drop if Year ==.
		
		gen prop_Murder = Murder/AllAtempted
		gen prop_Attempted_Murder = Attempted_Murder/AllAtempted
		gen prop_Simple_Hurt_Cases = Simple_Hurt_Cases/AllAtempted
		gen prop_Rioting = Rioting/AllAtempted
		gen prop_Assault_on_Public_Servant = Assault_on_Public_Servant/AllAtempte
		gen prop_Rape_or_Zina_Ordinance = Rape_or_Zina_Ordinance/AllAtempted
		gen prop_Kidnapping_Abduction = Kidnapping_Abduction/AllAtempted
		gen prop_Other_Dacoity = Other_Dacoity/AllAtempted
		gen prop_Other_Robery = Other_Robery/AllAtempted
		gen prop_Burglary = Burglary/AllAtempted
		gen prop_Vehicle_Theft = Vehicle_Theft/AllAtempted
		gen prop_Cattle_Theft = Cattle_Theft/AllAtempted
		gen prop_Other_Ordinary_Theft = Other_Ordinary_Theft/AllAtempted
		gen prop_Miscellaneous_Cases = Miscellaneous_Cases/AllAtempted
		gen prop_MISC = MISC/AllAtempted
	
		local variables "AllAtempted Murder Attempted_Murder Simple_Hurt_Cases Rioting Assault_on_Public_Servant Rape_or_Zina_Ordinance Kidnapping_Abduction Other_Dacoity Other_Robery Burglary Vehicle_Theft Cattle_Theft Other_Ordinary_Theft Miscellaneous_Cases MISC"
	
		foreach i of local variables{
			bysort Year: egen total_`i' = total(`i')
			}
	
		local var2 " total_Murder total_Attempted_Murder total_Simple_Hurt_Cases total_Rioting total_Rape_or_Zina_Ordinance total_Kidnapping_Abduction total_Other_Dacoity total_Other_Robery total_Burglary total_Vehicle_Theft total_Cattle_Theft total_Other_Ordinary_Theft total_Miscellaneous_Cases total_MISC"
		
		foreach i of local var2{
			gen yp_`i' = `i'/total_AllAtempted
			}
		
		gen exposure_index = (inter_pass + prop_currentlymarried + prop_divorced + prop_urban + prop_television + prop_radio + prop_mobile + prop_computer + prop_b2)/9
		
		egen sd_exposure_index = std(exposure_index)
		
		gen Time = 1 if Year > 2012
		replace Time = 0 if Year <= 2012
		
	local variables "inter_pass prop_currentlymarried prop_divorced prop_urban prop_television prop_radio prop_mobile prop_computer prop_b2"
	
		foreach i of local variables{
			  egen std_`i' = std(`i')
			}
	
			
		gen expt = sd_exposure_index*Time 
		gen expt1 = std_inter_pass*Time
		gen expt2 = std_prop_currentlymarried*Time
		gen expt3 = std_prop_divorced*Time
		gen expt4 = std_prop_urban*Time
		gen expt5 = std_prop_television*Time
		gen expt6 = std_prop_radio*Time
		gen expt7 = std_prop_mobile*Time
		gen expt8 = std_prop_computer*Time
		gen expt9 = std_prop_b2*Time
		
		gen Intensity_Exposure=1 if sd_exposure_index<=   -.736662 
		replace Intensity_Exposure=2 if sd_exposure_index>   -.736662   & sd_exposure_index<= -.1751293 
		replace Intensity_Exposure=3 if sd_exposure_index>  -.1751293   & sd_exposure_index<=   .504433   
		replace Intensity_Exposure=4 if sd_exposure_index>   .504433  
		
	ren Assault_on_Public_Servant Assault_PublicServant
	ren Rape_or_Zina_Ordinance Rape
	
	local variables "AllAtempted Murder Attempted_Murder Simple_Hurt_Cases Rioting Assault_PublicServant Rape Kidnapping_Abduction Other_Dacoity Other_Robery Burglary Vehicle_Theft Cattle_Theft Other_Ordinary_Theft Miscellaneous_Cases MISC"
	
		foreach i of local variables{
			  gen `i'_rate = (`i'/population)*100000
			}
	
	
	*gen Rape_rate = (Rape/Population_Fem)*100000
	
			local variables "AllAtempted_rate Murder_rate Attempted_Murder_rate Simple_Hurt_Cases_rate Rioting_rate Assault_PublicServant_rate Rape_rate Kidnapping_Abduction_rate Other_Dacoity_rate Other_Robery_rate Burglary_rate Vehicle_Theft_rate Cattle_Theft_rate Other_Ordinary_Theft_rate Miscellaneous_Cases_rate MISC_rate"
			foreach i of local variables{
			   egen sd_`i' = std(`i')
			}
		
	local variables "AllAtempted_rate Murder_rate Attempted_Murder_rate Simple_Hurt_Cases_rate Rioting_rate Assault_PublicServant_rate Rape_rate Kidnapping_Abduction_rate Other_Dacoity_rate Other_Robery_rate Burglary_rate Vehicle_Theft_rate Cattle_Theft_rate Other_Ordinary_Theft_rate Miscellaneous_Cases_rate MISC_rate"
	
		foreach i of local variables{
			  bysort Year: egen t1_`i' = total(`i') if Intensity_Exposure == 1  
			}
			
		local variables "AllAtempted_rate Murder_rate Attempted_Murder_rate Simple_Hurt_Cases_rate Rioting_rate Assault_PublicServant_rate Rape_rate Kidnapping_Abduction_rate Other_Dacoity_rate Other_Robery_rate Burglary_rate Vehicle_Theft_rate Cattle_Theft_rate Other_Ordinary_Theft_rate Miscellaneous_Cases_rate MISC_rate"
	
		foreach i of local variables{
			  bysort Year: egen t2_`i' = total(`i') if Intensity_Exposure == 2
			}
			
			
			local variables "AllAtempted_rate Murder_rate Attempted_Murder_rate Simple_Hurt_Cases_rate Rioting_rate Assault_PublicServant_rate Rape_rate Kidnapping_Abduction_rate Other_Dacoity_rate Other_Robery_rate Burglary_rate Vehicle_Theft_rate Cattle_Theft_rate Other_Ordinary_Theft_rate Miscellaneous_Cases_rate MISC_rate"
	
		foreach i of local variables{
			  bysort Year: egen t3_`i' = total(`i') if Intensity_Exposure == 3
			}
			
			local variables "AllAtempted_rate Murder_rate Attempted_Murder_rate Simple_Hurt_Cases_rate Rioting_rate Assault_PublicServant_rate Rape_rate Kidnapping_Abduction_rate Other_Dacoity_rate Other_Robery_rate Burglary_rate Vehicle_Theft_rate Cattle_Theft_rate Other_Ordinary_Theft_rate Miscellaneous_Cases_rate MISC_rate"
	
		foreach i of local variables{
			  bysort Year: egen t4_`i' = total(`i') if Intensity_Exposure == 4  
			}
			
		
	* Running Diff-in-Diff --> THIS DIFF-IN-DIFF RESULT IS BEING INTERPRETED
	
		didregress (sd_Rape_rate) (expt, continuous), group (district) time(Year)
		
	* Linear Regression With Robust Standard errors 
	
		reg sd_Rape_rate expt i.district i.Year, vce(robust)
		
	* Linear Regression With A Large Dummy-Variable Set
	
		areg sd_Rape_rate expt i.district, absorb(Year) cluster(Year)
			
	* Clustered Stadnard Errors	
	
		didregress (sd_Rape_rate) (expt, continuous), group (district) time(Year)
		
	* Robust Standard Errors
	
		didregress (sd_Rape_rate) (expt, continuous), group (district) time(Year) vce(r) 
	
	* DiD on Individual Components of Exposure Index 
	
		didregress (sd_Rape_rate) (expt, continuous), group (district) time(Year)
		didregress (sd_Rape_rate) (expt1, continuous), group (district) time(Year) // inter pass s
		didregress (sd_Rape_rate) (expt2, continuous), group (district) time(Year) // currently married ns
		didregress (sd_Rape_rate) (expt3, continuous), group (district) time(Year) // divorced s 
		didregress (sd_Rape_rate) (expt4, continuous), group (district) time(Year) // urban s
		didregress (sd_Rape_rate) (expt5, continuous), group (district) time(Year) // television s
		didregress (sd_Rape_rate) (expt6, continuous), group (district) time(Year) // radio ns
		didregress (sd_Rape_rate) (expt7, continuous), group (district) time(Year) // mobile s
		didregress (sd_Rape_rate) (expt8, continuous), group (district) time(Year) // computer s
		didregress (sd_Rape_rate) (expt9, continuous), group (district) time(Year) // young population s
		
		
********************* event study *****************

		*drop if Year == 2007 | Year == 2006 

		reghdfe sd_Rape_rate c.exposure_index#c.Time, absorb(District Year) vce(cl District)
		reghdfe sd_Rape_rate c.exposure_index##ib(2012).Year, absorb(district Year) vce(cl district)

		mat results = r(table)["b", "2006.Year#c.exposure_index".."2017.Year#c.exposure_index"] \ r(table)["ll".."ul", "2006.Year#c.exposure_index".."2017.Year#c.exposure_index"]              
		mat results = results'
		svmat results, n(col)
		gen t = _n + 2005 if !mi(b)
		twoway connected b t || rcap ll ul t, yline(0,lp(dash)) ytitle("Coefficients and 95% CI")  xlab(2006(1)2017) xtitle("Year") leg(off)  title(Event Study Graph, color(black) ring(0) position(12)) note(Source: Punjab Development Statistics, color(black))graphregion(color(white)) 	
			 

		reghdfe sd_Rape_rate c.exposure_index#c.Time c.exposure_index#c.Year, absorb(District Year) vce(cl District)
		
*******************Binary Treatment*****************************

		gen treat = (exposure_index >= .3002342 & Year >2012)
		
		gen treat2 = (exposure_index >= .3002342)
		
		didregress (sd_Rape_rate) (treat), group (district) time(Year) vce(r) 
		didregress (sd_Rape_rate) (treat), group (district) time(Year) vce(cl district) 
		
		estat trendplots, graphregion(color(white))
		estat ptrends
		estat granger
		
*****************STATA MAPS*************************************


	* Importing Data 

		import excel "Exposure Index.xlsx", sheet("Sheet1") firstrow

	* Creating Variables of Interest 
	
		encode District, generate(district)
		drop if Year ==.
		
		gen exposure_index = (inter_pass + prop_currentlymarried + prop_divorced + prop_urban + prop_television + prop_radio + prop_mobile + prop_computer + prop_b2)/9
		

	* Constructing Exposure Index Brakets

		gen Intensity_Exposure=1 if exposure_index<=.2774051  
		replace Intensity_Exposure=2 if exposure_index>.2774051   & exposure_index<=  .3002342 
		replace Intensity_Exposure=3 if exposure_index> .3002342 & exposure_index<=.3462833 
		replace Intensity_Exposure=4 if exposure_index>.3462833 & exposure_index <=.424  
		
	* Merging File 
	
		merge 1:1 district using usdb2
		
	* Gegerating Maps 
	
		* Main Exposure Index Map
			
			spmap exposure_index using uscoord2, id(id2) fcolor(Blues) title(Exposure Index Geographic Spread, color(black) ring(0) position(12))
			
		* Compoenents of Exposure Index - Maps 
	
		spmap inter_pass using uscoord2 if district !=1 & district!=35, id(id2) fcolor(Blues)title(Education Geographic Spread, color(black) ring(0) position(12))
		
		spmap prop_currentlymarried using uscoord2 if district !=1 & district!=35, id(id2) fcolor(Blues)title(Currently Married Proportion Geographic Spread, color(black) ring(0) position(12))
		spmap prop_divorced using uscoord2 if district !=1 & district!=35, id(id2) fcolor(Blues)title(Divorced Proportion Geographic Spread, color(black) ring(0) position(12))
		
		spmap prop_urban using uscoord2 if district !=1 & district!=35, id(id2) fcolor(Blues)title(Urban Population Geographic Spread, color(black) ring(0) position(12))
		
		spmap prop_television using uscoord2 if district !=1 & district!=35, id(id2) fcolor(Blues)title(Proportion of Television Geographic Spread, color(black) ring(0) position(12))
		
		spmap prop_radio using uscoord2 if district !=1 & district!=35, id(id2) fcolor(Blues)title(Proportion of Radio Geographic Spread, color(black) ring(0) position(12))
		
		spmap prop_mobile using uscoord2 if district !=1 & district!=35, id(id2) fcolor(Blues)title(Proportion of Mobile Geographic Spread, color(black) ring(0) position(12))
		
		spmap prop_computer using uscoord2 if district !=1 & district!=35, id(id2) fcolor(Blues)title(Proportion of Computer Geographic Spread, color(black) ring(0) position(12))
		
		spmap prop_b2 using uscoord2 if district !=1 & district!=35, id(id2) fcolor(Blues)title(Proportion of Young population Geographic Spread, color(black) ring(0) position(12))
	


		
		
		
		
		
	