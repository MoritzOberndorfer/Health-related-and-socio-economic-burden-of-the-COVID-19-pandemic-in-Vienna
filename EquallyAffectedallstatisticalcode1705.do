******************** Equally affected analysis *******************
clear all
cd"D:\PhD Owncloud\SORA Corona paper"
use "D:\PhD Owncloud\SORA Corona paper\SORA_raw.dta"
do "D:\PhD Owncloud\SORA Corona paper\data prep 0307 clean"

********************************************************************
********************** sampling weights (?)*************************

svyset [pweight=gewfin]

********************************************************************
********************** Descriptives ********************************
**** used only cases for who reported information on adversities, SEP, gender, age for the main analysis
count if SEP_cat_2==.
count if education==.
count if hh_inc_equi_quintile==.
count if overcrowding==.
count if adversities==.
count if gender==.
count if age==.
count if SP==.
count if mig_dummy==.
count if occ_pos_model4==.




/**** Table 1 sample characteristics*****
svy: tab SEP_cat_2 if SEP_cat_2!=. & age!=., count cell 
svy: tab education if SEP_cat_2!=. & age!=., count cell
svy: tab hh_inc_equi_quintile if SEP_cat_2!=. & age!=., count cell
svy: tab overcrowding if SEP_cat_2!=. & age!=., count cell
svy: tab occ_pos_model4 if SEP_cat_2!=. & age!=., count cell
svy: tab occ_pos_model4 if SEP_cat_2!=. & age!=., count cell missing
svy: tab gender if SEP_cat_2!=. & age!=., count cell
svy: mean age if SEP_cat_2!=. & age!=.
svy: tab SP if SEP_cat_2!=. & age!=., count cell
svy: tab mig_dummy if SEP_cat_2!=. & age!=., count cell
*/
**** Table 1 sample characteristics REVISED*****
svy: tab SEP_cat_2 , count cell missing
svy: tab education , count cell missing
svy: tab hh_inc_equi_quintile , count cell missing
svy: tab overcrowding , count cell missing
svy: tab occ_pos_rev , count cell missing
svy: tab gender , count cell missing
svy: mean age
svy: tab SP , count cell missing
svy: tab mig_dummy_2, count cell missing


/***Table 2 adversities **************
svy: mean adversities if SEP_cat_2!=. & age!=.
svy: tab advers_fin if SEP_cat_2!=. & age!=., count cell
svy: tab advers_jobloss if SEP_cat_2!=. & age!=., count cell
svy: tab advers_shortwork  if SEP_cat_2!=. & age!=., count cell
svy: tab advers_psy if SEP_cat_2!=. & age!=., count cell
svy: tab advers_phy if SEP_cat_2!=. & age!=., count cell
svy: tab advers_worry_infect if SEP_cat_2!=. & age!=., count cell
svy: tab advers_worry_close_infect if SEP_cat_2!=. & age!=., count cell
svy: tab advers_covid if SEP_cat_2!=. & age!=., count cell
svy: tab advers_covid_close if SEP_cat_2!=. & age!=., count cell
svy: tab advers_stress if SEP_cat_2!=. & age!=., count cell
*/
***Table 2 adversities REVISED **************
svy: mean adversities 
svy: tab advers_fin , count cell
svy: tab advers_jobloss , count cell
svy: tab advers_shortwork  , count cell
svy: tab advers_psy , count cell
svy: tab advers_phy , count cell
svy: tab advers_stress , count cell
svy: tab advers_covid, count cell
svy: tab advers_covid_close , count cell
svy: tab advers_worry_infect , count cell
svy: tab advers_worry_close_infect, count cell


********************************************************************
*********************** Zero-inflated Poisson Models ***************
************************* SEP models ********************************
* Figure 1 - predicted number of events by SEP unadjusted and adjusted for gender and age - using sampling weights 

svy: zip adversities i.SEP_cat_2, irr inflate(infl_dummy)
margins SEP_cat_2
marginsplot, recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) name(zip_unadj) ytitle("Predicted number of experienced adversities") xtitle("Socioeconomic position") title("Unadjusted prediction of adverse experiences" "by SEP with 95% CIs")

svy: zip adversities i.SEP_cat_2 i.gender age, irr inflate(infl_dummy)
margins SEP_cat_2
marginsplot, recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) name(zip_adj) ytitle("Predicted number of experienced adversities") xtitle("Socioeconomic position") title("Adjusted prediction of adverse experiences" "by SEP with 95% CIs")

graph combine zip_unadj  zip_adj, col(2) ycommon xcommon ysize(5.5) xsize(11) graphregion(color(white))
*adjust manually*

****Post estimation contrast to test whether effects of SEP differ**
*test if SEP_cat_2 =1 differs from 2, 3,4 
contrast {SEP_cat_2 -1 1 0 0} {SEP_cat_2 -1 0 1 0} {SEP_cat_2 -1 0 0 1}, effects
* No stat. sign difference from 2, but 3 and 4


*test if SEP_cat_2 =2 differs from 1, 3,4 
contrast {SEP_cat_2 1 -1 0 0} {SEP_cat_2 0 -1 1 0} {SEP_cat_2 0 -1 0 1}, effects

contrast {SEP_cat_2 1 0 -1 0} {SEP_cat_2 0 1 -1 0} {SEP_cat_2 0 0 -1 1}, effects

contrast {SEP_cat_2 1 0 0 -1} {SEP_cat_2 0 1 0 -1} {SEP_cat_2 0 0 1 -1}, effects

*** contrast 1+2 with 3+4 ***

contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects
contrast {SEP_cat_2 -0.5 -0.5 0.5 0.5}, effects

pwcompare SEP_cat_2, mcompare(bon) effects group

contrast h.SEP_cat_2, effects
contrast j.SEP_cat_2, effects



*****************************************************************
*********************** Zero-inflated Poisson Models ************
*********************** Table 3**********************************
* Table 3 - ZIP models using SEP (Model 1), Income (Model 2), Education (3), Occupational position (Model) to predict adversities - unadjusted / adjusted - weighted

*Model 1
svy: zip adversities i.SEP_cat_2 i.gender age, irr inflate(infl_dummy)

*Model 2
svy: zip adversities i.hh_inc_equi_quintile i.gender age, irr inflate(infl_dummy)

*Model 3
svy: zip adversities i.education i.gender age, irr inflate(infl_dummy)

*Model 4 (inflation weaker because of restricted sample)
svy: zip adversities i.occ_pos_model4 i.gender age, irr inflate(infl_dummy)

*Model 5 occ_pos with self_employed (=5)
svy: zip adversities i.occ_pos_model i.gender age, irr inflate(infl_dummy)
*doesn't change anything. all categories have around 0.8 IRR (unskilled = ref)
***put manually into tables************


*****************************************************************
*********************** LOGIT  Models **************************
*************** FIgure 2 adjusted OR for each adversity *********

svy: logit advers_fin i.SEP_cat_2 i.gender age, or
margins SEP_cat_2
marginsplot, name(advers_fin) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Financial situation worsened") ytitle("") xtitle("Socioeconomic position")

contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects


svy: logit advers_jobloss i.SEP_cat_2 i.gender age, or
margins SEP_cat_2
marginsplot, name(advers_jobloss) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Job loss") ytitle("") xtitle("Socioeconomic position")

contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects

svy: logit advers_shortwork i.SEP_cat_2 i.gender age, or
margins SEP_cat_2
marginsplot, name(advers_shortwork) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Short work") ytitle("") xtitle("Socioeconomic position")

contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects

svy: logit advers_psy i.SEP_cat_2 i.gender age, or
margins SEP_cat_2
marginsplot, name(advers_psy) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Mental health worsened") ytitle("") xtitle("Socioeconomic position")

contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects


svy: logit advers_phy i.SEP_cat_2 i.gender age, or
margins SEP_cat_2
marginsplot, name(advers_phy) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Physical health worsened") ytitle("") xtitle("Socioeconomic position")

contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects


svy: logit advers_worry_infect i.SEP_cat_2 i.gender age, or
margins SEP_cat_2
marginsplot, name(advers_worry_infect) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Very/quite worried" "to get infected with COVID-19") ytitle("") xtitle("Socioeconomic position")

contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects


svy: logit advers_worry_close_infect i.SEP_cat_2 i.gender age, or
margins SEP_cat_2
marginsplot, name(advers_worry_close_infect) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Very/quite worried someone close" "gets infected with COVID-19") ytitle("") xtitle("Socioeconomic position")

contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects


svy: logit advers_covid i.SEP_cat_2 i.gender age, or
margins SEP_cat_2
marginsplot, name(advers_covid) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Suspected or diagnosed" "with COVID-19") ytitle("") xtitle("Socioeconomic position")

contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects


svy: logit advers_covid_close i.SEP_cat_2 i.gender age, or
margins SEP_cat_2
marginsplot, name(advers_covid_close) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Someone close suspected" "or diagnosed with COVID-19") ytitle("") xtitle("Socioeconomic position")

contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects


svy: logit advers_stress i.SEP_cat_2 i.gender age, or
margins SEP_cat_2
marginsplot, name(advers_stress) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Suffering from symptoms" "of acute stress disorder") ytitle("") xtitle("Socioeconomic position")

contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects


***** COMBINE - figure 2**** 
**vertical
graph combine advers_fin advers_jobloss advers_shortwork advers_psy advers_phy advers_stress advers_covid advers_covid_close  advers_worry_infect advers_worry_close_infect, col(2) ycommon xcommon graphregion(color(white)) ysize(11) xsize(5.5) l2title("Predicted probability")

*horizontal 
graph combine advers_fin advers_jobloss advers_shortwork advers_psy advers_phy advers_stress advers_covid advers_covid_close  advers_worry_infect advers_worry_close_infect, col(5) ycommon xcommon graphregion(color(white)) ysize(5.5) xsize(11) l2title("Predicted probability")


*******************************************************************************
********************************************************************************
***************** MODERATION HYPOTHESES ****************************************
********************************************************************************


*** Social support moderates the effect of SEP on ADV***

svy: zip adversities i.SEP_cat_2 i.gender age, irr inflate(infl_dummy)
svy: zip adversities i.SEP_cat_2 i.gender age i.SP, irr inflate(infl_dummy)
svy: zip adversities i.SEP_cat_2 i.gender age i.SP i.SP#i.SEP_cat_2, irr inflate(infl_dummy)
** not significant but what's up with margins and contrasts?

margins SP#SEP_cat_2

contrast r.SP@SEP_cat_2, effects


* Test with 3 SEP cats for higher cell count
svy: zip adversities i.SEP_cat i.gender age i.SP i.SP#i.SEP_cat, irr inflate(infl_dummy)
contrast r.SP@SEP_cat, effects



** Moderation hypothesis 2: Are migrants even more affected?
svy: zip adversities i.SEP_cat_2 i.gender age, irr inflate(infl_dummy)
svy: zip adversities i.SEP_cat_2 i.gender age i.mig_dummy, irr inflate(infl_dummy)

svy: zip adversities i.SEP_cat_2 i.gender age i.mig_dummy i.mig_dummy#i.SEP_cat_2, irr inflate(infl_dummy)

contrast r.mig_dummy@SEP_cat_2, effects


svy: zip adversities i.SEP_cat i.gender age i.mig_dummy i.mig_dummy#i.SEP_cat, irr inflate(infl_dummy)



*** Test for other operationalization of mig_dummy -> mig_dummy_2 , citizenship
*mig_dummy_2 = first analysis! 
*mig_dummy_2= 0 if born in Austria and maximum one parent born foreign
*mig_dummy_2= 1 if not born in Austria, or both parents born foreign
svy: zip adversities i.SEP_cat_2 i.gender age, irr inflate(infl_dummy)
svy: zip adversities i.SEP_cat_2 i.gender age i.mig_dummy_2, irr inflate(infl_dummy)

svy: zip adversities i.SEP_cat_2 i.gender age i.mig_dummy_2 i.mig_dummy_2#i.SEP_cat_2, irr inflate(infl_dummy)

contrast r.mig_dummy_2@SEP_cat_2, effects


svy: zip adversities i.SEP_cat i.gender age i.mig_dummy_2 i.mig_dummy_2#i.SEP_cat, irr inflate(infl_dummy)
contrast r.mig_dummy_2@SEP_cat, effects



**citizenship

svy: zip adversities i.SEP_cat_2 i.gender age, irr inflate(infl_dummy)
svy: zip adversities i.SEP_cat_2 i.gender age i.citizenship, irr inflate(infl_dummy)

svy: zip adversities i.SEP_cat_2 i.gender age i.citizenship i.citizenship#i.SEP_cat_2, irr inflate(infl_dummy)

contrast r.citizenship@SEP_cat_2, effects


svy: zip adversities i.SEP_cat i.gender age i.citizenship i.citizenship#i.SEP_cat, irr inflate(infl_dummy)




*************************************************************

***************** SENSITIVITY NBREG****************************


*Model 1
svy: zip adversities i.SEP_cat_2 i.gender age, irr inflate(infl_dummy)

svy: zinb adversities i.SEP_cat_2 i.gender age, irr inflate(infl_dummy)

** no changes

*Model 2
svy: zip adversities i.hh_inc_equi_quintile i.gender age, irr inflate(infl_dummy)

svy: zinb adversities i.hh_inc_equi_quintile i.gender age, irr inflate(infl_dummy)

*no changes (except for inflation parameter: bigger effect but p also bigger 0.096)

*Model 3
svy: zip adversities i.education i.gender age, irr inflate(infl_dummy)

svy: zinb adversities i.education i.gender age, irr inflate(infl_dummy)

*no changes

*Model 4 (inflation weaker because of restricted sample)
svy: zip adversities i.occ_pos_model4 i.gender age, irr inflate(infl_dummy)

svy: zinb adversities i.occ_pos_model4 i.gender age, irr inflate(infl_dummy)

*Model 5 occ_pos with self_employed (=5)

svy: zip adversities i.occ_pos_model i.gender age, irr inflate(infl_dummy)

svy: zinb adversities i.occ_pos_model i.gender age, irr inflate(infl_dummy)

* resulted in lower p values for the occ pos effects which rendendered unskilled vs skilled stat signifcant (lower irr for skilled)


********************************************************************
*****************************************************************
******* LOGIT Models with Highest SEP as base (ib4.) for interpretation in Discussion

svy: logit advers_fin ib4.SEP_cat_2 i.gender age, or
margins SEP_cat_2
contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects


svy: logit advers_jobloss ib4.SEP_cat_2 i.gender age, or
margins SEP_cat_2
contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects

svy: logit advers_shortwork ib4.SEP_cat_2 i.gender age, or
margins SEP_cat_2
contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects

svy: logit advers_psy ib4.SEP_cat_2 i.gender age, or
margins SEP_cat_2
contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects


svy: logit advers_phy ib4.SEP_cat_2 i.gender age, or
margins SEP_cat_2
contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects


svy: logit advers_worry_infect ib4.SEP_cat_2 i.gender age, or
margins SEP_cat_2
contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects


svy: logit advers_worry_close_infect ib4.SEP_cat_2 i.gender age, or
margins SEP_cat_2
contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects


svy: logit advers_covid ib4.SEP_cat_2 i.gender age, or
margins SEP_cat_2
contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects


svy: logit advers_covid_close ib4.SEP_cat_2 i.gender age, or
margins SEP_cat_2
contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects


svy: logit advers_stress ib4.SEP_cat_2 i.gender age, or
margins SEP_cat_2
contrast {SEP_cat_2 0.5 0.5 -0.5 -0.5}, effects

******************** CONCENTRATION CURVES *****************

clear all
cd"D:\PhD Owncloud\SORA Corona paper"
use "D:\PhD Owncloud\SORA Corona paper\SORA_raw.dta"
do "D:\PhD Owncloud\SORA Corona paper\data prep 0307 clean"

********************************************************************
********************** sampling weights (?)*************************

svyset [pweight=gewfin]

********************* CONCENTRATION CURVES ************************


*both gender

lorenz adversities hh_inc_equi, pvar(hh_inc_equi) svy
lorenz graph, overlay xlabel(,grid) aspectratio(1) ciopts(recast(rline) lp(dash))
conindex adversities, rankvar(hh_inc_equi) limits(0) svy 
conindex adversities, rankvar(hh_inc_equi) limits(0) svy compare(gender)

conindex hh_inc_equi, rankvar(hh_inc_equi) limits(0) svy
conindex hh_inc_equi, rankvar(hh_inc_equi) limits(0) svy compare(gender)

*separated
lorenz adversities, pvar(hh_inc_equi) over(gender) svy
lorenz graph, xlabel(,grid) aspectratio(1) ciopts(recast(rline) lp(dash))


***********REVISIONS 21.04. *******************************
** '''''''''''''''''''''######################################
*#########################################################
clear all
cd"D:\PhD Owncloud\SORA Corona paper"
use "D:\PhD Owncloud\SORA Corona paper\SORA_raw.dta"
do "D:\PhD Owncloud\SORA Corona paper\data prep 0307 clean"
svyset [pweight=gewfin]

**************** polychoric corelations **********************************

polychoric hh_inc_equi hh_inc_equi_quintile education overcrowding hh_inc
display r(sum_w)

polychoric hh_inc_equi education overcrowding hh_inc SEP_PCA1 SEP_EFA


polychoric SEP_cat_2 SEP_cat_sens SEP_PCA1 SEP_EFA

polychoric SEP_cat_2 SEP_cat_sens SEP_PCA_cat SEP_EFA_cat

polychoric SEP_cat_2 SEP_cat_sens SEP_PCA_cat SEP_EFA_cat hh_inc_equi education overcrowding

polychoric SEP_cat_2 SEP_cat_sens

************** modeling with different SEP measures *********************
*
*extract PCA score
polychoric hh_inc_equi education overcrowding
polychoricpca hh_inc_equi education overcrowding, score(SEP_PCA) nscore(1) 
*make quartiles
xtile SEP_PCA_cat= SEP_PCA1, nquantile(4)


*extract EFA score
polychoric hh_inc_equi education overcrowding

display r(sum_w)
global N = r(sum_w)
matrix r = r(R)
factormat r, n($N) factors(1)
predict SEP_EFA

xtile SEP_EFA_cat= SEP_EFA, nquantile(4)

** do different coding on original
* create quartiles of hh_inc_equi

xtile hh_inc_equi_quart= hh_inc_equi, nquantile(4)
replace hh_inc_equi_quart = hh_inc_equi_quart -1
gen SEP_cat_sens_prep= hh_inc_equi_quart + education + overcrowding_SEP

tab hh_inc_equi_quart
tab education
tab overcrowding_SEP
tab SEP_cat_sens, missing
svy: tab SEP_cat_sens_prep, missing
svy: tab SEP_cat_2, missing
gen SEP_cat_sens= SEP_cat_sens_prep
recode SEP_cat_sens (0=1) (1=1) (2=2) (3=2) (4=3) (5=3) (6=4) (7=4)
svy: tab SEP_cat_sens, missing

**** create hh_inc cats for estimation (it is not an continuous variable)

gen hh_inc_sens= hh_inc
*1 = below 1500
*2 1500 - 2000
*3 2000 -2500
*4 2500 - 3000
*5 3000 - 4000
*6 above 4000
recode hh_inc_sens (1=1) (2=1) (3=1) (4=2) (5=3) (6=4) (7=5) (8=6) (9=6) (10=6) (11=6) (12=6)
tab hh_inc_sens
svy: tab hh_inc_sens

***************************************************************************
******************** SENSITIVITY SEP MODELS *******************************

*************** ZIP **************************
*Model 1 - Different coding of SEP
svy:zip adversities i.SEP_cat_sens age i.gender, irr inflate(infl_dummy)
* Model 2 - PCA score
svy:zip adversities i.SEP_PCA_cat age i.gender, irr inflate(infl_dummy)
* Model 3 - EFA score
svy:zip adversities i.SEP_EFA_cat age i.gender, irr inflate(infl_dummy)
* Model 4 - raw household income
svy:zip adversities i.hh_inc_sens age i.gender, irr inflate(infl_dummy)


***************************************************************************
********************** SENISTIVITY SEP LOGIT MODELS************************
*** PCA

svy: logit advers_fin i.SEP_PCA_cat i.gender age, or
margins SEP_PCA_cat
marginsplot, name(advers_fin, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Financial situation worsened") ytitle("") xtitle("Socioeconomic position (PCA)")

svy: logit advers_jobloss i.SEP_PCA_cat i.gender age, or
margins SEP_PCA_cat
marginsplot, name(advers_jobloss, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Job loss") ytitle("") xtitle("Socioeconomic position (PCA)")

svy: logit advers_shortwork i.SEP_PCA_cat i.gender age, or
margins SEP_PCA_cat
marginsplot, name(advers_shortwork, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Short work") ytitle("") xtitle("Socioeconomic position (PCA)")

svy: logit advers_psy i.SEP_PCA_cat i.gender age, or
margins SEP_PCA_cat
marginsplot, name(advers_psy, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Mental health worsened") ytitle("") xtitle("Socioeconomic position (PCA)")

svy: logit advers_phy i.SEP_PCA_cat i.gender age, or
margins SEP_PCA_cat
marginsplot, name(advers_phy, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Physical health worsened") ytitle("") xtitle("Socioeconomic position (PCA)")

svy: logit advers_worry_infect i.SEP_PCA_cat i.gender age, or
margins SEP_PCA_cat
marginsplot, name(advers_worry_infect, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Very/quite worried" "to get infected with COVID-19") ytitle("") xtitle("Socioeconomic position (PCA)")

svy: logit advers_worry_close_infect i.SEP_PCA_cat i.gender age, or
margins SEP_PCA_cat
marginsplot, name(advers_worry_close_infect, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Very/quite worried someone close" "gets infected with COVID-19") ytitle("") xtitle("Socioeconomic position (PCA)")

svy: logit advers_covid i.SEP_PCA_cat i.gender age, or
margins SEP_PCA_cat
marginsplot, name(advers_covid, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Suspected or diagnosed" "with COVID-19") ytitle("") xtitle("Socioeconomic position (PCA)")

svy: logit advers_covid_close i.SEP_PCA_cat i.gender age, or
margins SEP_PCA_cat
marginsplot, name(advers_covid_close, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Someone close suspected" "or diagnosed with COVID-19") ytitle("") xtitle("Socioeconomic position (PCA)")

svy: logit advers_stress i.SEP_PCA_cat i.gender age, or
margins SEP_PCA_cat
marginsplot, name(advers_stress, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Suffering from symptoms" "of acute stress disorder") ytitle("") xtitle("Socioeconomic position (PCA)")

***** COMBINE *** 
graph combine advers_fin advers_jobloss advers_shortwork advers_psy advers_phy advers_stress advers_covid advers_covid_close  advers_worry_infect advers_worry_close_infect, col(5) ycommon xcommon graphregion(color(white)) ysize(5.5) xsize(11) l2title("Estimated probability")

*********************** EFA **************************************************************

svy: logit advers_fin i.SEP_EFA_cat i.gender age, or
margins SEP_EFA_cat
marginsplot, name(advers_fin, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Financial situation worsened") ytitle("") xtitle("Socioeconomic position (EFA)")

svy: logit advers_jobloss i.SEP_EFA_cat i.gender age, or
margins SEP_EFA_cat
marginsplot, name(advers_jobloss, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Job loss") ytitle("") xtitle("Socioeconomic position (EFA)")

svy: logit advers_shortwork i.SEP_EFA_cat i.gender age, or
margins SEP_EFA_cat
marginsplot, name(advers_shortwork, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Short work") ytitle("") xtitle("Socioeconomic position (EFA)")

svy: logit advers_psy i.SEP_EFA_cat i.gender age, or
margins SEP_EFA_cat
marginsplot, name(advers_psy, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Mental health worsened") ytitle("") xtitle("Socioeconomic position (EFA)")

svy: logit advers_phy i.SEP_EFA_cat i.gender age, or
margins SEP_EFA_cat
marginsplot, name(advers_phy, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Physical health worsened") ytitle("") xtitle("Socioeconomic position (EFA)")

svy: logit advers_worry_infect i.SEP_EFA_cat i.gender age, or
margins SEP_EFA_cat
marginsplot, name(advers_worry_infect, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Very/quite worried" "to get infected with COVID-19") ytitle("") xtitle("Socioeconomic position (EFA)")

svy: logit advers_worry_close_infect i.SEP_EFA_cat i.gender age, or
margins SEP_EFA_cat
marginsplot, name(advers_worry_close_infect, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Very/quite worried someone close" "gets infected with COVID-19") ytitle("") xtitle("Socioeconomic position (EFA)")

svy: logit advers_covid i.SEP_EFA_cat i.gender age, or
margins SEP_EFA_cat
marginsplot, name(advers_covid, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Suspected or diagnosed" "with COVID-19") ytitle("") xtitle("Socioeconomic position (EFA)")

svy: logit advers_covid_close i.SEP_EFA_cat i.gender age, or
margins SEP_EFA_cat
marginsplot, name(advers_covid_close, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Someone close suspected" "or diagnosed with COVID-19") ytitle("") xtitle("Socioeconomic position (EFA)")

svy: logit advers_stress i.SEP_EFA_cat i.gender age, or
margins SEP_EFA_cat
marginsplot, name(advers_stress, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Suffering from symptoms" "of acute stress disorder") ytitle("") xtitle("Socioeconomic position (EFA)")

***** COMBINE *** 
graph combine advers_fin advers_jobloss advers_shortwork advers_psy advers_phy advers_stress advers_covid advers_covid_close  advers_worry_infect advers_worry_close_infect, col(5) ycommon xcommon graphregion(color(white)) ysize(5.5) xsize(11) l2title("Estimated probability")


********************************* CAT SENS ***************************

svy: logit advers_fin i.SEP_cat_sens i.gender age, or
margins SEP_cat_sens
marginsplot, name(advers_fin, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Financial situation worsened") ytitle("") xtitle("Socioeconomic position †")

svy: logit advers_jobloss i.SEP_cat_sens i.gender age, or
margins SEP_cat_sens
marginsplot, name(advers_jobloss, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Job loss") ytitle("") xtitle("Socioeconomic position †")

svy: logit advers_shortwork i.SEP_cat_sens i.gender age, or
margins SEP_cat_sens
marginsplot, name(advers_shortwork, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Short work") ytitle("") xtitle("Socioeconomic position †")

svy: logit advers_psy i.SEP_cat_sens i.gender age, or
margins SEP_cat_sens
marginsplot, name(advers_psy, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Mental health worsened") ytitle("") xtitle("Socioeconomic position †")

svy: logit advers_phy i.SEP_cat_sens i.gender age, or
margins SEP_cat_sens
marginsplot, name(advers_phy, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Physical health worsened") ytitle("") xtitle("Socioeconomic position †")

svy: logit advers_worry_infect i.SEP_cat_sens i.gender age, or
margins SEP_cat_sens
marginsplot, name(advers_worry_infect, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Very/quite worried" "to get infected with COVID-19") ytitle("") xtitle("Socioeconomic position †")

svy: logit advers_worry_close_infect i.SEP_cat_sens i.gender age, or
margins SEP_cat_sens
marginsplot, name(advers_worry_close_infect, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Very/quite worried someone close" "gets infected with COVID-19") ytitle("") xtitle("Socioeconomic position †")

svy: logit advers_covid i.SEP_cat_sens i.gender age, or
margins SEP_cat_sens
marginsplot, name(advers_covid, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Suspected or diagnosed" "with COVID-19") ytitle("") xtitle("Socioeconomic position †")

svy: logit advers_covid_close i.SEP_cat_sens i.gender age, or
margins SEP_cat_sens
marginsplot, name(advers_covid_close, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Someone close suspected" "or diagnosed with COVID-19") ytitle("") xtitle("Socioeconomic position †")

svy: logit advers_stress i.SEP_cat_sens i.gender age, or
margins SEP_cat_sens
marginsplot, name(advers_stress, replace) recast(scatter) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Suffering from symptoms" "of acute stress disorder") ytitle("") xtitle("Socioeconomic position †")

***** COMBINE *** 
graph combine advers_fin advers_jobloss advers_shortwork advers_psy advers_phy advers_stress advers_covid advers_covid_close  advers_worry_infect advers_worry_close_infect, col(5) ycommon xcommon graphregion(color(white)) ysize(5.5) xsize(11) l2title("Estimated probability")


********************** RESPONSE ATTACHMENT ************************************


************************ MIG DUMMY **********************************************

label define mig_dummy_lab 0"no migration" 1"migration"
label values mig_dummy mig_dummy_lab


svy: logit advers_fin i.SEP_cat_2##i.mig_dummy i.gender age, or
margins i.SEP_cat_2#i.mig_dummy
marginsplot, name(advers_fin, replace) recast(line) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Financial situation worsened") ytitle("") xtitle("Socioeconomic position")

svy: logit advers_jobloss i.SEP_cat_2##i.mig_dummy i.gender age, or
margins i.SEP_cat_2#i.mig_dummy
marginsplot, name(advers_jobloss, replace) recast(line) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Job loss") ytitle("") xtitle("Socioeconomic position") legend(off)


svy: logit advers_shortwork i.SEP_cat_2##i.mig_dummy i.gender age, or
margins i.SEP_cat_2#i.mig_dummy
marginsplot, name(advers_shortwork, replace) recast(line) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Short work") ytitle("") xtitle("Socioeconomic position") legend(off)


svy: logit advers_psy i.SEP_cat_2##i.mig_dummy i.gender age, or
margins i.SEP_cat_2#i.mig_dummy
marginsplot, name(advers_psy, replace) recast(line) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Mental health worsened") ytitle("") xtitle("Socioeconomic position") legend(off)

svy: logit advers_phy i.SEP_cat_2##i.mig_dummy i.gender age, or
margins i.SEP_cat_2#i.mig_dummy
marginsplot, name(advers_phy, replace) recast(line) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Physical health worsened") ytitle("") xtitle("Socioeconomic position") legend(off)


svy: logit advers_worry_infect i.SEP_cat_2##i.mig_dummy i.gender age, or
margins i.SEP_cat_2#i.mig_dummy
marginsplot, name(advers_worry_infect, replace) recast(line) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Very/quite worried" "to get infected with COVID-19") ytitle("") xtitle("Socioeconomic position") legend(off)

svy: logit advers_worry_close_infect i.SEP_cat_2##i.mig_dummy i.gender age, or
margins i.SEP_cat_2#i.mig_dummy
marginsplot, name(advers_worry_close_infect, replace) recast(line) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Very/quite worried someone close" "gets infected with COVID-19") ytitle("") xtitle("Socioeconomic position") legend(off)

svy: logit advers_covid i.SEP_cat_2##i.mig_dummy i.gender age, or
margins i.SEP_cat_2#i.mig_dummy
marginsplot, name(advers_covid, replace) recast(line) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Suspected or diagnosed" "with COVID-19") ytitle("") xtitle("Socioeconomic position") legend(off)

svy: logit advers_covid_close i.SEP_cat_2##i.mig_dummy i.gender age, or
margins i.SEP_cat_2#i.mig_dummy
marginsplot, name(advers_covid_close, replace) recast(line) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Someone close suspected" "or diagnosed with COVID-19") ytitle("") xtitle("Socioeconomic position") legend(off)

svy: logit advers_stress i.SEP_cat_2##i.mig_dummy i.gender age, or
margins i.SEP_cat_2#i.mig_dummy
marginsplot, name(advers_stress, replace) recast(line) graphregion(color(white)) ciopts(lpattern(dash) lwidth(thin)) title("Suffering from symptoms" "of acute stress disorder") ytitle("") xtitle("Socioeconomic position") legend(off)


***** COMBINE *** 


*horizontal 
graph combine advers_fin advers_jobloss advers_shortwork advers_psy advers_phy advers_stress advers_covid advers_covid_close  advers_worry_infect advers_worry_close_infect, col(5) ycommon xcommon graphregion(color(white)) ysize(5.5) xsize(11) l2title("Estimated probability") legend(label(1 "no migration") label(2 "migration"))

grc1leg2 advers_fin advers_jobloss advers_shortwork advers_psy advers_phy advers_stress advers_covid advers_covid_close  advers_worry_infect advers_worry_close_infect, col(5) ycommon xcommon graphregion(color(white)) ysize(5.5) xsize(11) l2title("Estimated probability") legendfrom(advers_fin)





