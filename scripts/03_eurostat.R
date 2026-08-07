# 03_eurostat.R
# Pulls natural gas import dependency from Eurostat (indicator nrg_ind_id) for the
# study year and writes data/processed/import_dependence.csv. Public data, no key.
# siec = G3000 is natural gas; unit = PC is percent.
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
