import xarray as xr
import numpy as np
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap

# Load data
ds = xr.open_dataset("GMFD/GMFD_Africa_tas_daily_1948_2008_degC.nc")
data = ds["tas"]
lon = ds["longitude"]
lat = ds["latitude"]


# Select season (example: JJA)
data_season = data.sel(time=data['time.season'] == 'JJA')

# Reshape
X = data_season.values.reshape(data_season.shape[0], -1)

# Normalize
X = StandardScaler().fit_transform(X)

# PCA
pca = PCA(n_components=3)
X_pca = pca.fit_transform(X)

print("Explained variance:", pca.explained_variance_ratio_)

# -----------------------------
# 4. Explained variance
# -----------------------------
explained_variance = pca.explained_variance_ratio_
print(explained_variance)


# 5. First principal component (time series)
# -----------------------------
pc1 = X_pca[:, 1]

plt.figure()
plt.plot(pc1)
plt.title("First Principal Component (PC1)")
plt.xlabel("Time Index")
plt.ylabel("PC1 Value")
plt.grid()
plt.show()


# 6. Spatial pattern of PC1
# -----------------------------
pc1_pattern = pca.components_[0].reshape(data.shape[1:])
pc1_pattern=np.squeeze(pc1_pattern)
fig=plt.figure()
ax= fig.add_subplot(111)
# Set up Basemap
m = Basemap(projection='cyl',llcrnrlat=-40, urcrnrlat=40,llcrnrlon=-20, urcrnrlon=53, ax=ax, resolution='c')
# Create meshgrid for lon/lat
lon2d, lat2d = np.meshgrid(lon, lat)
# Add coastlines or map features
m.drawcoastlines()
m.drawcountries()

im=m.pcolormesh(lon2d, lat2d, pc1_pattern, cmap='coolwarm')
plt.colorbar(im)
#plt.colorbar()
plt.title("Spatial Pattern of PC1")
plt.show()


filout= "pca.png"
fig.savefig(filout,dpi=300) 
