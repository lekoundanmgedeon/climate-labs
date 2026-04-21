#!/bin/bash

# ============================================================
# Script: part11_netcdf.sh
# Objectif:
#   - Télécharger les données CPC (1979-1988)
#   - Calculer les jours secs consécutifs (CDD)
#   - Fusionner les résultats en un seul fichier NetCDF
#   - Afficher des informations sur le fichier final
#
# Auteur: Mardochet Gédéon LEKOUNDA
# ============================================================

set -e  # arrêter le script en cas d'erreur

# ============================
# 1. Configuration
# ============================
START_YEAR=1979
END_YEAR=1988
DATA_DIR="data"
CDD_DIR="cdd"
FINAL_FILE="cdd_final.nc"

mkdir -p $DATA_DIR $CDD_DIR

# ============================
# 2. Téléchargement des données
# ============================
echo "=== Téléchargement des données CPC ==="
cd $DATA_DIR

for year in $(seq $START_YEAR $END_YEAR); do
    FILE="precip.${year}.nc"
    URL="https://downloads.psl.noaa.gov/Datasets/cpc_global_precip/${FILE}"
    
    if [ ! -f "$FILE" ]; then
        echo "Téléchargement de $FILE..."
        wget -q $URL
    else
        echo "$FILE déjà téléchargé"
    fi
done

cd ..

# ============================
# 3. Calcul des jours secs (precip < 1 mm)
# ============================
echo "=== Calcul des jours secs ==="

for year in $(seq $START_YEAR $END_YEAR); do
    cdo -ltc,1 $DATA_DIR/precip.${year}.nc $CDD_DIR/dry_${year}.nc

done

# ============================
# 4. Calcul du CDD
# ============================
echo "=== Calcul du CDD (Consecutive Dry Days) ==="

for year in $(seq $START_YEAR $END_YEAR); do
    cdo eca_cdd $CDD_DIR/dry_${year}.nc $CDD_DIR/cdd_${year}.nc
done

# ============================
# 5. Fusion des fichiers (méthode 1: CDO)
# ============================
echo "=== Fusion des fichiers CDD ==="

cdo mergetime $CDD_DIR/cdd_*.nc $FINAL_FILE

# ============================
# 6. Vérification des time steps
# ============================
echo "=== Nombre de pas de temps ==="

cdo ntime $FINAL_FILE

# ============================
# 7. Affichage des informations NetCDF
# ============================
echo "=== Informations NetCDF (CDO) ==="
cdo sinfo $FINAL_FILE

echo "=== Informations NetCDF (ncdump) ==="
ncdump -h $FINAL_FILE

# optionnel si NCO installé
if command -v ncks &> /dev/null; then
    echo "=== Informations NetCDF (NCO) ==="
    ncks -m $FINAL_FILE
fi

# ============================
# 8. Fin
# ============================
echo "=== Pipeline terminé avec succès ==="
