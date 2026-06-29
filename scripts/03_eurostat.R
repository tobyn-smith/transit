# 03_eurostat.R
# Pulls natural gas import dependency from Eurostat (indicator nrg_ind_id) and
# writes data/processed/import_dependence.csv. Public data, no key.
# siec = G3000 is natural gas; unit = PC is percent.

library(eurostat)
library(dplyr)
library(readr)

geos <- c("EE", "LV", "LT", "FI", "PL", "DE", "SE", "DK")
names_lookup <- c(EE = "Estonia", LV = "Latvia", LT = "Lithuania", FI = "Finland",
                  PL = "Poland", DE = "Germany", SE = "Sweden", DK = "Denmark")

dep <- get_eurostat("nrg_ind_id",
                    filters = list(siec = "G3000", unit = "PC", geo = geos))

# keep the most recent year available for each country
# (recent eurostat versions name the time column TIME_PERIOD)
latest <- dep |>
  filter(!is.na(values)) |>
  group_by(geo) |>
  slice_max(TIME_PERIOD, n = 1) |>
  ungroup() |>
  transmute(
    country = names_lookup[as.character(geo)],
    iso_a2  = as.character(geo),
    gas_import_dependency_pct = round(values, 1)
  )

write_csv(latest, "data/processed/import_dependence.csv")
message("Wrote data/processed/import_dependence.csv from Eurostat nrg_ind_id.")
