# 02_analysis.R
# Distances, buffer share, and the exposure index. Mirrors the computation on the
# Analysis page and writes a scored ranking to data/processed/. Run 01_clean.R
# first, or just read the committed CSV directly as the page does.

library(sf)
library(dplyr)
library(readr)
library(rnaturalearth)

laea <- 3035

world      <- ne_countries(scale = "medium", returnclass = "sf")
russia     <- world |> filter(admin == "Russia") |> st_transform(laea) |> st_make_valid()
chokepoint <- st_as_sfc(st_bbox(c(xmin = 10.5, ymin = 55.0, xmax = 13.0, ymax = 56.2),
                                crs = 4326)) |> st_transform(laea)

terminals <- read_csv("data/processed/lng_terminals.csv", show_col_types = FALSE) |>
  st_as_sf(coords = c("lon", "lat"), crs = 4326) |>
  st_transform(laea) |>
  mutate(
    dist_russia_km     = as.numeric(st_distance(geometry, st_union(russia)))     / 1000,
    dist_chokepoint_km = as.numeric(st_distance(geometry, st_union(chokepoint))) / 1000
  )

# Capacity share within distance bands of Russian territory
total_cap <- sum(terminals$capacity_bcm, na.rm = TRUE)
share_within <- function(km) {
  near <- terminals |> filter(dist_russia_km <= km)
  sum(near$capacity_bcm, na.rm = TRUE) / total_cap
}

# exposure index: weights and 0-1 scaling
w_proximity  <- 0.4   # closer to Russia, higher
w_capacity   <- 0.3   # larger capacity, higher
w_chokepoint <- 0.3   # longer voyage past the straits, higher
norm <- function(x) (max(x, na.rm = TRUE) - x) /
                    (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))

terminals <- terminals |>
  mutate(
    s_proximity  = norm(dist_russia_km),             # closer = higher
    s_chokepoint = 1 - norm(dist_chokepoint_km),     # longer Baltic transit = higher
    s_capacity   = capacity_bcm / max(capacity_bcm, na.rm = TRUE),
    exposure     = w_proximity * s_proximity +
                   w_capacity  * s_capacity +
                   w_chokepoint * s_chokepoint
  ) |>
  arrange(desc(exposure))

st_write(terminals, "data/processed/terminals_scored.gpkg", delete_dsn = TRUE, quiet = TRUE)
terminals |>
  st_drop_geometry() |>
  select(name, country, status, capacity_bcm, dist_russia_km, dist_chokepoint_km, exposure) |>
  write_csv("data/processed/exposure_ranking.csv")

message(sprintf("Capacity within 150 km of Russian territory: %.0f%%", 100 * share_within(150)))
message(sprintf("Capacity within 200 km of Russian territory: %.0f%%", 100 * share_within(200)))
message("Scored terminals written to data/processed/.")
