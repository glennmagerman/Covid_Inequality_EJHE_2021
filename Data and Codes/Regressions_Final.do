*-----------------------
* 1. groups of variables
*-----------------------
use $datapathraw\EJHE/DataandCodes/Dataset.dta, clear


// We create log variables
		foreach x in ReturnedHome Deaths Population {
		gen Log_`x' = ln(`x')
	}	

	
*--------------
* 2. Log Deaths
*--------------
// Regression results in Table 1 pag. 10. 
// Note that the dummy East is called North-East in Table 1, 2 and 3. The dummy Paris is called Ile-de-France in Table 1,2 and 3.  
reg Log_Deaths East Paris, robust
est store m1, title(Model 1) 
reg Log_Deaths East Paris Log_Population, robust
est store m2, title(Model 2) 			
reg Log_Deaths East Paris Log_Population Gini, robust 
est store m3, title(Model 3) 	
reg Log_Deaths East Paris Log_Population Gini Education, robust 	
est store m4, title(Model 4)  
reg Log_Deaths East Paris Log_Population Gini Education Doctors_Density, robust
est store m5, title(Model 5)

esttab m1 m2 m3 m4 m5 using Results.tex, cells("b(star label(Coef.))" se(par)) starlevels( * 0.10 ** 0.05 *** 0.010) stats(r2 r2_a N, labels(R^2 AdjustedR^2 "N")) legend posthead("") prefoot("") postfoot("Note: Robust standard errors clustered at the department level.") varwidth(16) style(fixed) title(Regression table: All\label{tab1})



	
*-----------------
* 2. Log Recovered
*-----------------
ren Log_ReturnedHome Log_Returned

// Regression results in Table 2 pag. 11. 
reg Log_Returned East Paris, robust
est store m1, title(Model 1)
reg Log_Returned East Paris Log_Population, robust
est store m2, title(Model 2) 
reg Log_Returned East Paris Log_Population Gini, robust
est store m3, title(Model 3) 
reg Log_Returned East Paris Log_Population Gini Education, robust
est store m4, title(Model 4)   
reg Log_Returned East Paris Log_Population Gini Education Doctors_Density, robust
est store m5, title(Model 5)  

esttab m1 m2 m3 m4 m5 using Results.tex, cells("b(star label(Coef.))" se(par)) starlevels( * 0.10 ** 0.05 *** 0.010) stats(r2 r2_a N, labels(R^2 AdjustedR^2 "N")) legend posthead("") prefoot("") postfoot("Note: Robust standard errors clustered at the department level.") varwidth(16) style(fixed) title(Regression table: All\label{tab1})



*--------------
* 3. Covariance
*-------------- 
use $datapathraw\EJHE/DataandCodes/Covariance.dta, clear
	
// We create log variables	
		foreach x in DV Population {
		gen Log_`x' = ln(`x')
	}	

// Regression results in Table 3 pag. 12.
reg Log_DV East##Dummy Paris##Dummy, robust cluster(Department)
est store m1, title(Model 1)
reg Log_DV East##Dummy Paris##Dummy c.Log_Population##Dummy, robust cluster(Department)
est store m2, title(Model 2)
reg Log_DV East##Dummy Paris##Dummy c.Log_Population##Dummy c.Gini##Dummy, robust cluster(Department)
est store m3, title(Model 3)
reg Log_DV East##Dummy Paris##Dummy c.Log_Population##Dummy c.Gini##Dummy c.Education##Dummy, robust cluster(Department)
est store m4, title(Model 4)
reg Log_DV East##Dummy Paris##Dummy c.Log_Population##Dummy c.Gini##Dummy c.Education##Dummy c.Doctors_Density##Dummy, robust cluster(Department)
est store m5, title(Model 5)


esttab m1 m2 m3 m4 m5 using Results.tex, cells("b(star label(Coef.))" se(par)) starlevels( * 0.10 ** 0.05 *** 0.010) stats(r2 r2_a N, labels(R^2 AdjustedR^2 "N")) legend posthead("") prefoot("") postfoot("Note: Robust standard errors clustered at the department level.") varwidth(16) style(fixed) title(Regression table: All\label{tab1})




*--------------
* 3. Maps
*-------------- 
// The following codes were used to obtain Figure 1 and Figure 2 on pages 8-9.
// The figures' sizes were adjusted by using the Graph Editor command.
clear
import excel $datapathraw\EJHE/DataandCodes/Maps.xls, sheet("Sheet1") firstrow
merge 1:1 ID_2 using francedb
drop _merge
spmap Deaths using francecoord if ID_2 !=41 & ID_2!=42, id(ID_2) fcolor(Reds)
graph save Graph $datapathraw\EJHE/DataandCodes/Map_Deaths.gph
clear

// LaTex export
clear
graph use $datapathraw\EJHE/DataandCodes/Map_Deaths.gph
graph export "Map_Deaths.eps", as(eps) replace
clear


clear
import excel $datapathraw\EJHE/DataandCodes/Maps.xls, sheet("Sheet1") firstrow
merge 1:1 ID_2 using francedb
drop _merge
spmap ReturnedHome using francecoord if ID_2 !=41 & ID_2!=42, id(ID_2) fcolor(Reds)
graph save Graph $datapathraw\EJHE/DataandCodes/Map_Discharged.gph
clear


clear
graph use $datapathraw\EJHE/DataandCodes/Map_Deaths.gph
graph export "Map_Discharged.eps", as(eps) replace
clear







