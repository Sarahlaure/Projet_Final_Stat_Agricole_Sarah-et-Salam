******************************************************************************************
**************** PROJET DE STATISTIQUES AGRICOLES DE ISEP2 
**************** VENTES DE BETAIL DURANT LA TRANSHUMANCE
**************** DERNIERE MISE A JOUR : Juin 2024
**************** Réalisé par : FOGWOUNG DJOUFACK SARAH-LAURE & ABDOU ALIOUNE SALAM KANE  

************************************************2-3 VENTES DE BETAIL DURANT LA TRANSHUMANCE

use "${data}/vente_betail_cleaned.dta", clear  // Charger le fichier 
*1. Générons les statistiques descriptives par pays
preserve
collapse (count) Observations=Prix (mean) Moyenne=Prix (median) Mediane=Prix (sd) Ecart_type=Prix (min) Minimum=Prix (max) Maximum=Prix, by(country)
list // Affichage des resultats 
restore

*2. Générons un graphique représentant le prix de vente médian par sexe et par pays. 
preserve
drop if missing(Sexe) | missing(Prix)
collapse (median) Median_Price=Prix, by(country Sexe) // le prix de vente médian par sexe et par pays
graph bar Median_Price, over(Sexe) over(country, gap(50)) asyvars ///
    title("Prix de vente médian par sexe et par pays") ///
    ytitle("Prix de vente médian") ///
    legend(order(1 "Male" 2 "Femelle")) ///
    bargap(5)
graph export "${outputs}/Prix_vente_médian.png", replace
restore

*3. A travers une régression linéaire, modéliser le prix de vente en fonction du sexe, de l'âge, de l’origine, du type de client, de la période de vente et du pays. Que peut-on retenir?
regress Prix Sexe Age Origine Aqui Mois country

*4. Quelles autres variables pourraient être pertinentes à cette régression?

*animal_number : Identifie chaque animal et peut refléter les effets de série ou de lot lors de ventes groupées.
*Ageapproxans : Estime l'âge de l'animal en années, offrant une dimension supplémentaire à considérer pour le prix.
*soudure : Indique si la vente a eu lieu pendant une période de soudure, influençant potentiellement les prix.
