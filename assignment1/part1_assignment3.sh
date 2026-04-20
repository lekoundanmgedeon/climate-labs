#!/bin/bash

INPUT="CRU_Africa_ts4.05.1901.2020.pre.nc"

# 0. Sub region (11, 19, -5, 3) Congo-Republic 
cdo sellonlatbox,11,19,-5,3 $INPUT congo.nc

# 1. Select 1991–2020 period
cdo selyear,1991/2020 congo.nc period.nc

# 2. Select JJA season
cdo selmon,6,7,8 period.nc jja.nc

# 3. Mean climatologique JJA
cdo timmean jja.nc jja_climatology.nc

# 4. Compute anomalies
cdo sub jja.nc jja_climatology.nc jja_anomalies.nc

echo "JJA anomalies computed."

