import xarray as xr
import numpy as np
import matplotlib.pyplot as plt
from minisom import MiniSom
from sklearn.preprocessing import StandardScaler
from mpl_toolkits.basemap import Basemap
# -----------------------------
# 1. Load NetCDF data
# -----------------------------
file = "GMFD/GMFD_Africa_tas_daily_1948_2008_degC.nc"          # your file
var_name = "tas"  # change variable

ds = xr.open_dataset(file)
data = ds[var_name]

# Get coordinates
lat = ds['latitude'].values
lon = ds['longitude'].values

# -----------------------------
# 2. Compute anomalies (recommended)
# -----------------------------
climatology = data.groupby("time.dayofyear").mean("time")
anomalies = data.groupby("time.dayofyear") - climatology

# Fill missing values
anomalies = anomalies.fillna(0)
anomalies=np.squeeze(anomalies)
# -----------------------------
# 3. Reshape data
# -----------------------------
time_dim = anomalies.shape[0]
lat_size = anomalies.shape[1]
lon_size = anomalies.shape[2]

X = anomalies.values.reshape(time_dim, lat_size * lon_size)

# Normalize
X = StandardScaler().fit_transform(X)

# -----------------------------
# 4. Train SOM Training a Self-Organizing Map (SOM) involves initializing the map, feeding in your data, and iteratively updating the node weights so that similar inputs cluster together
# -----------------------------
som_x, som_y = 4, 4  # grid size

som = MiniSom(som_x, som_y, X.shape[1],
              sigma=1.0, learning_rate=0.5, random_seed=42)

som.random_weights_init(X)

print("Training SOM...")
som.train_random(X, 10000)

# -----------------------------
# 5. Get clusters: grouping similar nodes (or data points) based on the learned weight patterns. There are a few common ways to do this depending on what you want:
# -----------------------------
winner_coordinates = np.array([som.winner(x) for x in X])
clusters = np.ravel_multi_index(winner_coordinates.T, (som_x, som_y))

# -----------------------------
# 6. Plot spatial patterns
# -----------------------------
weights = som.get_weights()  # (som_x, som_y, features)

# Global color scale for consistency
vmin = weights.min()
vmax = weights.max()

fig, axes = plt.subplots(som_x, som_y, figsize=(10, 10))

for i in range(som_x):
    for j in range(som_y):
        ax = axes[i, j]

        # Reshape to map
        pattern = weights[i, j].reshape(lat_size, lon_size)

        # Set up Basemap
        m = Basemap(projection='cyl',
                    llcrnrlat=-40, urcrnrlat=40,
                    llcrnrlon=-20, urcrnrlon=53,
                    ax=ax, resolution='c')

        # Create meshgrid for lon/lat
        lon2d, lat2d = np.meshgrid(lon, lat)
        # Reshape to map
        pattern = weights[i, j].reshape(lat_size, lon_size)

        # Plot with pcolormesh
        im = m.pcolormesh(lon2d, lat2d, pattern,
                          shading='auto',
                          cmap='RdBu_r',
                          vmin=vmin, vmax=vmax)

        # Add coastlines or map features
        m.drawcoastlines()
        m.drawcountries()

        ax.set_title(f"Node ({i},{j})")
        ax.set_xlabel("Lon")
        ax.set_ylabel("Lat")
        
        
# Add ONE vertical colorbar for all subplots
#cbar = fig.colorbar(im, ax=axes, orientation='vertical', fraction=0.02, pad=0.04)
# Leave space on the right
fig.subplots_adjust(right=0.85)

# Add colorbar in that space
cbar_ax = fig.add_axes([0.88, 0.15, 0.02, 0.7])
fig.colorbar(im, cax=cbar_ax)
cbar = fig.colorbar(im, cax=cbar_ax)
#cbar.set_label("Anomaly (normalized)")

plt.suptitle("SOM Spatial Patterns (All Nodes)", fontsize=14)
plt.tight_layout(rect=[0, 0, 0.85, 1])
plt.show()

# -----------------------------
# 7. Plot cluster evolution over time
# -----------------------------
#plt.figure(figsize=(10, 4))
#plt.plot(clusters, marker='o', linestyle='-')
#plt.title("SOM Cluster Assignment Over Time")
#plt.xlabel("Time index")
#plt.ylabel("Cluster ID")
#plt.grid()
#plt.show()

import numpy as np

# Count occurrences
unique, counts = np.unique(clusters, return_counts=True)

# Total number of samples
total = len(clusters)

# Print percentage table
print("Node\tPercentage (%)")
for u, c in zip(unique, counts):
    print(f"{u}\t{(c/total)*100:.2f}") 
    

