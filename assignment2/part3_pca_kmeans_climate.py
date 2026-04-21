# ============================================================
# Script: pca_kmeans_climate.py
# Objectif:
#   - Appliquer PCA et K-means sur précipitations
#   - Visualiser et comparer les résultats
# ============================================================

import xarray as xr
import numpy as np
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler

# ============================
# 1. Charger les données
# ============================
ds = xr.open_dataset("CRU_Africa_ts4.05.1901.2020.pre.nc")
pr = ds['pre']

# ============================
# 2. Préparation des données
# ============================
# reshape (time, lat, lon) -> (time, pixels)
data = pr.values
time, lat, lon = data.shape

X = data.reshape(time, lat * lon)

# supprimer NaN
mask = ~np.isnan(X).any(axis=0)
X = X[:, mask]

# standardisation
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# ============================
# 3. PCA
# ============================
pca = PCA(n_components=3)
X_pca = pca.fit_transform(X_scaled)

print("Variance expliquée :", pca.explained_variance_ratio_)

# visualisation
plt.figure()
plt.plot(np.cumsum(pca.explained_variance_ratio_), marker='o')
plt.title("Cumulative Explained Variance (PCA)")
plt.xlabel("Number of components")
plt.ylabel("Variance")
plt.grid()
plt.savefig("pca_variance.png", dpi=300)

# ============================
# 4. K-means clustering
# ============================
kmeans = KMeans(n_clusters=4, random_state=42)
labels = kmeans.fit_predict(X_scaled.T)

# reconstruire carte
cluster_map = np.full(lat * lon, np.nan)
cluster_map[mask] = labels
cluster_map = cluster_map.reshape(lat, lon)

plt.figure()
plt.imshow(cluster_map, origin='lower')
plt.colorbar(label="Cluster")
plt.title("K-means Clustering (Precipitation)")
plt.savefig("kmeans_clusters.png", dpi=300)

# ============================
# 5. PCA spatial patterns
# ============================
# composantes principales (EOF-like)
pc1 = pca.components_[0]
pc_map = np.full(lat * lon, np.nan)
pc_map[mask] = pc1
pc_map = pc_map.reshape(lat, lon)

plt.figure()
plt.imshow(pc_map, origin='lower', cmap='RdBu')
plt.colorbar(label="PC1")
plt.title("PCA - First Component")
plt.savefig("pca_pc1.png", dpi=300)

print("Analyse terminée.")