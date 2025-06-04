******************************************************************************************
**************** PROJET DE STATISTIQUES AGRICOLES DE ISEP2 
**************** ELEVAGE ET EMIGRATION 
**************** DERNIERE MISE A JOUR : Juin 2024
**************** Réalisé par : FOGWOUNG DJOUFACK SARAH-LAURE & ABDOU ALIOUNE SALAM KANE  

************************************************2-4 ELEVAGE ET EMIGRATION
use "${data}/emigration_cleaned.dta", clear

* 1. Pour chaque menage, calculer le nombre de personnes qui ont émigré durant les 5 années qui ont précédé l'enquête.
preserve
gen indic = cond(Année<=5,1, 0) // Variable indicatrice
collapse (sum) emig_num_5A = indic, by(ID) // Compte suivant les differntes familles, le nombre de personnes ayant émigré durant cette période
save "${outputs}/emigrations_statistiques.dta", replace
restore

*2. Calculer l'intensité de l'émigration en rapportant le nombre d'émigrés à la taille du ménage.Résumer ce taux par pays./
use "${outputs}/emigrations_statistiques.dta",clear 
merge 1:1 ID using "${data}/FT_cleanID2.dta", ///
 keepusing(country HommesadultesHA FemmesadultesFA VieuxV Garçonsde12ansG12 Fillesde12ansF12 ind_viab)  //Récupération des variables pour la taille du ménage
drop _merge 
drop if missing(emig_num_5A)

gen HHsize_new = HommesadultesHA + FemmesadultesFA + VieuxV + Garçonsde12ansG12 + Fillesde12ansF12  
gen intensity_emig = emig_num_5A/HHsize_new // Intensité de l'émigration

//Resumer ce taux par pays
preserve
collapse (sum) HHsize_new = HHsize_new ///
         (sum) emig_num_5A = emig_num_5A ///
         , by(country)
gen ints_emig_mean = emig_num_5A / HHsize_new

*graph hbar ints_emig_mean, over(country) // To view the graph
quietly graph hbar ints_emig_mean, over(country)
graph export "${outputs}\Intensité_Emigr_country.png", replace
restore
save "${outputs}/emigrations_statistiques2.dta", replace

**3.Quelles sont les principales destinations des fils d’éleveurs du Sahel ?
use "${data}/emigration_cleaned.dta", clear
preserve
gen fils = (strmatch(lower(Liensdeparenté), "fils") | strmatch(lower(Liensdeparenté), "fils/fille")) & !strmatch(lower(Liensdeparenté), "petit")
keep if fils
* Visualisation avec un diagramme à barres horizontales des destinations
graph hbar (count), over(destination) ///
title("Principales destinations des fils d'éleveurs") ///
legend(off)
graph export "${outputs}/distribution_des_destinations_fils_fille.png", as(png) replace
restore

*4. Quelles sont les destinations principales des emigrés?*
graph hbar, over(destination) ///
    title("Destination des émigrés")
graph export "${outputs}/Destination_des_émigrés.png", as(png) replace


*5. Corréler l’intensité  de l’émigration avec l’indicateur de viabilité de l’élevage. Conclure
use "${outputs}/emigrations_statistiques2.dta",clear 
correlate intensity_emig ind_viab

