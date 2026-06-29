# 01_clean.R
# Builds the analysis-ready spatial layers in data/processed/ from the committed
# tables plus Natural Earth geometry. Everything is projected to ETRS89 / LAEA
# Europe (EPSG:3035). The Analysis page recomputes these inline, so running this
# is optional. It exists for an offline pipeline and for inspecting the layers.

library(sf)
library(dplyr)
library(readr)
library(rnaturalearth)

laea <- 3035
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)

world <- ne_countries(scale = "medium", returnclass = "sf")

# Area of interest
aoi <- st_as_sfc(st_bbox(c(xmin = 9, ymin = 53, xmax = 30, ymax = 66),
                         crs = 4326)) |>
  st_transform(laea) |>
  st_sf(geometry = _)
st_write(aoi, "data/processed/aoi.gpkg", delete_dsn = TRUE, quiet = TRUE)

# Russian territory (mainland + Kaliningrad), the proximity reference
russia <- world |>
  filter(admin == "Russia") |>
  st_transform(laea) |>
  st_make_valid()
st_write(russia["admin"], "data/processed/russia.gpkg", delete_dsn = TRUE, quiet = TRUE)

# Danish Straits chokepoint gate
chokepoint <- st_as_sfc(st_bbox(c(xmin = 10.5, ymin = 55.0, xmax = 13.0, ymax = 56.2),
                                crs = 4326)) |>
  st_transform(laea) |>
  st_sf(geometry = _)
st_write(chokepoint, "data/processed/danish_straits.gpkg", delete_dsn = TRUE, quiet = TRUE)

# Terminals as points
terminals <- read_csv("data/processed/lng_terminals.csv", show_col_types = FALSE) |>
  st_as_sf(coords = c("lon", "lat"), crs = 4326) |>
  st_transform(laea)
st_write(terminals, "data/processed/lng_terminals.gpkg", delete_dsn = TRUE, quiet = TRUE)

message("Processed layers written to data/processed/.")
