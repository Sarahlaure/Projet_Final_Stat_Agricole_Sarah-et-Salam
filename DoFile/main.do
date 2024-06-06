******************************************************************************************
**************** PROJET DE STATISTIQUES AGRICOLES DE ISEP2 
**************** DEFINITION DES CHEMINS D'ACCES  
**************** DERNIERE MISE A JOUR : Juin 2024
**************** Réalisé par : FOGWOUNG DJOUFACK SARAH-LAURE & ABDOU ALIOUNE SALAM KANE  

**** DEFINITION DU REPERTOIRE PRINCIPAL 
global root "E:/ISEP 2/MON DOSSIER/SEMESTRE 2/STATISTIQUES AGRICOLES/PROJET_STATISTIQUES_AGRICOLES_SARAH_SALAM_ISEP2"

**** DEFINITION DES SOUS-REPERTOIRES
global Datawork "${root}/TPfinal_ISEP2_2024_Elevage_transhumant"
global inputfile "${root}/famille_troupeau.dta"
global data "${root}/Data"
global codes "${root}/DoFile"
global outputs "${root}/Output"


*## Run the task-specific master do-files 
if (1) {
do "${codes}/1. cleaning.do"
}
if (1) {
do "${codes}/Preparation, nettoyage des données et subsistance des ménages.do"
}
if (1) {
do "${codes}/Vente de bétail durant la transhumance.do"
}
if (1) {
do "${codes}/Elevage et emigration.do"
}

