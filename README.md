# Baltic Energy Transit Risk

A spatial analysis of how the Baltic Sea region's energy import infrastructure —
LNG terminals, ports, and undersea pipelines — is exposed to geopolitical
disruption after the 2022 break with Russian pipeline gas.

## Research question

After 2022, Baltic energy imports shifted onto a small set of coastal LNG
terminals and ports. How spatially concentrated is that infrastructure, and how
exposed is it — measured by capacity, by proximity to the Russian and
Kaliningrad maritime boundary, and by dependence on the single Danish Straits
chokepoint?

The question has three measurable parts: concentration, proximity, and
chokepoint dependence. The analysis stays close to those three.

## Data

All public, no API keys, no paywalled sources. See `01-data.qmd` for the full
list and citations.

| Layer | Source |
|---|---|
| Coastlines, countries, ports | Natural Earth |
| Admin boundaries | Eurostat NUTS / GADM |
| Maritime boundaries, EEZ | Marine Regions (Flanders Marine Institute) |
| LNG terminals + capacity | Global Energy Monitor |
| Pipelines, cables, ports | EMODnet Human Activities (OSM as fallback) |
| National import dependence | Eurostat |

Raw downloads are not committed to the repo. Run `scripts/00_download.R` to
fetch them, or follow the manual-download notes in that script for the few
sources that require accepting terms.

## How to run

```r
# from the project root, with renv restored
source("scripts/00_download.R")   # pulls public data into data/raw/
source("scripts/01_clean.R")      # tidies + reprojects -> data/processed/
source("scripts/02_analysis.R")   # distances, buffers, exposure index
```

Then render the site:

```bash
quarto render
```

The rendered site lands in `docs/`.

## Reproducibility

Package versions are pinned with `renv`. On a fresh clone:

```r
install.packages("renv")
renv::restore()
```

CI only renders the site — it does not download data. The small processed layers
in `data/processed/` are committed so the site rebuilds without network access.

## Method, in short

1. Define the area of interest (Baltic Sea + bordering EEZs), all work in
   ETRS89 / LAEA Europe (EPSG:3035) so distances are in metres.
2. Assemble infrastructure points and lines with capacity attributes.
3. Build the risk geometries: the Russian/Kaliningrad maritime boundary and the
   Danish Straits chokepoint.
4. Measure exposure — distance to boundary, distance to chokepoint, buffer
   analysis on capacity.
5. Join national import-dependence figures for the dependence layer.
6. Combine three normalized components into a transparent exposure index with
   weights stated in the writeup.

## Limitations

The exposure index uses proxy measures and a single-snapshot view. It captures
geographic exposure, not intent or probability. The limitations section in
`index.qmd` is the honest version of what the numbers do and don't mean.

## Project status

The repo and the Quarto site build and deploy, but the analysis is not populated
yet. A couple of things to know:

- The site currently renders as text only. The analysis code chunks are set to
  `eval: false` and there is no data committed yet, so the page is publishable
  while empty. Once you run the R scripts locally, commit the processed layers
  (`data/processed/*.gpkg`) and a `renv.lock`, then flip the chunks to
  `eval: true`, the maps and tables appear on the next push.
- The CI log shows one warning about GitHub deprecating Node 20 actions. It is
  harmless — the actions run on Node 24 automatically. No action needed.

## License

Code: MIT. Data: see each source's own terms, listed in `01-data.qmd`.
