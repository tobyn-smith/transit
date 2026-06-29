# 00_download.R
# Pulls public source data into data/raw/. Run this locally, not in CI.
# A couple of sources need a manual download because they require accepting
# terms first — those are marked MANUAL below.

library(sf)
library(rnaturalearth)
library(eurostat)

dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)

# ---- Natural Earth: countries, coastline, ports -----------------------------
# Public domain, pulled directly through the package.
countries <- ne_countries(scale = "medium", returnclass = "sf")
st_write(countries, "data/raw/ne_countries.gpkg", delete_dsn = TRUE)

ports <- ne_download(scale = "medium", type = "ports",
                     category = "cultural", returnclass = "sf")
st_write(ports, "data/raw/ne_ports.gpkg", delete_dsn = TRUE)

# ---- Eurostat: energy import dependency -------------------------------------
# Public API, no key. Indicator code may need checking against the current
# Eurostat catalogue before first run.
dependency <- get_eurostat("nrg_ind_id", time_format = "num")
write.csv(dependency, "data/raw/eurostat_import_dependency.csv", row.names = FALSE)

# ---- Marine Regions: EEZ / maritime boundaries ------------------------------
# MANUAL (or via mregions2). Download the World EEZ boundaries layer from
# https://www.marineregions.org/downloads.php and save to:
#   data/raw/eez_boundaries.gpkg
# Cite the version DOI listed on the download page.

# ---- Global Energy Monitor: LNG terminals -----------------------------------
# MANUAL. GEM requires accepting terms before download. Get the Global LNG
# Terminal tracker from https://globalenergymonitor.org/ and save the
# spreadsheet to:
#   data/raw/gem_lng_terminals.xlsx
# Keep terminal name, country, latitude, longitude, capacity, status.

# ---- EMODnet Human Activities: pipelines, cables, ports ---------------------
# MANUAL (or via WFS). Download the relevant layers for the Baltic from
# https://emodnet.ec.europa.eu/en/human-activities and save to data/raw/.
# Use OpenStreetMap via osmdata only as a fallback for layers EMODnet misses.

message("Done. Manual sources (Marine Regions, GEM, EMODnet) must be placed in data/raw/ by hand.")
