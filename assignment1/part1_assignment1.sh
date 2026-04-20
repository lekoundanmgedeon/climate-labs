#!/bin/bash

# creation of folder 

mkdir -p ~/climate_lab/PRECIP
cd ~/climate_lab/PRECIP

# Base URL
BASE_URL="https://data.chc.ucsb.edu/products/CHIRPS-2.0/global_daily/netcdf/p25"

# loop for year
for year in $(seq 1983 2016)
do
    echo "Downloading year $year ..."
    wget -r -np -nH --cut-dirs=6 -A "*.nc" ${BASE_URL}/${year}/
done

echo "Download completed."