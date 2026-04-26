# ============================================================
# Script: climatology_analysis.py
# Objective:
#   - Compute precipitation climatology
#   - Mean, seasons (DJF, MAM, JJA, SON)
#   - Annual cycle
#   - Save as PNG
# ============================================================

import xarray as xr
import numpy as np
import matplotlib.pyplot as plt

# ============================
# 1. Load file
# ============================
file_path = "CRU_Africa_ts4.05.1901.2020.pre.nc"
ds = xr.open_dataset(file_path)

# Precipitation variable
pr = ds['pre']


# 2. Country selection (Senegal)
# ============================
# Approx bounding box Republic of the Congo (Congo-Brazzaville)
lat_min, lat_max = -5, 5
lon_min, lon_max = 11, 19

pr_country = pr.sel(lat=slice(lat_min, lat_max),
                    lon=slice(lon_min, lon_max))

# ============================
# 3. Mean climatology
# ============================
mean_clim = pr_country.mean(dim="time")

plt.figure()
mean_clim.plot()
plt.title("Mean Climatology (Precipitation)")
plt.savefig("mean_climatology.png", dpi=300)

# ============================
# 4. Seasonal climatology
# ============================
seasons = {
    "DJF": [12, 1, 2],
    "MAM": [3, 4, 5],
    "JJA": [6, 7, 8],
    "SON": [9, 10, 11]
}

for season, months in seasons.items():
    pr_season = pr_country.sel(time=pr_country['time.month'].isin(months))
    clim_season = pr_season.mean(dim="time")

    plt.figure()
    clim_season.plot()
    plt.title(f"{season} Climatology")
    plt.savefig(f"{season}_climatology.png", dpi=300)

# ============================
# 5. Mean annual cycle
# ============================
monthly_clim = pr_country.groupby("time.month").mean(dim="time")

# moyenne spatiale (sur tout le pays)
monthly_mean = monthly_clim.mean(dim=["lat", "lon"])

plt.figure()
monthly_mean.plot(marker='o')
plt.title("Mean Annual Cycle (Precipitation)")
plt.xlabel("Month")
plt.ylabel("Precipitation (mm)")
plt.grid()

plt.savefig("annual_cycle.png", dpi=300)

# 6. End
# ============================
print("Analysis completed. PNGs saved.")