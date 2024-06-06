*********************************************
***			Préparation des données // ON VA NETTOYER ET TRANSFORMER LE DATASET POUR L'ANALYSE
*********************************************

* Import master dataset
use "${inputfile}", clear  // Charger le fichier 

***-----------------------------------
*		 1. explorer dataset
***-----------------------------------

	describe , short // Nom des variables et type de donnees , resumé rapide des variables nombre de variable set d'observations

 
***-----------------------------------
*		 2. variable ID
***-----------------------------------
	*rename ID var
	ren Codeduquestionnaire ID // Renommer 
	codebook ID // statistiques descriptives sur la variable ID

	* drop missing ID
	drop if missing(ID) // supprimer les missing values 9655 valeurs supprimées

	* deal with real ID duplicates
	duplicates report  ID // generer un rapport sur les doublons : 18 observations qui ont des doublons dans la variable ID avec un total de 9 doubons en surplus
	duplicates tag ID, gen(duplicates) // Marquer les doublons dans une nouvelle varaible duplicates 
	*br if duplicates
	duplicates drop ID if duplicates, force // supprimer les doublons et on ne veut garder qu'une seule copie des deux
	drop duplicates // Supprimer la variable duplicates 

	isid ID // Verifie qu'il n'y a plus de doublons 

***-----------------------------------
*		3.1 generate LOCATIONs from ID
***-----------------------------------
	* check ID length
	tostring ID, replace  // convertit la colonne ID en chaine de caractere 
	gen id_length = length(ID) // cree une variable qui prend en parametre la longueur de la chaine de caractere
	tab id_length // all ok, 6 characters as expected
	drop id_length //Supprimer  cette variable

	* gen country
	gen country = substr(ID, 1, 1) // creer une nouvelle country en extrayant le 1er caractere de chaque ID et ce caractere represente le pays d'origine
	list ID country Zonederéférence DépartementouCercle Région // Extraire ces colonnes pour verifier 
	destring country, replace // Convertir en numerique
	list country Groupedorigine Région DépartementouCercle if country>5 
*	 cross-check with Region
*	forvalues num = 4/8 {
 *		tab Région if country==`num', mis		
 *	} 

	* label country
	lab def country 1 "Sénégal" 2 "Mali" 3 "Mauritanie" 4 "Burkina Faso" 5 "Niger" // On definit des etiquettes pour chacune des valeurs de la variable Country
	lab val country country // Appliquer les etiquettes definies à la variable country 
	
	* now changing the values
	replace country=2 if Région=="kayes" // Replacement de mali par 2 si la region est kayes
	replace country=5 if Région=="Tillabery" // Replacement de Niger par 5 si la region est Tillabery
	replace country=4 if Région=="Sahel" | Région=="Est" // Replacement de Burkina Faso par 2 si la region est Sahel ou Est
	
	* drop unnecessary variables 
	drop Ordredesaisie PAYS Zonederéférence Groupedorigine // On efface ces variables car elles ne sont plus necessaire pour la suite
	order ID country Région // Reorganiser ces variables pour les mettre dans cet ordre
	
* Save cleaned ID
	compress // Compresser le fichier pour au'il prenne moins d'espace 
	save "${data}/FT_cleanID.dta", replace // On sauvegarde le fichier sous un nouveau nom

***-----------------------------------
*		 3.2  composition du ménage
***-----------------------------------

codebook HommesadultesHA FemmesadultesFA VieuxV Garçonsde12ansG12 Fillesde12ansF12 Nombretotaldepersonnes // Affiche les caracteriques de chacune de ces variables 

drop Nombretotaldepersonnes // Supprime cette variable

egen HHsize =rsum(HommesadultesHA FemmesadultesFA VieuxV Garçonsde12ansG12 Fillesde12ansF12) // Cree une variable qui somme les autres là

codebook HHsize // Caractéristiques de cette variable 
tabstat HHsize, by(Région) s(mean sd p50 min max n) // Calcule les stat pour la variable HHsize suivant chaque région

foreach var of varlist HommesadultesHA FemmesadultesFA VieuxV Garçonsde12ansG12 Fillesde12ansF12 {

replace `var'=0 if missing(`var')

} // Remplacer les valeurs manquantes par 0 pour les variables de composition du ménage

gen HHsizeEA = HommesadultesHA + FemmesadultesFA+ VieuxV +0.75*(Garçonsde12ansG12+Fillesde12ansF12) // Creer une nouvelle variable pour ce calcul ajusté  

***-----------------------------------
*		 4. VENTES betail
***-----------------------------------

	use "${data}/FT_cleanID.dta", clear


*** Tidying the sales dataset
	** subset 
	keep ID country Sexe* Age* Origine* Mois* Année* Aqui* Où* Prix*
	drop Années* // Garder les colonnes là et supprimer la colonnes années

	** Harmonize the variables 
	tostring *, replace // Convertir toutes les colonnes en chaines de caracteres 
	
forvalues num = 37/50 {
	list Sexe`num' Age`num' Origine`num' Mois`num' Année`num' Aqui`num' Où`num' Prix`num' if Prix`num'=="sendré" 
	replace Sexe`num' = "1" if Prix`num' == "sendré"
    replace Age`num' = "2" if Prix`num' == "sendré"
    replace Origine`num' = "1" if Prix`num' == "sendré"
    replace Mois`num' = "4" if Prix`num' == "sendré"
    replace Année`num' = "2015" if Prix`num' == "sendré"
    replace Aqui`num' = "1" if Prix`num' == "sendré"
    replace Où`num' = "sendré" if Prix`num' == "sendré"
    replace Prix`num' = "45000" if Prix`num' == "sendré"		
	} 
// Pour le svaleurs de 37 à 50 , Remplacer par ces valeurs pour chacune des colonnes si le prix est sendré



	** reshape long the data
	reshape long Sexe Age Origine Mois Année Aqui Où Prix, i(ID) j(animal_number) // Transformer de format large en format long pour que chaque ligne represente une vente individuelle d'un animal, cea veut dire que chaque ligne montrera les infos pour un seul animal vendu, avec un numéro d'animal unique pour chaque vente
	
	duplicates drop Sexe Age Origine Mois Année Aqui Où Prix, force //to kill missing values
	** clean different variables
		* sex
		codebook Sexe
		replace Sexe="2" if Sexe=="F"
		replace Sexe="1" if Sexe=="M"
		replace Sexe="" if Sexe!="2" & Sexe!="1"
		destring Sexe, replace
		lab def Sexe 1 "Male" 2 "Female"
		lab val Sexe Sexe
		tab Sexe, mis
		
		* Age
		codebook Age
		destring Age, replace
		tab Age
		mvdecode Age, mv(99)
		replace Age=. if Age >20 
		
		* Origine
		codebook Origine
		replace Origine="1" if Origine=="Famille"
		destring Origine, replace
		lab def Origine 1 "Famille" 2 "Confié"
		lab val Origine Origine
		tab Origine, mis
		
		* Date de vente
		codebook Mois
		tab Mois
		codebook Année
		tab Année // C'est moi qui ai ajouté
		replace Année="2014" if Année=="2004"
		destring Mois, replace // Convertit en numerique 
		gen soudure=inrange(Mois,5,8) //indique si le nombre est entre 5 et 8 et la valeur est 1 si oui et 0 si non; on peut donc identifier les mois de soudure dans l'année 
		
		* Aqui (to clean further)
		codebook Aqui
		tab Aqui country
		replace Aqui="1" if Aqui=="Marché bétail"
		replace Aqui="2" if Aqui=="Habitant local"
		replace Aqui="3" if Aqui=="Au campement"
		replace Aqui="" if Aqui=="4"
		destring Aqui, replace
		lab def Aqui 1"sur un marché" 2"producteur local" 3"commerçant venu chez eux"  // On definit une sorte de labellisation
		lab val Aqui Aqui // On applique cette labellisation

		* Où
		codebook Où
		drop Où // Suppression de cette variable apres l'avoir inspecté
		
		* Prix
		codebook Prix
		destring Prix, replace
		
		*graph box Prix
		replace Prix=. if !inrange(Prix,20000,450000) 
		bys Sexe Age country : egen mean_P=mean(Prix) 
		replace Prix=mean_P if missing(Prix)
		drop mean_P
* compress and save
compress
save "${data}/emigration_cleaned.dta", replace
	
* compress and save
compress
save "${data}/vente_betail_cleaned.dta", replace		


**-----------------------------------
*** 5. Emigration
*--------------------------------------

	use "${data}/FT_cleanID.dta", clear
*** Tidying the migration dataset
	** subset 
	keep ID country Région Liensdeparenté* Endroit* Années* Activité*

	** reshape long the data
	reshape long Liensdeparenté Endroit Années Activité, i(ID) j(migr_number) // On reshape en long askip

	drop if missing(Liensdeparenté) & missing(Années) & missing(Activité) // On efface les missing values 
	tab Endroit
	** Endroits
	do "${codes}/emigration_cleaning.do"

* compress and save
compress
save "${data}/emigration_cleaned.dta", replace
	
