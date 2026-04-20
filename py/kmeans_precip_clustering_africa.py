import xarray as xr
import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
import cartopy.crs as ccrs
import cartopy.feature as cfeature
from cartopy.mpl.ticker import LongitudeFormatter, LatitudeFormatter
from matplotlib.colors import ListedColormap, BoundaryNorm
import matplotlib.ticker as mticker


path = '/home/students-aimssn/Documents/climate_lab/data/'
# Load the precipitation data from the NetCDF file
file_path = path + 'CRU_Africa_ts4.05.1901.2020.pre.nc'
ds = xr.open_dataset(file_path)

# Extract the precipitation ('pre') variable
precip = ds['pre']
lat= ds['lon']
lon= ds['lat']
lat2d, lon2d = np.meshgrid(lat, lon)
# Handle missing values
precip = precip.where(precip != 9.96921e+36, np.nan)


# Select a specific time period (e.g., 1980-2020)
precip = precip.sel(time=slice('1980-01-01', '2020-12-31'))

# Reshape the data for K-Means clustering
n_time, n_lat, n_lon = len(precip.time), len(precip.lat), len(precip.lon)
precip_reshaped = precip.values.reshape(n_time, n_lat * n_lon).T

print (precip_reshaped.shape)
# Standardize the data
precip_standardized = StandardScaler().fit_transform(np.nan_to_num(precip_reshaped))

print (precip_standardized.shape, precip_standardized.min(), precip_standardized.max() )
# Apply K-Means clustering
n_clusters = 10
kmeans = KMeans(n_clusters=n_clusters, random_state=42, n_init='auto')

cluster_labels = kmeans.fit_predict(precip_standardized)

## Reshape the cluster labels to the spatial grid
cluster_map = cluster_labels.reshape(n_lat, n_lon)

## Mask data over oceans
land_mask = np.isfinite(precip.mean(dim='time').values)
masked_cluster_map = np.where(land_mask, cluster_map, np.nan)

## Define a physically meaningful colormap
colors = ['#d73027', '#f46d43', '#fdae61', '#fee08b', '#d9ef8b', '#a6d96a', '#66bd63', '#1a9850', '#006837', '#08306b']
physically_meaningful_cmap = ListedColormap(colors)
norm = BoundaryNorm(np.arange(-0.5, n_clusters + 0.5, 1), physically_meaningful_cmap.N)

## Plot the clustering map using Cartopy
plt.figure(figsize=(14, 10))
ax = plt.axes(projection=ccrs.PlateCarree())
ax.set_facecolor('white')

cluster_plot = ax.pcolormesh(lat2d, lon2d, masked_cluster_map, cmap=physically_meaningful_cmap, norm=norm, transform=ccrs.PlateCarree(), shading='auto')

## Add a colorbar
cbar = plt.colorbar(cluster_plot, ax=ax, pad=0.05)
cbar.set_ticks(np.arange(0, n_clusters, 1))
cbar.set_ticklabels([f'Cluster {i}' for i in range(n_clusters)])
cbar.set_label('K-Means Cluster Index', fontsize=14)
cbar.ax.tick_params(labelsize=12)

## Add geographic features
ax.coastlines(linewidth=1.5)
ax.add_feature(cfeature.BORDERS, linestyle='-', linewidth=1, edgecolor='gray')
ax.add_feature(cfeature.LAND, edgecolor='black')
ax.add_feature(cfeature.OCEAN, facecolor='lightblue')

## Latitude and longitude ticks
ax.set_xticks(np.arange(-30, 60, 10), crs=ccrs.PlateCarree())
ax.set_yticks(np.arange(-40, 40, 10), crs=ccrs.PlateCarree())
ax.tick_params(labelsize=12, labelcolor='black')

## Add formatted labels
ax.xaxis.set_major_formatter(LongitudeFormatter(degree_symbol='°'))
ax.yaxis.set_major_formatter(LatitudeFormatter(degree_symbol='°'))

## Title and labels
plt.title("K-Means Clustering Map of Precipitation Patterns (1980-2020)", fontsize=16, fontweight='bold')
plt.xlabel('Longitude', fontsize=14)
plt.ylabel('Latitude', fontsize=14)
plt.tight_layout()
plt.show()

