#!/bin/bash


# CONFIGURATION
# ==============================
INPUT="CRU_Africa_ts4.05.1901.2020.pre.nc"
WORKDIR="part2_results"
mkdir -p $WORKDIR
cd $WORKDIR

echo "===== STARTING PART 2 PIPELINE ====="

# ==============================
# 1. Seasonal climatologie operation (MAMJJ, 1986–2015)
# ==============================
echo "Step 1: Seasonal climatology..."

cdo selyear,1986/2015 ../$INPUT period.nc
cdo selmon,3,4,5,6,7 period.nc mamjj.nc
cdo timmean mamjj.nc mamjj_climatology.nc


# 2. Extraction Afrique of l’Ouest + spatiale mean 
# ==================================================

echo "Step 2: West Africa extraction + spatial mean..."

cdo sellonlatbox,-20,20,0,25 mamjj_climatology.nc west_africa.nc
cdo fldmean west_africa.nc west_africa_mean.nc


# 3. Annual cycle 
# ==============================

echo "Step 3: Annual cycle..."

cdo ymonmean west_africa_mean.nc annual_cycle.nc


# 4. Visualization (ncview)
# ==============================

echo "Step 4: Opening ncview (export manually to cycle.ps)..."

ncview annual_cycle.nc &

# ==============================
# 5. Standar anomalies 
# ==============================
echo "Step 5: Standardized anomalies..."

cdo ymonmean ../$INPUT clim.nc
cdo ymonstd ../$INPUT std.nc
cdo sub ../$INPUT clim.nc anom.nc
cdo div anom.nc std.nc standardized_anom.nc


# 6. Stations République of Congo
# ================================ 

echo "Step 6: Creating station file (Congo)..."

cat <<EOF > stations_congo.txt
15.28 -4.27   # Brazzaville
11.86 -4.77   # Pointe-Noire
13.55 -1.87   # Dolisie
15.86 -1.58   # Nkayi
14.75 -0.49   # Owando
15.64 2.05    # Impfondo
EOF


# 7. Interpolation to stations
# ==============================

echo "Step 7: Interpolating to Congo stations..."

cdo remapdis,stations_congo.txt standardized_anom.nc stations_congo_data.nc


# 8. Vizualisation stations
# ==============================
echo "Step 8: Opening ncview for stations..."

ncview stations_data.nc &

echo "===== PIPELINE COMPLETED SUCCESSFULLY ====="
echo "Outputs are in: $WORKDIR"