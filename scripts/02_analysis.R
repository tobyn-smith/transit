# 02_analysis.R
# Distance and buffer measurements, plus the exposure index. Reads the processed
# layers, writes the scored terminal table back to data/processed/ for the
# Analysis page to display.

library(sf)
library(dplyr)
library(readr)

proc <- "data/processed"

aoi        <- st_read(file.path(proc, "aoi.gpkg"))
terminals  <- st_read(file.path(proc, "lng_terminals.gpkg"))
boundary   <- st_read(file.path(proc, "ru_maritime_boundary.gpkg"))
chokepoint <- st_read(file.path(proc, "danish_straits.gpkg"))

# ---- Distances --------------------------------------------------------------
terminals <- terminals |>
  mutate(
    dist_boundary_km   = as.numeric(st_distance(geom, st_union(boundary)))   / 1000,
    dist_chokepoint_km = as.numeric(st_distance(geom, st_union(chokepoint))) / 1000
  )

# ---- Buffer: capacity near the boundary -------------------------------------
total_cap <- sum(terminals$capacity, na.rm = TRUE)
share_within <- function(km) {
  near <- terminals |> filter(dist_boundary_km <= km)
  sum(near$capacity, na.rm = TRUE) / total_cap
}
share_50  <- share_within(50)
share_100 <- share_within(100)

# ---- Exposure index ---------------------------------------------------------
# Weights are stated here and in the writeup. Easy to change, nothing hidden.
w_proximity  <- 0.4
w_capacity   <- 0.3
w_chokepoint <- 0.3

norm <- function(x) (max(x, na.rm = TRUE) - x) /
                    (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))

terminals <- terminals |>
  mutate(
    s_proximity  = norm(dist_boundary_km),       # nearer boundary = higher
    s_chokepoint = 1 - norm(dist_chokepoint_km), # nearer chokepoint = higher
    s_capacity   = capacity / max(capacity, na.rm = TRUE),
    exposure     = w_proximity  * s_proximity +
                   w_capacity   * s_capacity +
                   w_chokepoint * s_chokepoint
  ) |>
  arrange(desc(exposure))

st_write(terminals, file.path(proc, "terminals_scored.gpkg"), delete_dsn = TRUE)

terminals |>
  st_drop_geometry() |>
  select(name, country, capacity, dist_boundary_km, dist_chokepoint_km, exposure) |>
  write_csv(file.path(proc, "exposure_ranking.csv"))

message(sprintf("Capacity within 50 km of boundary: %.0f%%", 100 * share_50))
message(sprintf("Capacity within 100 km of boundary: %.0f%%", 100 * share_100))
message("Scored terminals written to data/processed/.")
