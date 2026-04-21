#!/bin/bash

# ============================================================
# Script: part11_netcdf.sh
# Objective:
#   - Download CPC data (1979-1988)
#   - Calculate consecutive dry days (CDD)
#   - Merge results into a single NetCDF file
#   - Display information about the final file
#
# Author: Mardochet Gédéon LEKOUNDA
# ============================================================

set -e  # Stop script in case of error

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
# 2. Download data
# ============================
echo "=== Downloading CPC data ==="
cd $DATA_DIR

for year in $(seq $START_YEAR $END_YEAR); do
    FILE="precip.${year}.nc"
    URL="https://downloads.psl.noaa.gov/Datasets/cpc_global_precip/${FILE}"
    
    if [ ! -f "$FILE" ]; then
        echo "Downloading $FILE..."
        wget -q $URL
    else
        echo "$FILE already downloaded"
    fi
done

cd ..

# ============================
# 3. Calculate dry days (precip < 1 mm)
# ============================
echo "=== Calculating dry days ==="

for year in $(seq $START_YEAR $END_YEAR); do
    cdo -ltc,1 $DATA_DIR/precip.${year}.nc $CDD_DIR/dry_${year}.nc

done

# ============================
# 4. Calculate CDD
# ============================
echo "=== Calculate CDD (Consecutive Dry Days) ==="

for year in $(seq $START_YEAR $END_YEAR); do
    cdo eca_cdd $CDD_DIR/dry_${year}.nc $CDD_DIR/cdd_${year}.nc
done

# ============================
# 5. Merge files (method 1: CDO)
# ============================
echo "=== Merging CDD files ==="

cdo mergetime $CDD_DIR/cdd_*.nc $FINAL_FILE

# ============================
# 6. Timesteps verification
# ============================
echo "=== Number of timesteps ==="

cdo ntime $FINAL_FILE


# 7. NetCDF display information
# ============================
echo "=== NetCDF Information (CDO) ==="
cdo sinfo $FINAL_FILE

echo "=== NetCDF Information (ncdump) ==="
ncdump -h $FINAL_FILE

# optionnel
if command -v ncks &> /dev/null; then
    echo "=== NetCDF Information (NCO) ==="
    ncks -m $FINAL_FILE
fi

# ============================
# 8. End
# ============================
echo "=== Pipeline completed successfully ==="
