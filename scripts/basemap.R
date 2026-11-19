# Muted basemap for the leaflet maps, drawn from Natural Earth so the maps
# do not depend on a tile service. Colours match the Grid Resilience map:
# cream land, pale slate sea (set in the page CSS), soft beige borders.
suppressPackageStartupMessages({
  library(sf)
  library(rnaturalearth)
  library(leaflet)
})

baltic_land <- local({
  s2_was <- sf_use_s2()
  sf_use_s2(FALSE)
  w <- ne_countries(scale = "medium", returnclass = "sf")
  w <- st_make_valid(w[, c("admin", "geometry")])
  out <- suppressWarnings(suppressMessages(
    st_crop(w, xmin = -4, xmax = 44, ymin = 47, ymax = 72)))
  sf_use_s2(s2_was)
  out[!st_is_empty(out), ]
})

add_basemap <- function(map) {
  addPolygons(map, data = baltic_land,
              fillColor = "#ECE6D9", fillOpacity = 1,
              color = "#CFC5B2", weight = 0.7, opacity = 1,
              options = pathOptions(interactive = FALSE))
}

map_ink  <- "#1E2833"
map_mark <- "#d7301f"
