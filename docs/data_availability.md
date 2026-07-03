# Data availability statement

Summary classification: some data cannot be made publicly available.

Most inputs are restricted (household microdata, central bank data requests, own field collection). None of the raw or intermediate datasets are shipped in this code repository, which contains code and documentation only. This statement lists every source, its origin, its access route, and whether it can be shared.

## Sources

| # | Dataset | Files (as referenced in code) | Origin | Class | In repo | Access route |
|---|---------|-------------------------------|--------|-------|---------|--------------|
| 1 | Phone survey (PNG HFPS, food module) | `PNG_HFPS_Household_weighted_wFood.dta` (subfolder `20260429`) | World Bank High-Frequency Phone Survey, Papua New Guinea | Restricted (household microdata) | No | Request through the World Bank survey team and Microdata Library. Not redistributable. |
| 2 | Expert prediction survey | `experts_survey.csv` | Own collection (Qualtrics) | Restricted (respondent-level) | No | Available from the authors on request; shared de-identified. |
| 3 | 2011 census population by district | `png_admpop_adm2_2011_v2.csv` | PNG National Statistical Office (2011 census), distributed through HDX | Public (aggregate) | No | https://data.humdata.org/dataset/cod-ps-png |
| 4 | Store price collection (Port Moresby) | `POM PRICE COLLECTION.xlsx` | Own field collection | Own collection | No | Available from the authors on request. |
| 5 | Online store prices | scraped CSVs under `foodpro/` and `rh/` | Own collection via web scraping of `rhtradingpng.com` and `fpr.com.pg` (see `4_online_appendix/web_scraping/`) | Own collection | No | Re-run the scrapers (manual step, see note below) or request from the authors. |
| 6 | Retail Price Index (RPI) | `World_Bank__RPI_Data_Request.xlsx` | Bank of Papua New Guinea (data request) | Restricted | No | Data request to the Bank of PNG. Not redistributable. |
| 7 | NSO administrative prices and CPI | `Comparision_Group.xlsx`, `GST exempt goods WB tracking - Edited.xlsx`, `Table_13_December_Qtr_2025.xlsx` | PNG National Statistical Office | Restricted and official (Table 13 is the December 2025 quarterly CPI release) | No | Data request to the NSO, or the published quarterly CPI release for Table 13. |
| 8 | Business Sentiment Survey (competition, pass-through) | `Copy_of_Wholesale_retail_competition.xlsx`, `World_Bank_request.xlsx` | Bank of Papua New Guinea Business Sentiment Survey | Restricted | No | Data request to the Bank of PNG. Not redistributable. |

## Web-scraped online prices

The scrapers in `4_online_appendix/web_scraping/` (`run_all.py`, `rh_script.py`, `foodpro_script.py`) collect prices from `rhtradingpng.com` and `fpr.com.pg`. They require a manual Cloudflare check during the run, so they are a one-off collection tool, not an automated pipeline step. The exact price snapshots cannot be re-collected on demand: the live sites change over time and prior pages are not archived here. Collected prices are dated CSVs used as input to `build_online_prices.do`.

## Restrictions on access, publication, retention

Household microdata (source 1) and central bank data (sources 6, 8) are not redistributable. Only derived, non-identifying results appear in the paper. Data provider terms of use govern redistribution limits, retention periods, and any embargo dates for each restricted source.

## Statement about rights

The authors have legitimate access to and permission to use all data used in the manuscript. No raw data is included in this package; the manuscript reports only derived, non-identifying results.
