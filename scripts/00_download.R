# 00_download.R
# The current build does not require any manual downloads. Country geometry
# comes from the rnaturalearth package, and the terminal and dependence tables
# are committed under data/processed/. This script documents how to replace the
# curated tables with primary sources to extend the project later.

# ---- Country geometry (already used directly in the analysis) ---------------
# install.packages("rnaturalearth")
# rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")

# ---- LNG terminals: reconcile against Global Energy Monitor -----------------
# Replace data/processed/lng_terminals.csv with figures checked against the GEM
# Global LNG Terminal tracker (free download after accepting terms):
#   https://globalenergymonitor.org/
# Keep the same columns: name, country, iso_a2, lon, lat, capacity_bcm, status, type

# ---- Dependence: replace placeholders with Eurostat actuals -----------------
# install.packages("eurostat")
# dep <- eurostat::get_eurostat("nrg_ind_id", time_format = "num")
# Filter to the gas import-dependency indicator and most recent year, then write
# data/processed/import_dependence.csv with columns: country, iso_a2, gas_import_dependency_pct

# ---- Pipelines / cables (future line features) ------------------------------
# EMODnet Human Activities (public downloads):
#   https://emodnet.ec.europa.eu/en/human-activities
# OpenStreetMap via osmdata as a fallback for missing layers.

message("No download needed for the current build. See comments for hardening steps.")
