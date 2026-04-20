#!/bin/bash

INPUT="GMFD_Africa_tas_daily_1948_2008.nc"

# 1. Conversion  Kelvin → Celsius
cdo subc,273.15 $INPUT tas_celsius.nc

# 2. Creation masque days > 35°C
cdo gec,35 tas_celsius.nc hot_days_mask.nc

# 3. Number of days >35°C (climatologie)
cdo timsum hot_days_mask.nc hot_days_count.nc

echo "Processing completed: hot_days_count.nc"