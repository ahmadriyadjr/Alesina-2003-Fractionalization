# Replication: Alesina et al. (2003) "Fractionalization"

## Overview
This project replicates selected results from Alesina, Devleeschauwer, Easterly, Kurlat, and Wacziarg (2003), "Fractionalization," *Journal of Economic Growth* 8(2): 155–194.

The paper constructs ethnic, linguistic, and religious fractionalization indices for approximately 190 countries and examines their relationship with economic growth and governance outcomes. This replication focuses on:

1. Verifying the fractionalization indices against the paper's Table 1 summary statistics
2. Replicating the governance regressions (Tables 12b and 12f) using modern cross-sectional data

## Data
This replication uses the **Quality of Government (QoG) Standard Cross-Section dataset (January 2026)**, available at:
https://www.gu.se/en/quality-government/qog-data

Download the Stata (.dta) format file and place it in the `data/` folder as `qog_std_cs_jan26.dta`.

**Note:** The raw data file is not included in this repository. The cleaned dataset (`data/df_clean.csv`) is provided for convenience.

## How to Run
Run the scripts in order:

1. `scripts/01_load_and_clean.R` — loads QoG data, selects variables, verifies fractionalization indices against Table 1, saves clean dataset
2. `scripts/02_analysis.R` — runs OLS regressions with robust standard errors, exports results table

Required packages: `tidyverse`, `haven`, `sandwich`, `lmtest`, `stargazer`

## Results
Replication results are saved in `output/replication_results.txt`.

| Outcome | Paper Coefficient | Our Coefficient | Match? |
|---|---|---|---|
| GDP Per Capita Growth | -0.019 | +0.483 (n.s.) | No — see note |
| Log Infant Mortality | +0.442*** | +0.804*** | Yes (sign + significance) |
| Corruption (V-Dem) | +0.287*** | +0.257*** | Yes (sign, significance, magnitude) |

**Note on GDP growth divergence:** The paper's growth regression uses decade-averaged panel data from 1960–1990 (Easterly & Levine 1997). Our single modern cross-section cannot replicate this structure. The governance results (infant mortality, corruption) use a simple cross-section and replicate cleanly.

## Citation
Alesina, A., Devleeschauwer, A., Easterly, W., Kurlat, S., & Wacziarg, R. (2003). Fractionalization. *Journal of Economic Growth*, 8(2), 155–194.


