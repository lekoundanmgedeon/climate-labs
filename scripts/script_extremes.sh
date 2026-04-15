#!/bin/bash

#For the percentage of warm days:


#1-convert file from kelvin to degree C

#cdo addc,-273.15 GMFD_Africa_tas_daily_1948_2008.nc GMFD_Africa_tas_daily_1948_2008_degC.nc

##split data into yearly
#mkdir yearly
#cdo splityear GMFD_Africa_tas_daily_1948_2008_degC.nc yearly/

for  year  in  $(seq 1948 2008)

 do year=$year
  
#   echo ${year}


#2-compute 90th percentile
#      cdo ydrunmin,5 yearly/${year}.nc  yearly/ydrunmmin_${year}.nc
#      cdo ydrunmax,5 yearly/${year}.nc  yearly/ydrunmmax_${year}.nc


#      cdo ydrunpctl,90,5 yearly/${year}.nc yearly/ydrunmmin_${year}.nc    yearly/ydrunmmax_${year}.nc     T90TH_GMFD_Africa_${year}.nc

done

##mean climatology

#cdo timmean -mergetime T90TH_GMFD_Africa_*.nc    T90TH_GMFD_Africa_climatol.nc
cdo duplicate,366 T90TH_GMFD_Africa_climatol.nc   T90TH_GMFD_Africa_climatol_RF.nc

#3- calcul de TX90P: warm days 

#for  year  in  $(seq 1948 2008)

# do year=$year
  
#   echo ${year}

#      cdo showdate yearly/${year}.nc
#       cdo showdate T90TH_GMFD_Africa_climatol_RF.nc

#      cdo settaxis,$year-01-01,12:00:00,1day T90TH_GMFD_Africa_climatol_RF.nc T90TH_GMFD_Africa_climatol_RFF.nc
#      cdo eca_tx90p yearly/${year}.nc T90TH_GMFD_Africa_climatol_RFF.nc GMFD_Africa_day_${year}.nc      
#done

#cdo mergetime  GMFD_Africa_day_*.nc         tx90p_GMFD_Africa_day_1948_2008.nc




