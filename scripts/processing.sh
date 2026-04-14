#!/bin/bash

# =========================
# CONFIGURATION
# =========================

INDIR="../data"
OUTDIR="../ncfiles"
INPUT="${INDIR}/CRU_Africa_ts4.05.1901.2020.pre.nc"

mkdir -p "${OUTDIR}"

echo "Starting climate processing..."

# =========================
# a) Extract regions
# =========================

echo "Extracting Congo and Senegal regions..."

cdo sellonlatbox,11,19,-5,3 \
    "${INPUT}" \
    "${OUTDIR}/congo_precip.nc"

cdo sellonlatbox,-17,-11,12,17 \
    "${INPUT}" \
    "${OUTDIR}/senegal_precip.nc"

# =========================
# Info checks
# =========================

echo "File info (Senegal)..."
cdo sinfo "${OUTDIR}/senegal_precip.nc"

echo "Grid description..."
cdo griddes "${INPUT}"

echo "File info (Congo)..."
cdo sinfo "${OUTDIR}/congo_precip.nc"

# =========================
# b) Seasonal cycle (1981-2010)
# =========================

echo "Computing seasonal cycles (1981–2010)..."

# Congo full period selection
cdo selyear,1981/2010 \
    "${OUTDIR}/congo_precip.nc" \
    "${OUTDIR}/congo_1981_2010.nc"

# Seasonal cycle
cdo ymonmean \
    "${OUTDIR}/congo_1981_2010.nc" \
    "${OUTDIR}/congo_seasonal_cycle.nc"

# Dry season (May–Aug)
cdo selyear,1981/2010 -selmon,05,06,07,08 \
    "${OUTDIR}/congo_precip.nc" \
    "${OUTDIR}/congo_dry_season_1981_2010.nc"

cdo ymonmean \
    "${OUTDIR}/congo_dry_season_1981_2010.nc" \
    "${OUTDIR}/congo_mean_dry.nc"

# =========================
# c) Annual / monthly cycle (field mean)
# =========================

echo "Computing field mean (Congo)..."

cdo fldmean \
    "${OUTDIR}/congo_precip.nc" \
    "${OUTDIR}/congo_fieldmean.nc"

cdo ymonmean \
    "${OUTDIR}/congo_fieldmean.nc" \
    "${OUTDIR}/congo_fieldmonmean.nc"

echo "Processing completed successfully!"