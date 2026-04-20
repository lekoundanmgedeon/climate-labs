#!/bin/bash

# Write a script that downloads climate data from 1979 to 1983 from the Climate Prediction Center (CPC). Name the script exercise3.sh (link to the data: https://downloads.psl.noaa.gov/Datasets/cpc_global_temp/)


cpc=https://downloads.psl.noaa.gov/Datasets/cpc_global_precip

forecast=(1979 1980 1981 1982 1983)

# Loop through the specified forecast times wanted and grab GFS data
for i in "${forecast[@]}" 
do 
    wget -P /home/students-aimssn/Documents/climate_lab/data/ ${cpc}/precip.${i}.nc
done
