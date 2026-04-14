#!/bin/bash 

iyear=1931
fyear=1960

indir='/home/students-aimssn/Documents/climate_lab/'
outdir='/home/students-aimssn/Documents/climate_lab/out_data/'

mkdir -p ${outdir}

# select the period from 1931 to 1960
cdo selyear,${iyear}/${fyear} ${indir}/CRU_Africa_ts4.05.1901.2020.pre.nc  ${outdir}/afr_cru_1931_1960.nc

# compute annual mean from multi year monthly data  
# you could also compute annual/seasonal cycle by cdo ymonmean  
cdo yearmonmean ${outdir}/afr_cru_1931_1960.nc ${outdir}/afr_cru_1931_1960_yearmean.nc
cd ${outdir}
#pwd; ls

# compute standardized anomalies
cdo div -sub afr_cru_1931_1960_yearmean.nc -timmean afr_cru_1931_1960_yearmean.nc -timstd afr_cru_1931_1960_yearmean.nc afr_cru_1931_1960_ano_std.nc

rm -f afr_cru_1931_1960.nc afr_cru_1931_1960_yearmean.nc 

stations=( Abidjan Yamoussoukro  Dakar Saint-Louis Lome Koforidua Accra  Ilorin Douala  Nairobi)
lons=( -3.93 -5.35  -17.5 -16.45 1.25 -0.25 -0.17 4.58 9.73 36.76)
lats=(  5.25  6.90 14.73 16.05  6.17  6.08  5.6  8.48 4.0 -1.3)


for k in $(seq 0 9); do
    # nearest neighbour interpolation
    cdo remapnn,lon=${lons[k]}/lat=${lats[k]} afr_cru_1931_1960_ano_std.nc afr_cru_1931_1960_remapnn_${stations[k]}.nc
    # weighted averaged interpolation
    cdo remapdis,lon=${lons[k]}/lat=${lats[k]} afr_cru_1931_1960_ano_std.nc afr_cru_1931_1960_remapbil_${stations[k]}.nc

done











