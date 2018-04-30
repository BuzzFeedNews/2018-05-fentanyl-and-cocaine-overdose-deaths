# Analysis of U.S. Fentanyl and Cocaine Deaths

This repository contains analytic code, findings, and charts supporting the BuzzFeed News article, ["The Opioid Crisis Is Turning Into A Cocaine Crisis. Here’s How It Happened,"](http://www.buzzfeed.com/scottpham/cocaine-fentanyl-opioid-overdoses) published May 1, 2018. Please read that article, which contains important context and details, before proceeding.

Specifically, this repository processes and analyzes the CDC's drug overdose death data by year, race, geography, and specific drug combinations. 

## About the data

The analyses in this repository use "Multiple Cause of Death" data from the CDC's Wonder Database, which collects mortality data by time, geography, race, and cause of death using death certificates. 

CDC Wonder statistics can be queried by "underlying cause-of-death" (specified with one UCD-ICD-10 code) and "multiple cause of death" (specified by zero or more MCD-ICD-10 codes). In order to query deaths that are indeed caused by drugs (called by epidemiologists "drug poisoning deaths") it is necessary to query a range of UCD codes and MCD codes at the same time. We used a selection of codes [established](https://www.cdc.gov/nchs/nvss/vsrr/drug-overdose-data.htm) by the National Center for Health Statistics.

*UCD codes:*

- X40-44 (unintentional)
- X60-64 (suicide)
- X85 (homicide)
- Y10-14 (undetermined)

*MCD codes:*

- T40.1 (Heroin)
- T40.2 (Semi-synthetic opioids like Oxycontin)
- T40.4 (Synthetic opioids like Fentanyl)
- T40.5 (Cocaine)
- T40.4 (Other synthetic narcotics)

The CDC [defines](https://www.cdc.gov/nchs/data/databriefs/db273.pdf) overdose or “drug poisoning” deaths as: "deaths resulting from unintentional or intentional overdose of a drug, being given the wrong drug, taking a drug in error, or taking a drug inadvertently." More information can be found in the discussion of data sources [here](https://ndews.umd.edu/sites/ndews.umd.edu/files/new-york-city-scs-drug-use-patterns-and-trends-2017-final.pdf).

All queries used in this analysis applied all of the above UCD codes and one or more of the above MCD codes.


### "Suppressed" / "Unreliable" data

For sub-national data, the CDC does not report any raw counts below 10 (which in the data are replaced with the word "Suppressed"), or *rates* based on death counts below 20. [Per the CDC](https://wonder.cdc.gov/wonder/help/cmf.html):

> Death rates based on counts less than twenty (death count <=20) are flagged as "Unreliable". A death rate based on fewer than 20 deaths has a relative standard error (RSE(R))of 23 percent or more. A RES(R ) of 23 percent is considered statistically unreliable.


### State reporting quality

The quality of data reported by medical examiners varies by state. The CDC has noted that some states have a tendency to report drug poisoning deaths without listing a specific drug. Because of this, researchers have identified states with [high-quality reporting](https://www.cdc.gov/mmwr/volumes/67/wr/mm6712a1.htm). The analyses below incorporate this research to identify states that don't meet that threshold.


## Data files

The `data` directory contains three subdirectories:  `mcd`, `vssr`, and `geo`.

### `mcd`

This subdirectory contains files downloaded directly from the CDC Wonder database described above. All are tab-delimited text files.

- `national/cocaine_10_16_national.txt`: Drug poisoning deaths involving __cocaine__, by year, 2010-2016.

- `national/cocaine_fentanyl_10_16_national.txt`: Drug poisoning deaths involving __cocaine and synthetic opioids (fentanyl)__, by year, 2010-2016.

- `national/cocaine_monthly_10_16_national.txt`: Drug poisoning deaths involving __cocaine__, by month and year, 2010-2016. 

- `national/fentanyl_monthly_10_16_national.txt`: Drug poisoning deaths involving __fentanyl__, by month and year, 2010-2016. 

- `national/heroin_monthly_10_16_national.txt`: Drug poisoning deaths involving __heroin__, by month and year, 2010-2016.

- `national/rxopioids_monthly_10_16_national.txt`: Drug poisoning deaths involving __prescription opioids__, by month and year, 2010-2016. 

- `state/cocaine_15_16_by_state.txt`: Drug poisoning deaths involving __cocaine__, by __state__ and year, for 2015 and 2016. Contains 95% confidence intervals for significance testing.

- `state/cocaine_fentanyl_15_16_by_state.txt`: Drug poisoning deaths involving __cocaine and synthetic opioids (fentanyl)__, by __state__ and year, for 2015 and 2016. Contains 95% confidence intervals for significance testing.

- `allDrugs_15_16_by_race_and_ethnicity.txt`: Drug poisoning deaths involving __cocaine and synthetic opioids (fentanyl)__, by __race and Hispanic ethnicity__ and year, for 2015 and 2016. Contains 95% confidence intervals for significance testing.

- `race/cocaine_fentanyl_15_16_by_ethnicity.txt`: Drug poisoning deaths involving __cocaine and synthetic opioids (fentanyl)__, by __Hispanic ethnicity__ and year, for 2015 and 2016. Contains 95% confidence intervals for significance testing.

- `race/allDrugs_15_16_by_race_and_ethnicity.txt`: Drug poisoning deaths involving __any drug__, by __race and Hispanic ethnicity__ and year, for 2015 and 2016. Contains 95% confidence intervals for significance testing.

- `race/cocaine_fentanyl_15_16_by_ethnicity.txt`: Drug poisoning deaths involving __any drug__, by __Hispanic ethnicity__ and year, for 2015 and 2016. Contains 95% confidence intervals for significance testing.


### `vssr`

Contains provisional overdose death counts from the CDC's [Vital Statistics Rapid Release](https://www.cdc.gov/nchs/nvss/vsrr/drug-overdose-data.htm).

- `VSRR_Provisional_Drug_Overdose_Death_Counts.csv`: The default download from the Vital Statistics Rapid Release. Contains 12-month rolling provisional death counts by state, year, month, and type of drug. 


### `geo`

The `geo` subdirectory contains state and county shapefiles for building the maps.

- `states.json`: A GeoJSON file of US national and state boundaries adapted from Mike Bostock's [U.S. Atlas TopoJSON](https://github.com/topojson/us-atlas). This file is particularly suitable for creating state choropleths because it combines a standard US-Albers projection of the US with two more projections for Alaska and Hawaii scaled and translated to be closer to the US mainland and more visible to the viewer. Bostock supplies the files as TopoJSON but these were then converted to GeoJSON via [Mapshaper](http://mapshaper.org/) so as to be compatible with the GeoPandas library.

- `states_fips.csv`: A simple file containing US state names, abbreviations, and FIPS codes from the US Census.


## Analysis

The analyses were conducted in [Jupyter notebooks](http://jupyter.org/), using the Python programming language. The notebooks are in the `notebooks/` directory and are numbered in their intended order of execution, beginning with `00-prepare-states-shapefile`. You can automate this process by running `make reproduce` from the root of this repo.

- `00-prepare-state-shapefile.ipynb`: Reads `data/geo/states/json` and prepares the file for rendering with the [GeoPandas](http://geopandas.org/) library. Outputs a shapefile to `output/states/`.

- `01-reshape-and-test-data.ipynb`: Reads the raw CDC Wonder data and prepares those files for analysis. Removes cruft, standardizes the row and column format, adds z-tests to test for significance between 2015 and 2016 rates, and adds the CDC's list of states with high quality reporting of drug overdose deaths. Outputs `output/rates-by-race.csv` and `output/rates-by-states.csv`.

- `02-map-and-analyze-states.ipynb`: Analyzes the state-level data, and uses it to create a series of maps.

- `03-chart-and-analyze-race.ipynb`: Analyzes the race-level data, and uses it to create a series of charts.

- `04-make-2010-2016-cocaine-fentanyl-chart.ipynb`: Reads data from `data/mcd/od_coc_fen_10_16.txt` to produce a table and chart of national overdoses due to cocaine and synthetic opioids by year. 

- `05-make-vssr-chart.ipynb`: Reads from the spreadsheets in `data/mcd/national/` and `data/vssr/` to produce a time-series chart showing up-to-date national figures for overdoses due to opioids, heroin, cocaine and prescription opioid overdoses. Because the CDC Wonder database contains data only up to 2016, the 2017 numbers are based on provisional figures provided by the [Vital Statistics Rapid Release](https://www.cdc.gov/nchs/nvss/vsrr/drug-overdose-data.htm).


## Output Files

The following files are generated by the notebooks above, and saved to the `outputs/` directory:

- `rates-by-state.csv`: The main dataset used in this analysis. A CSV combining state-level CDC Wonder for cocaine overdose deaths and cocaine/fentanyl deaths. Contains additional columns indicating whether the CDC suppressed low-count figures, whether the year-over-year rate is statistically significant, and whether the state meets the CDC's standards for quality reporting.

- `rates-by-race.csv`: A CSV combining the race-level CDC Wonder data used in these analyses. Contains data for all drug overdose deaths, as well as cocaine/fentanyl combinations. Contains additional columns indicating whether the CDC suppressed low-count figures, and whether the year-over-year rate is statistically significant.

- `states/`: A folder containing a generated shapefile of US states. 


## Questions / Feedback

Contact Scott Pham at [scott.pham@buzzfeed.com](mailto:scott.pham@buzzfeed.com).

Looking for more from BuzzFeed News? [Click here for a list of our open-sourced projects, data, and code.](https://github.com/BuzzFeedNews/everything)
