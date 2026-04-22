import xarray as xr
import matplotlib.pyplot as plt

# Charger le fichier NetCDF
ds = xr.open_dataset("TX90p_NorthernAfrica.nc")

# Moyenne spatiale
tx90p_mean = ds['TX90p'].mean(dim='time')

# Carte
plt.figure(figsize=(10,6))
tx90p_mean.plot(cmap='hot', robust=True)
plt.title("Distribution spatiale des TX90p (1981–2010)")
plt.xlabel("Longitude")
plt.ylabel("Latitude")
plt.show()

#===================================================================================================

## SCRIPT 2 : DRAW ANOMALIE 
import xarray as xr
import matplotlib.pyplot as plt

cities = {
    "Alger": ("Alger.nc", "blue"),
    "Cairo": ("Cairo.nc", "red"),
    "Tunis": ("Tunis.nc", "green"),
    "Khartoum": ("Khartoum.nc", "orange")
}

plt.figure(figsize=(12,6))

for city, (file, color) in cities.items():
    ds = xr.open_dataset(file)
    ts = ds['TX'].groupby('time.season').mean('time')  # saison
    anomalies = (ts - ts.mean()) / ts.std()            # standardisation
    anomalies.plot(label=city, color=color)

plt.title("Anomalies saisonnières standardisées (TX)")
plt.xlabel("Saison")
plt.ylabel("Anomalie standardisée")
plt.legend()
plt.show()

##==================================================================================================
## PCA 

import xarray as xr
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt

# Charger données TX90p
ds = xr.open_dataset("TX90p_NorthernAfrica.nc")
data = ds['TX90p'].values.reshape(len(ds.time), -1)  # temps x espace

# PCA
pca = PCA(n_components=2)
pcs = pca.fit_transform(data)

plt.figure(figsize=(10,5))
plt.plot(pcs[:,0], label="PC1")
plt.plot(pcs[:,1], label="PC2")
plt.title("PCA des anomalies TX90p")
plt.legend()
plt.show()

## SOM

from minisom import MiniSom
import numpy as np

# Normaliser données
data_norm = (data - np.mean(data, axis=0)) / np.std(data, axis=0)

# SOM 6x6
som = MiniSom(6, 6, data_norm.shape[1], sigma=1.0, learning_rate=0.5)
som.random_weights_init(data_norm)
som.train_random(data_norm, 1000)

# Visualisation des clusters
win_map = som.win_map(data_norm)


