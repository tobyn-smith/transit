# 03_eurostat.R
# Pulls two Eurostat series for the study year and writes them to data/processed/:
#   import_dependence.csv  gas import dependency   (nrg_ind_id, unit PC)
#   gas_demand.csv         inland gas consumption  (nrg_cb_gas, unit MIO_M3)
# Public data, no key. siec = G3000 is natural gas.
#
# The analysis is a snapshot of one year, so the year is pinned here rather than
# always taking the latest. To move the whole study to a newer year, change
# study_year and update the year labels on the pages to match. The scheduled
# refresh job then only picks up revisions to that year, not a change of year.

library(eurostat)
library(dplyr)
library(readr)

study_year <- 2023
geos <- c("EE", "LV", "LT", "FI", "PL", "DE", "SE", "DK")
names_lookup <- c(EE = "Estonia", LV = "Latvia", LT = "Lithuania", FI = "Finland",
                  PL = "Poland", DE = "Germany", SE = "Sweden", DK = "Denmark")

dep <- get_eurostat("nrg_ind_id",
                    filters = list(siec = "G3000", unit = "PC", geo = geos))

# the time column is TIME_PERIOD in recent eurostat versions and time in older ones
time_col <- intersect(c("TIME_PERIOD", "time"), names(dep))[1]
year_num <- suppressWarnings(as.integer(substr(as.character(dep[[time_col]]), 1, 4)))

out <- dep |>
  mutate(.year = year_num) |>
  filter(!is.na(values), .year == study_year) |>
  transmute(
    country = names_lookup[as.character(geo)],
    iso_a2  = as.character(geo),
    gas_import_dependency_pct = round(values, 1)
  ) |>
  arrange(iso_a2)

write_csv(out, "data/processed/import_dependence.csv")
message(sprintf("Wrote data/processed/import_dependence.csv (Eurostat nrg_ind_id, %d).",
                study_year))

# inland gas consumption, converted from million cubic metres to bcm
dem <- get_eurostat("nrg_cb_gas",
                    filters = list(nrg_bal = "IC_OBS", siec = "G3000",
                                   unit = "MIO_M3", geo = geos))

dem_time <- intersect(c("TIME_PERIOD", "time"), names(dem))[1]
dem_year <- suppressWarnings(as.integer(substr(as.character(dem[[dem_time]]), 1, 4)))

demand <- dem |>
  mutate(.year = dem_year) |>
  filter(!is.na(values), .year == study_year) |>
  transmute(
    country = names_lookup[as.character(geo)],
    iso_a2  = as.character(geo),
    gas_demand_bcm = round(values / 1000, 1)
  ) |>
  arrange(iso_a2)

write_csv(demand, "data/processed/gas_demand.csv")
message(sprintf("Wrote data/processed/gas_demand.csv (Eurostat nrg_cb_gas, %d).",
                study_year))
