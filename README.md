# Who benefits from food tax exemptions in lower-income settings? Evidence on pass-through and incidence (Papua New Guinea)

Replication package (code and documentation). This repository holds the code that produces every exhibit in the paper and appendix. Data are not included; see [Data availability](#data-availability).

## Contents

1. [Overview](#overview)
2. [Data availability](#data-availability)
3. [Instructions for replicators](#instructions-for-replicators)
4. [List of exhibits](#list-of-exhibits)
5. [Requirements](#requirements)
6. [Code description](#code-description)
7. [Folder structure](#folder-structure)

## Overview

The analysis runs in three stages: Stata prepares the data, R builds two maps, then Stata runs the analysis, tables, and figures. Two master scripts drive it:

- `main.do` (Stata): sets one path, installs packages, builds the `Final/` datasets, pauses for the R stage, then runs all analysis.
- `main.R` (R): sets one path, builds Figures 1 and 2, and writes two intermediate datasets the Stata analysis reads.

A reviewer runs the whole package after changing one line in each master script (the top-level directory). Nothing else needs editing.

## Data availability

Some data cannot be made publicly available, so this repository ships code and documentation only. No raw or intermediate data is included. Before running, place the data under a `Data/` folder matching the paths in `main.do` Section 1. The full statement, with every source, its access route, and shareability, is in [`docs/data_availability.md`](docs/data_availability.md).

Origin of each input:

- Phone survey microdata (household food module): World Bank High-Frequency Phone Survey, Papua New Guinea. Restricted household microdata, obtained through the World Bank survey team and Microdata Library. Not redistributable.
- Expert prediction survey: own collection via Qualtrics. Respondent-level, restricted. Available from the authors de-identified on request.
- 2011 census population by district: PNG National Statistical Office, distributed through HDX (https://data.humdata.org/dataset/cod-ps-png). Public aggregate.
- Store price collection (Port Moresby): own field collection. Available from the authors on request.
- Online store prices: own collection via web scraping of `rhtradingpng.com` and `fpr.com.pg` (see below).
- Retail Price Index and Business Sentiment Survey: Bank of Papua New Guinea, obtained by data request. Restricted, not redistributable.
- NSO administrative prices and CPI (including the December 2025 quarterly CPI release): PNG National Statistical Office, obtained by data request or from the published release.

### Web-scraped online prices

The online prices behind Figure 4d come from two retailer websites, `rhtradingpng.com` and `fpr.com.pg`, collected with the scrapers in `4_online_appendix/web_scraping/` (`run_all.py`, `rh_script.py`, `foodpro_script.py`). The scrapers require a manual Cloudflare check mid-run, so they are a one-off collection tool, not an automated pipeline step. The exact price snapshots cannot be re-collected on demand: the live sites change over time and prior pages are not archived here. The dated CSVs the scrapers produced feed `build_online_prices.do`. Those CSVs are not shipped; request them from the authors, or re-run the scrapers to gather a new snapshot.

## Instructions for replicators

1. Obtain the data (see the availability statement) and place the files under `Data/Raw/…` following the folder names in `main.do` Section 1 (`census`, `experts_survey`, `phone_survey`, `store_collection`, `e_store_collection`, `rpi`, `nso`, `sentiment`). The phone survey extract sits in a dated subfolder (`20260429`).
2. Install the software and packages in [Requirements](#requirements).
3. Open `main.do`. Set the top-level directory on the single line marked `CHANGE ONLY THIS ONE LINE`:
   - `main.do`, line 35: `global root "…"`
4. Run `main.do`. It prepares the data and pauses with an on-screen instruction.
5. Open `main.R`. Set the same directory:
   - `main.R`, line 26: `root <- "…"`
   Run `main.R` fully. It writes Figures 1 and 2 and two intermediate datasets.
6. Return to `main.do` and press any key. It runs the analysis and writes all tables and figures to `Outputs/`.

The run order is fixed by the master scripts. Data-prep files are numbered in run order (`01`–`10`). One dependency inside the analysis: `fig4ab_event_study_competition.do` writes `store_competition_groups.dta`, which `fig4c_within_chain.do` reads; `main.do` already runs them in that order.

## List of exhibits

Every table and figure, mapped to its output file, script, and export line, is in [`docs/exhibit_manifest.md`](docs/exhibit_manifest.md). Figure filenames do not always match the exhibit number in the paper (for example Figure 4d exports to the `event_study/` subfolder); the manifest gives the exact mapping.

The code reproduces the tables and figures listed in the manifest. Exhibits not listed there (if any in the manuscript) are not generated by this package; see the "To confirm" note in the manifest.

## Requirements

### Software

- **Stata 17.** User-written packages (installed automatically by `main.do` Section 3 via `ssc install`): `estout`, `gtools`, `winsor2`, `reghdfe`, `ftools`, `regsave`, `mmat2tex`, `boottest`, `distinct`.
- **R** (4.x recommended). Packages (installed automatically by `main.R` if missing): `tidyverse`, `sf`, `ggplot2`, `dplyr`, `readr`, `haven`, `viridis`, `scales`, `RColorBrewer`, `cowplot`, `knitr`, `readxl`, `data.table`, `osmdata`.
- **Python 3** (only to re-run the online-price scrapers, optional): `selenium`, `undetected_chromedriver`, plus the local `utils` helper. The scrapers need a manual Cloudflare step and are not part of the automated run.

### Runtime and storage

Runtime depends on the machine; the phone-survey inline rebuilds and the household-cluster bootstraps (500 replications in `fig5_incidence.do` and `fig6_actual_vs_expert.do`) are the slowest steps. Allow storage for the `Final/` datasets and `Outputs/` beyond the code footprint.

## Code description

```
main.do   Stata master: paths, packages, data prep, pause for R, analysis
main.R    R master: builds Figures 1 and 2, writes intermediates for Stata

1_data_prep/   Builds Final/ datasets from Raw/ (run order 01–10)
2_maps/        R maps (Figures 1 and 2) and store proximity tertiles
3_analysis/    Tables and figures (named by exhibit)
4_online_appendix/  Online-price cleaning, Figure 4d, and the scrapers
5_experts/     Expert prediction survey figures and Table A5
docs/          Data availability statement and exhibit manifest
```

Data-prep files are numbered in run order. Analysis files are named by the exhibit they produce (for example `table2_passthrough.do`, `fig5_incidence.do`, `figA19_event_study_hh.do`), so the manifest maps cleanly to filenames. Each script carries a header block stating its purpose, inputs, outputs, and dependencies.

## Folder structure

The full package (assembled on the author's machine, not shipped here) has this layout. The `root` set in the master scripts points at its top.

```
root/
├── Code/          (this repository)
├── Data/
│   ├── Raw/       (census, experts_survey, phone_survey, store_collection,
│   │               e_store_collection, rpi, nso, sentiment)
│   └── Final/     (built by 1_data_prep and 2_maps)
├── Outputs/
│   ├── Figures/
│   └── Tables/
└── logs/
```

`Data/`, `Outputs/`, and `logs/` are excluded from version control (see `.gitignore`).
