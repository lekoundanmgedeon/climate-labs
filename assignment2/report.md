# Climate Data Analysis Report

**Dataset:** CRU_Africa_ts4.05.1901.2020.pre.nc
**Focus:** Precipitation Analysis over Senegal
**Tools:** CDO, Python (xarray, matplotlib, sklearn)

---

# 1. Introduction

Climate variability plays a critical role in understanding environmental changes, particularly in Africa where rainfall strongly influences agriculture, water resources, and livelihoods.

This project analyzes precipitation data using:

* Extreme climate indices (CDD)
* Climatological analysis
* Machine learning techniques (PCA & K-means)

---

# 2. Part 1: NetCDF / CDO Extremes

## 2.1 Data Download

Daily precipitation data for the period **1979–1988** were downloaded from the CPC dataset.

---

## 2.2 Consecutive Dry Days (CDD)

CDD is defined as the **maximum number of consecutive days with precipitation below 1 mm**.

### Method:

1. Identify dry days:

```bash
cdo -ltc,1 precip.nc dry.nc
```

2. Compute CDD:

```bash
cdo eca_cdd dry.nc cdd.nc
```

---

## 2.3 Variables in the Dataset

| Variable | Dimensions       | Units |
| -------- | ---------------- | ----- |
| precip   | (time, lat, lon) | mm    |

There is only **one multidimensional variable**, which is precipitation.

---

## 2.4 Merging Files

Three methods were used:

* Using CDO:

```bash
cdo mergetime cdd_*.nc cdd_final.nc
```

* Using NCO:

```bash
ncrcat cdd_*.nc cdd_final.nc
```

* Iterative merging using a loop

---

## 2.5 Time Steps

The dataset contains approximately:

* **3650–3652 time steps** (daily data over 10 years)

---

## 2.6 NetCDF Inspection Tools

* `cdo sinfo`
* `ncdump -h`
* `ncks -m`

---

# 3. Part 2: Climatology Analysis (Python)

## 3.1 Mean Climatology

The mean precipitation over Senegal reveals:

* Higher rainfall in the southern regions
* Lower rainfall in the northern regions (Sahelian influence)

---

## 3.2 Seasonal Climatology

| Season | Description          |
| ------ | -------------------- |
| DJF    | Dry season           |
| MAM    | Transition period    |
| JJA    | Peak rainfall season |
| SON    | Declining rainfall   |

### Key Observation:

* Maximum rainfall occurs during **JJA (June–August)**
* Minimum rainfall occurs during **DJF**

---

## 3.3 Annual Cycle

The mean annual cycle shows:

* Peak rainfall: **August–September**
* Minimum rainfall: **January–March**

This confirms a **monsoon-driven rainfall regime**.

---

#  4. Part 3: Data Classification (PCA & K-means)

## 4.1 PCA Analysis

Principal Component Analysis (PCA) is used to reduce dimensionality and identify dominant patterns in the dataset.

### Results:

* The first principal component (PC1) explains a large portion of variance (~50% or more)
* PC1 represents a **wet vs dry spatial gradient**
* PC2 captures secondary regional variability

### Interpretation:

PCA highlights large-scale climatic structures across Africa.

---

## 4.2 K-means Clustering

K-means clustering groups regions with similar precipitation characteristics.

### Identified Clusters:

1. Humid regions (Equatorial Africa)
2. Tropical regions (seasonal rainfall)
3. Semi-arid regions (Sahel)
4. Arid regions (Sahara)

### Case of Senegal:

* Northern part → dry cluster
* Southern part → wetter cluster

---

## 4.3 PCA vs K-means Comparison

| Criteria | PCA                      | K-means                 |
| -------- | ------------------------ | ----------------------- |
| Type     | Dimensionality reduction | Clustering              |
| Output   | Continuous components    | Discrete classes        |
| Insight  | Global patterns          | Regional classification |

### Conclusion:

* PCA reveals the **structure of climate variability**
* K-means provides an **interpretable spatial classification**

---

# 5. Conclusion

This study demonstrates that:

* CDD is effective for detecting drought characteristics
* Senegal’s climate exhibits strong seasonal variability
* PCA and K-means provide complementary insights:

  * PCA → large-scale variability patterns
  * K-means → spatial climate classification

These approaches are valuable for climate monitoring and agricultural planning.

---

# 6. Future Work

* Use shapefiles for precise country masking
* Analyze temperature alongside precipitation
* Investigate long-term climate trends
* Apply deep learning methods for climate pattern recognition

---

# 7. Outputs

Generated figures include:

* Mean climatology map
* Seasonal climatology maps (DJF, MAM, JJA, SON)
* Annual cycle plot
* PCA variance plot
* PCA spatial pattern map
* K-means clustering map

---

# 8. References

* CRU TS Dataset
* CPC Global Precipitation Dataset
* Climate Data Operators (CDO) Documentation
* Scikit-learn Documentation

---
