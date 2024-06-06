******************************************************************************************
**************** PROJET DE STATISTIQUES AGRICOLES DE ISEP2 
**************** DO FILE DE TRAVAIL  
**************** DERNIERE MISE A JOUR : Juin 2024
**************** Réalisé par : FOGWOUNG DJOUFACK SARAH-LAURE & ABDOU ALIOUNE SALAM KANE  
************************************************2-1 Préparation et nettoyage des données
*Le code du cleaning prépare et nettoie l'ensemble de données pour l'analyse. Il commence par importer les données brutes, explore les variables et renomme les identifiants. Ensuite, il extrait et étiquette les informations de localisation à partir des identifiants, ajuste les valeurs des variables de localisation, et supprime les variables inutiles. Le code calcule la taille des ménages en équivalent adulte et remplace les valeurs manquantes par zéro. Pour les données de ventes de bétail, il harmonise les valeurs, transforme les données en format long, nettoie les variables de sexe, âge, origine, date de vente, lieu d'achat et prix, puis sauvegarde le dataset nettoyé. Enfin, il nettoie et transforme les données d'émigration en format long, supprimant les valeurs manquantes.
*S'agissant du emigration_cleaning,il convertit la variable Endroit en minuscules pour éviter les problèmes de conversion, remplace les valeurs indésirables par une chaîne vide, et génère une nouvelle variable Endroit2. Il affiche les observations où Endroit2 est vide, remplace Endroit2 par des régions spécifiques basées sur des correspondances de chaînes (comme "Afrique Centrale" pour congo ou gabon, "Europe-US" pour des pays européens et USA, etc.), puis encode Endroit2 en une nouvelle variable destination avec des labels définis. Le code recode ensuite les destinations : si une personne a émigré vers un autre pays avec un code inférieur à 6, elle est recodée en "ailleurs au Sahel"; si elle a émigré à l'intérieur de son pays, elle est recodée en "ailleurs dans le pays". Enfin, les variables Endroit et Endroit2 sont supprimées.

************************************************2-2 SUBSISTANCE DU MENAGE 

* Importation de la base 
use "${data}/FT_cleanID.dta", clear  // Pour charger la base FT_cleanID

** 1. Calculer la proportion de familles pratiquant l’agriculture en plus de l’élevage
tab  country AGRICULTURE  
* Pour la representation graphique
bys country: egen prop_agriculture = mean(AGRICULTURE == "Oui")
graph hbar prop_agriculture, over(country) ///
	bar(1, color(green)) ///
        title("Proportion des agriculteurs parmi ces éleveurs")
graph export "${outputs}/Proportion_agriculture.png ", replace 

** 2. Pour chaque pays, calculons la proportion pour chaque type de culture
// Notifions tous ceux qui pratiquent ces differentes cultures dans une meme modalité
local cultures Mil Sorgho Maïs Niébé Manioc Arachide Coton Culturesmaraîchères 
foreach var of local cultures {
    local var_lower = lower("`var'")
    gen `var'_rec = "`var'" if `var' == "`var'" | `var' == "Oui" | `var' == "oui" | `var' == "oui" | `var' == "oui" | `var' == "oui" | `var' == "Maraîch."
}
gen Autres_rec = Autres
replace Autres_rec = "" if Autres == "Pas d'autres"

//Calcul des proportions
forval country = 1/5  {
	// Extraire le label du pays actuel
    local country_label : label country `country'
	//  Pour afficher sous forme de tableau
	mrtab *_rec if AGRICUL=="Oui" & country == `country'
	// Representation graphique
	mrgraph hbar *_rec if AGRICULTURE=="Oui" & country == `country', intensity(70) ///
        title("Proportion des cultures au `country_label'") percent 
    *graph export "${outputs}/prop_cult_`country_label'.png", replace
}

** 3- la taille du ménage en Equivalents adultes (EA)
gen Taille_EA= HommesadultesHA + FemmesadultesFA + VieuxV + (Garçonsde12ansG12 + Fillesde12ansF12) * 0.5 
lab var Taille_EA "la taille du ménage en Equivalents adultes"
bys country : egen Taille_EA_pays=mean(Taille_EA)   
// Representation graphique 
graph bar Taille_EA_pays, over(country) title("la taille du ménage en Equivalents adultes") blabel(bar) ///
	bar(1, color(green))
graph export "${outputs}/Equivalent_Adulte.png", replace


** 4- Le nombre de mois d’autosuffisance de la production agricole
bys country : egen Mois_autosufissance=mean(Nbremoisautosuffis)   
// Representation graphique 
graph bar Mois_autosufissance, over(country) title("Le nombre de mois d’autosuffisance de la production agricole") blabel(bar, format(%9.0f)) ///
    bar(1, color(green))
graph export "${outputs}/Mois_Autosuffisance.png", replace


** 5- la taille du cheptel en Unités de bétail tropical (UBT)
gen UBT= transh_Bovins*0.7+ transh_Ovins*0.15 + transh_Caprins*0.1 + transh_Camelins*1 
lab var UBT "Taille du cheptel en Unité de Bétail Tropical"
bys country : egen UBT_pays=mean(UBT)   
// Representation graphique
graph bar UBT_pays, over(country) ytitle("la taille du cheptel en Unités de bétail tropical") title("la taille du cheptel en Unités de bétail tropical") blabel(bar) ///
    bar(1, color(green))
graph export "${outputs}/Taille_Cheptel.png", replace


**6- . l’indicateur de viabilité de l’´elevage (UBT/EA)
gen ind_viab=UBT_pays/Taille_EA_pays
graph bar ind_viab, over(country) ytitle("l’indicateur de viabilité de l’élevage") title("l’indicateur de viabilité de l’élevage") blabel(bar) ///
    bar(1, color(green))
graph export "${outputs}/Indice_Viabilite.png", replace
save "${data}/FT_cleanID2.dta", replace  // Pour charger la base FT_cleanID
