#!/bin/bash


# CONFIGURATION
# ==============================

INDIR=~/climate_lab/PRECIP
OUTDIR=~/climate_lab/EXTREMES
mkdir -p $OUTDIR

cd $OUTDIR

echo "===== COMPUTING CWD ====="


# 1. merge all files
# ==============================

echo "Merging files..."

cdo mergetime $INDIR/*.nc precip_all.nc


# 2. Define dry days (>=1 mm)
# ==============================

echo "Creating wet day mask..."

cdo gec,1 precip_all.nc wet_days.nc


# 3. Calcul of annual CWD
# ==============================

echo "Computing consecutive wet days (CWD)..."

cdo yearmax -consects wet_days.nc cwd.nc

echo "===== DONE ====="
echo "Output file: cwd.nc"