# Data availability statement

Summary classification: some data cannot be made publicly available.

Most inputs are restricted (household microdata, central bank data requests, own field collection). None of the raw or intermediate datasets are shipped in this code repository. The repository contains code and documentation only. This statement lists every source, its access route, and whether it can be shared.

Fields marked `[confirm]` need the author to fill the exact URL, catalog name, or access year before submission to a data editor.

## Sources

| # | Dataset | Files (as referenced in code) | Source | Class | In repo | Access route |
|---|---------|-------------------------------|--------|-------|---------|--------------|
| 1 | Phone survey (PNG HFPS, food module) | `PNG_HFPS_Household_weighted_wFood.dta` (subfolder `20260429`) | World Bank High-Frequency Phone Survey, Papua New Guinea | Restricted (household microdata) | No | Request through the World Bank survey team / Microdata Library. `[confirm catalog ID and access year]` |
| 2 | Expert prediction survey | `experts_survey.csv` | Own collection (Qualtrics) | Restricted (respondent-level) | No | Available from the authors on request; can be shared de-identified. `[confirm terms]` |
| 3 | 2011 census population by district | `png_admpop_adm2_2011_v2.csv` | PNG National Statistical Office (2011 census) | Public (aggregate) `[confirm]` | No | `[confirm public URL]` |
| 4 | Store price collection (Port Moresby) | `POM PRICE COLLECTION.xlsx` | Own field collection | Own collection | No | Available from the authors on request. |
| 5 | Online store prices | scraped CSVs under `foodpro/` and `rh/` | Own collection via web scraping (see `4_online_appendix/web_scraping/`) | Own collection | No | Reproduce with the scrapers (manual step, see note below) or request from the authors. |
| 6 | Retail Price Index (RPI) | `World_Bank__RPI_Data_Request.xlsx` | Bank of Papua New Guinea (data request) | Restricted | No | Data request to the Bank of PNG. `[confirm terms]` |
| 7 | NSO administrative prices and CPI | `Comparision_Group.xlsx`, `GST exempt goods WB tracking - Edited.xlsx`, `Table_13_December_Qtr_2025.xlsx` | PNG National Statistical Office | Restricted / official `[confirm: Table 13 CPI may be a published release]` | No | `[confirm access route; provide public URL for Table 13 if published]` |
| 8 | Business Sentiment Survey (competition, pass-through) | `Copy_of_Wholesale_retail_competition.xlsx`, `World_Bank_request.xlsx` | Bank of Papua New Guinea Business Sentiment Survey | Restricted | No | Data request to the Bank of PNG. `[confirm terms]` |

## Web-scraped online prices

The scrapers in `4_online_appendix/web_scraping/` (`run_all.py`, `rh_script.py`, `foodpro_script.py`) collect prices from `rhtradingpng.com` and `fpr.com.pg`. They require a manual Cloudflare check during the run, so they are a one-off collection tool, not an automated pipeline step. Collected prices are dated CSVs used as input to `build_online_prices.do`.

## Restrictions on access, publication, retention

`[confirm]` Record here any restriction from each data provider's terms of use (redistribution limits, retention periods, embargo dates). At minimum: household microdata (source 1) and central bank data (sources 6, 8) are not redistributable; only derived, non-identifying results appear in the paper.

## Statement about rights

- [ ] The authors have legitimate access to and permission to use all data used in the manuscript.
- [ ] The authors have documented permission to redistribute any data included in this package. (No raw data is included; this box concerns derived files only, if any are later added.)

Confirm both boxes before submission.
