#!/bin/env python 

import scipy.stats
import numpy as N
import scipy.stats
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
from netCDF4 import Dataset
import netCDF4
import time
import pandas as pd
import numpy.ma as ma
import matplotlib.pyplot as plt,  numpy as np
from matplotlib.colors import BoundaryNorm
import cartopy.crs as ccrs
import cartopy.feature as cfeat
from cartopy.mpl.gridliner import LONGITUDE_FORMATTER, LATITUDE_FORMATTER
from datetime import datetime
import os
from scipy import stats 


##########################################################################################
##########################################################################################
##########################################################################################

#====================precipitation CRU================

ncfile0= 'cru_year_cum.nc'

# Ouvrir un fichier nectdf : faites ncdump - h pour voir les variables ; ex:  pr(time, rlat, rlon)
#====================precipitation================

ncfile1 = Dataset(ncfile0, 'r', format='NETCDF4')
pre= ncfile1.variables['pre'][:,:,:] 
lats = ncfile1.variables['lat'][:]
lons = ncfile1.variables['lon'][:]
time = ncfile1.variables['time']
ncfile1.close()

###select senegal box; ##lon1=-18, lon2=-11; lat1=12; ;lat2=17 
LatMin = 12.
LatMax = 17.
LonMin = -18.
LonMax = -11.0

##create latitude and longitude indices 
IxLat = np.where((lats >= LatMin)&(lats <= LatMax))[0]
IxLon = np.where((lons >= LonMin)&(lons <= LonMax))[0]
print (IxLat)

pre_sn =   pre[:,:,:][:,IxLat,:][:,:,IxLon]
print (pre_sn.shape)

pre_moy = np.mean(pre_sn,axis=(1,2))#moyenne sur les dimensions longitude et latitude; correspondant au field mean avec cdo 
print (pre_moy)


years=np.arange(1901,2021)
#print (years)


fig, ax = plt.subplots(figsize=(10,7))

ax.plot(years, pre_moy, marker = 'o', color = 'blue',label='Rainfall',linestyle='dashed',linewidth=2)
slope, intercept = np.polyfit(years, pre_moy, 1)

#r, p = stats.pearsonr(years, pre_moy)##correlation coefficient and p-value
#print (r,p)

print(slope)
print(intercept)

ax.set_xlabel('Years', fontsize=18)

ax.set_ylabel('Rainfall', fontsize=18)

ax.set_title('a) CRU Observations',fontsize=18)

ax.set_xlim(years[0],years[-1])
ax.tick_params(axis='x', rotation=70)

slope, intercept = np.polyfit(years, pre_moy, 1)
trend = intercept + (slope * years)
      
ax.plot(years, trend, color='red', label='Tendance Linéaire ', linestyle='--')  
ax.legend(loc='lower left')

    
ax.legend(fancybox=True, framealpha=1, shadow=True ,borderpad=1, ncol=1)
plt.grid()

plt.show()


filout= "tendance.png"
fig.savefig(filout,dpi=300) 

