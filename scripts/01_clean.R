# 01_clean.R
# Turns raw downloads into analysis-ready layers in data/processed/.
# Everything is reprojected to ETRS89 / LAEA Europe (EPSG:3035) and clipped to
# the Baltic area of interest. Only these small derived layers are committed.

library(sf)
library(dplyr)
library(readr)
library(readxl)
library(janitor)
library(stringr)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)

laea <- 3035

# ---- Area of interest -------------------------------------------------------
# Bounding box around the Baltic, in WGS84, then projected. Adjust as needed.
baltic_bbox <- st_as_sfc(st_bbox(
  c(xmin = 9, ymin = 53, xmax = 30, ymax = 66), crs = 4326
))
aoi <- st_transform(baltic_bbox, laea) |> st_sf(geometry = _)
st_write(aoi, "data/processed/aoi.gpkg", delete_dsn = TRUE)

# ---- LNG terminals ----------------------------------------------------------
terminals <- read_excel("data/raw/gem_lng_terminals.xlsx") |>
  clean_names() |>
  filter(!is.na(latitude), !is.na(longitude)) |>
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326) |>
  st_transform(laea) |>
  st_filter(aoi) |>
  transmute(
    name     = name,
    country  = country,
    capacity = as.numeric(capacity),
    status   = status
  )
st_write(terminals, "data/processed/lng_terminals.gpkg", delete_dsn = TRUE)

# ---- Russian / Kaliningrad maritime boundary --------------------------------
eez <- st_read("data/raw/eez_boundaries.gpkg") |>
  st_transform(laea)

ru_boundary <- eez |>
  filter(str_detect(tolower(sovereign1), "russia")) |>
  st_filter(aoi)
st_write(ru_boundary, "data/processed/ru_maritime_boundary.gpkg", delete_dsn = TRUE)

# ---- Danish Straits chokepoint ----------------------------------------------
# Defined here as a small polygon over the straits the traffic passes through.
# Hand-drawn gate; refine coordinates against a chart if needed.
straits <- st_as_sfc(st_bbox(
  c(xmin = 10.5, ymin = 55.0, xmax = 13.0, ymax = 56.2), crs = 4326
))
chokepoint <- st_transform(straits, laea) |> st_sf(geometry = _)
st_write(chokepoint, "data/processed/danish_straits.gpkg", delete_dsn = TRUE)

# ---- Dependence layer -------------------------------------------------------
countries <- st_read("data/raw/ne_countries.gpkg") |>
  st_transform(laea) |>
  clean_names()

dependency <- read_csv("data/raw/eurostat_import_dependency.csv") |>
  clean_names()
# TODO: filter dependency to the most recent year and the gas/total indicator,
# then join to `countries` on ISO code before writing.

# dependence <- countries |> left_join(dependency, by = c("iso_a2" = "geo"))
# st_write(dependence, "data/processed/dependence.gpkg", delete_dsn = TRUE)

message("Processed layers written to data/processed/.")
