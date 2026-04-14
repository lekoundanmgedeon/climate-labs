

---

## 🔹 1. Initialisation

```bash
iyear=1931
fyear=1960
```

👉 Définit la période d’étude : **1931 → 1960**

```bash
indir='/home/.../climate_lab/'
outdir='/home/.../out_data/'
```

👉 Dossiers :

* `indir` : où se trouvent les données d’entrée
* `outdir` : où seront stockés les résultats

```bash
mkdir -p ${outdir}
```

👉 Crée le dossier de sortie s’il n’existe pas

---

## 🔹 2. Extraction de la période

```bash
cdo selyear,${iyear}/${fyear} input.nc output.nc
```

👉 Cette commande :

* prend le fichier complet (1901–2020)
* **extrait uniquement les années 1931 à 1960**

Résultat :

```
afr_cru_1931_1960.nc
```

---

## 🔹 3. Calcul de la moyenne annuelle

```bash
cdo yearmonmean input.nc output.nc
```

👉 Convertit des données mensuelles en **moyennes annuelles**

Résultat :

```
afr_cru_1931_1960_yearmean.nc
```

---

## 🔹 4. Calcul des anomalies standardisées

```bash
cdo div -sub A -timmean A -timstd A output.nc
```

👉 Cette ligne fait 3 opérations :

1. `-timmean` → moyenne temporelle
2. `-timstd` → écart-type
3. `-sub` → (valeur - moyenne)
4. `div` → division par l’écart-type

👉 Formule finale :
[
anomalie = \frac{X - \text{moyenne}}{\text{écart-type}}
]

Résultat :

```
afr_cru_1931_1960_ano_std.nc
```

➡️ Ça permet de voir si une année est **plus humide ou plus sèche que la normale**

---

## 🔹 5. Nettoyage

```bash
rm -f afr_cru_1931_1960.nc afr_cru_1931_1960_yearmean.nc
```

👉 Supprime les fichiers intermédiaires (pour gagner de la place)

---

## 🔹 6. Définition des stations

```bash
stations=( Abidjan Yamoussoukro Dakar ... )
lons=( ... )
lats=( ... )
```

👉 Liste de :

* noms des villes
* leurs coordonnées (longitude / latitude)

---

## 🔹 7. Boucle sur les stations

```bash
for k in $(seq 0 9); do
```

👉 Boucle sur les 10 stations

---

### 📍 a) Interpolation nearest neighbor

```bash
cdo remapnn,lon=.../lat=... input.nc output.nc
```

👉 Prend la valeur du **point de grille le plus proche**

Résultat :

```
afr_cru_1931_1960_remapnn_Abidjan.nc
```

---

### 📍 b) Interpolation pondérée

```bash
cdo remapdis,lon=.../lat=... input.nc output.nc
```

👉 Interpolation plus précise :

* utilise plusieurs points autour
* pondère selon la distance

Résultat :

```
afr_cru_1931_1960_remapbil_Abidjan.nc
```

---

## 🎯 Résumé global

Ce script :

1. 📥 Charge des données climatiques (1901–2020)
2. ✂️ Extrait 1931–1960
3. 📊 Calcule les moyennes annuelles
4. 📉 Calcule les anomalies standardisées
5. 📍 Extrait les données pour 10 villes africaines
6. 🔄 Utilise 2 méthodes d’interpolation

---

## 💡 À quoi ça sert ?

👉 Analyse climatique :

* détecter sécheresses / périodes humides
* comparer les années entre elles
* étudier le climat local (par ville)

---

Si tu veux, je peux aussi :

* te faire un **schéma visuel du workflow**
* ou t’expliquer chaque commande `cdo` en détail 👍
