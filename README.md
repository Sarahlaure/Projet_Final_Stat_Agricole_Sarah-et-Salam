# 📊 Projet de Fin d'Année – Statistique Agricole

Ce projet constitue le **travail de fin d’année** du cours de **Statistique Agricole**, dispensé en classe de **ISEP2** à l’**ENSAE de Dakar** durant l’**année académique 2023/2024**.
Il a été encadré par **Monsieur Rassoul Sy**,[Lien vers le compte GitHub](https://github.com/syrassoul), enseignant du cours.

---

## 📝 Tâches demandées

### 1. Préparation des données
- Nettoyage du fichier maître
- Création des identifiants uniques
- Attribution des pays via l’ID et les régions

### 2. Subsistance du ménage
- Part de familles pratiquant l’agriculture
- Répartition des types de culture
- Taille du ménage en **équivalents adultes (EA)**
- Mois d’autosuffisance alimentaire
- Taille du cheptel en **unités de bétail tropical (UBT)**
- Calcul de **viabilité** : `UBT/EA`

### 3. Ventes durant la transhumance
- Statistiques descriptives des prix de vente
- Graphiques par pays et par sexe
- Régression linéaire du prix de vente
- Analyse des variables explicatives

### 4. Élevage et émigration
- Nombre d’émigrés par ménage
- Taux d’intensité d’émigration par pays
- Principales destinations
- Corrélation entre émigration et viabilité de l’élevage

---

## 🗂️ Organisation du Dossier de Travail

Le projet est organisé de manière suivante :

- `Data/` : fichiers de données utilisés (.dta).
- `DoFile/` : scripts Stata :
  
| Script | Description |
|--------|-------------|
| `main.do` | Script principal exécutant les autres scripts via des chemins globaux |
| `cleaning.do` | Nettoyage initial du fichier principal et création des identifiants et variables pays |
| `Preparation, nettoyage des données et subsistance des ménages.do` | Calculs liés à la composition du ménage, agriculture, élevage et indicateurs de viabilité |
| `Vente de bétail durant la transhumance.do` | Statistiques descriptives et analyse des ventes de bétail (graphiques, régressions) |
| `Elevage et emigration.do` | Calculs sur l’émigration, ses destinations et lien avec la viabilité de l’élevage |

- `Output/` : résultats produits (graphiques, tableaux, exports).
- `Presentation_Powerpoint` : Diaporama de présentation des résultats.
- `Enonce_TP` : Fichier PDF contenant l’énoncé du TP.

---

## 👥 Auteurs

Projet réalisé par les étudiants de la classe **ISEP2** – ENSAE Dakar :

- **FOGWOUNG DJOUFACK Sarah-Laure**: [Lien vers le compte GitHub](https://github.com/Sarahlaure)  
- **KANE Abdou Alioune Salam**: [Lien vers le compte GitHub](https://github.com/AliouneKane)

