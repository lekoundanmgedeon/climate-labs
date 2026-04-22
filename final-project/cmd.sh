#!/bin/bash

INPUT="CRU_Africa_ts4.05.1901.2020.pre.nc"

# 1  Identify Coordinates & Country 

# Northern Africa includes the following countries:
# - Morocco
# - Algeria
# - Tunisia
# - Libya
# - Egypt
# - Sahara occidental

# 2. Sub region Nothern Africa
# Latitude: 15°N to 37°N
# Longitude: -17° to 35°
# These boundaries capture both Mediterranean coastal regions and the Sahara Desert

cdo sellonlatbox,-17,35,15,37 $INPUT north_africa.nc

# 3 : Compute TX90p (warm days )
#  TX90p = proportion of days where the daily maximum temperature (TX) exceeds the 90th percentile 
#  of the reference period (1981–2010).

cdo ydaymax north_africa.nc tx_dailymax.nc

# Compute 90th percentile
cdo ydrunpctl,90,30 tx_dailymax.nc tx90p_ref.nc

# ydrunpctl compute mobile percentile (here 90).
# 30 = window of 30 days for seasonal smooth.

## Version 2 

cdo eca_tg90p NorthernAfrica_dailyTX.nc NorthernAfrica_ref.nc TX90p_NorthernAfrica.nc


#5 City selected 
# Alger (Algérie) : 36.75°N, 3.06°E
# Le Caire (Égypte) : 30.04°N, 31.24°E
# Tunis (Tunisie) : 36.80°N, 10.18°E
# Khartoum (Soudan) : 15.50°N, 32.56°E

cdo remapnn,lon=3.06_lat=36.75  NorthernAfrica.nc Alger.nc
cdo remapnn,lon=31.24_lat=30.04 NorthernAfrica.nc Cairo.nc
cdo remapnn,lon=10.18_lat=36.80 NorthernAfrica.nc Tunis.nc
cdo remapnn,lon=32.56_lat=15.50 NorthernAfrica.nc Khartoum.nc





