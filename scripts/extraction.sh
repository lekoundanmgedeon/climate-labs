#!/bin/bash

# =========================
# CONFIGURATION DES DOSSIERS
# =========================

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

INDIR="${BASE_DIR}/data"
OUTDIR="${BASE_DIR}/ncfiles"

INPUT_FILE="${INDIR}/CRU_Africa_ts4.05.1901.2020.pre.nc"

mkdir -p "${OUTDIR}"

echo "Starting processing..."
echo "Input: ${INPUT_FILE}"
echo "Output directory: ${OUTDIR}"

# =========================
# PARAMÈTRES TEMPORELS
# =========================

iyear=1931
fyear=1960

# =========================
# 1. EXTRACTION PÉRIODE
# =========================

echo "Extracting years ${iyear}-${fyear}..."

cdo selyear,${iyear}/${fyear} \
    "${INPUT_FILE}" \
    "${OUTDIR}/afr_cru_1931_1960.nc"

# =========================
# 2. MOYENNE ANNUELLE
# =========================

echo "Computing annual cycle..."

cdo yearmonmean \
    "${OUTDIR}/afr_cru_1931_1960.nc" \
    "${OUTDIR}/afr_cru_1931_1960_yearmean.nc"

# =========================
# 3. ANOMALIES STANDARDISÉES
# =========================

echo "Computing standardized anomalies..."

cdo div \
    -sub "${OUTDIR}/afr_cru_1931_1960_yearmean.nc" \
    -timmean "${OUTDIR}/afr_cru_1931_1960_yearmean.nc" \
    -timstd "${OUTDIR}/afr_cru_1931_1960_yearmean.nc" \
    "${OUTDIR}/afr_cru_1931_1960_ano_std.nc"

# =========================
# 4. NETTOYAGE INTERMÉDIAIRE
# =========================

rm -f \
    "${OUTDIR}/afr_cru_1931_1960.nc" \
    "${OUTDIR}/afr_cru_1931_1960_yearmean.nc"

# =========================
# 5. STATIONS
# =========================

stations=(Abidjan Yamoussoukro Dakar Saint-Louis Lome Koforidua Accra Ilorin Douala Nairobi)

lons=(-3.93 -5.35 -17.5 -16.45 1.25 -0.25 -0.17 4.58 9.73 36.76)

lats=(5.25 6.90 14.73 16.05 6.17 6.08 5.6 8.48 4.0 -1.3)

# =========================
# 6. INTERPOLATION PAR STATION
# =========================

echo "Running station interpolation..."

for k in $(seq 0 9); do

    station=${stations[$k]}
    lon=${lons[$k]}
    lat=${lats[$k]}

    echo "Processing ${station} (${lon}, ${lat})"

    # Nearest neighbor
    cdo remapnn,lon=${lon}/lat=${lat} \
        "${OUTDIR}/afr_cru_1931_1960_ano_std.nc" \
        "${OUTDIR}/afr_cru_1931_1960_remapnn_${station}.nc"

    # Distance-weighted interpolation
    cdo remapdis,lon=${lon}/lat=${lat} \
        "${OUTDIR}/afr_cru_1931_1960_ano_std.nc" \
        "${OUTDIR}/afr_cru_1931_1960_remapdis_${station}.nc"

done

echo "Processing completed successfully!"










