<h1 align="center">Baltic Energy Transit Risk</h1>

<p align="center">
  <em>Mapping how exposed the Baltic region's energy import infrastructure became after 2022</em>
</p>

<p align="center">
  <a href="https://tobyn-smith.github.io/transit/"><strong>Read the site</strong></a> ·
  <a href="https://tobyn-smith.github.io/transit/slides.html">Slides</a> ·
  <a href="https://tobyn-smith.github.io/transit/02-analysis.html">Analysis</a> ·
  <a href="https://tobyn-smith.github.io/transit/01-data.html">Data</a>
</p>

<p align="center">
  <a href="https://github.com/tobyn-smith/transit/actions/workflows/publish.yml">
    <img src="https://github.com/tobyn-smith/transit/actions/workflows/publish.yml/badge.svg" alt="Build status"></a>
  <img src="https://img.shields.io/badge/R-spatial%20(sf)-1b4f72" alt="Built with R and sf">
  <img src="https://img.shields.io/badge/site-Quarto-12263f" alt="Built with Quarto">
  <img src="https://img.shields.io/badge/data-public%20only-8f1d17" alt="Public data only">
  <img src="https://img.shields.io/badge/licence-MIT-5a6675" alt="MIT licence">
</p>

<p align="center">
  <img src="https://tobyn-smith.github.io/transit/02-analysis_files/figure-html/map-concentration-1.png"
       alt="Map of Baltic LNG import terminals sized by capacity and coloured by exposure" width="620">
</p>

---

## The question

Before 2022 most of the Baltic region's gas arrived by pipeline from Russia. After
the invasion of Ukraine and the sabotage of the Nord Stream pipelines, that supply
stopped: Russian pipeline gas into the eight littoral states collapsed from roughly
70 bcm in 2021 to almost nothing by 2023. What replaced a continental pipeline
network is, in practice, six coastal terminals.

The problem is not the size of that gap, which lower demand and pipeline gas from
the west have largely closed. It is that what remains is concentrated, sits nearest
Russian territory precisely where it is smallest, and is one asset deep in every
country that holds it.

> How concentrated is that infrastructure, and how exposed is it, measured by
> capacity, by distance to Russian territory, and by reliance on passage through
> the Danish Straits?

## What it finds

| | |
|:--|:--|
| **Partly filled** | The terminals hold about 23 bcm of operating capacity, roughly a third of what stopped arriving. The rest closed through lower demand and pipeline gas from the west. |
| **Lopsided** | Świnoujście and Mukran hold about three fifths of operating capacity; the northeast leans on one or two terminals each. |
| **Small and close** | The terminals nearest Russian territory are the smallest ones. The two largest sit farthest away. |
| **One way in** | Every cargo passes the Danish Straits. The Kiel Canal is far too small for LNG carriers. |
| **Deliberate overbuild** | Finland and Lithuania hold capacity worth several times their own demand. They built a regional buffer. |
| **One deep** | Remove each country's largest terminal and the cover vanishes: Finland drops to a fifth of demand, Lithuania, Poland and Germany to nothing. |

## What is on the site

- **Overview** &mdash; the question, findings in plain language, what follows for policy, and limitations.
- **Data** &mdash; every source, with the tables sortable, searchable and downloadable.
- **Analysis** &mdash; six maps and charts, a ranked exposure table, and sliders that recompute the ranking as you change the weights.
- **Slides** &mdash; a short navigable deck of the whole argument.
- **Brief** &mdash; a printable PDF version.

## Data

All public, no logins, no paid sources.

| Source | Used for | File |
|:--|:--|:--|
| [Natural Earth](https://www.naturalearthdata.com) | Country shapes, coastlines, proximity reference | loaded via `rnaturalearth` |
| Operator reporting and [Global Energy Monitor](https://globalenergymonitor.org) | Terminal locations, capacity, status | `lng_terminals.csv` |
| [Eurostat](https://ec.europa.eu/eurostat) `nrg_ind_id` | Gas import dependency | `import_dependence.csv` |
| [Eurostat](https://ec.europa.eu/eurostat) `nrg_cb_gas` | Inland gas consumption | `gas_demand.csv` |
| [Eurostat](https://ec.europa.eu/eurostat) `nrg_ti_gas` | Imports from Russia, 2021 and 2023 | `russian_imports.csv` |
| Operator and press reporting | Subsea corridors and incident dates | `transit_lines.csv` |

A scheduled job re-pulls the Eurostat series each month and rebuilds the site if
the figures change. The Data page also shows one figure fetched live from the
Eurostat API when the page loads.

## Method

Distances are measured in a projection suited to Europe (ETRS89 / LAEA Europe), so
they come out in kilometres rather than degrees. The exposure score combines three
things, each with a stated weight: proximity to Russian territory (0.4), share of
the region's import capacity (0.3), and the length of the supply route past the
Danish Straits (0.3). The weights are a judgement, not a finding, and the Analysis
page lets any reader change them and watch the ranking move.

## Run it yourself

<details>
<summary>Step by step, no R experience needed</summary>

<br>

1. **Install R** from [cloud.r-project.org](https://cloud.r-project.org).
2. **Install RStudio** from [posit.co](https://posit.co/download/rstudio-desktop). This is the program you actually open.
3. **Install Quarto** from [quarto.org](https://quarto.org/docs/get-started). This turns the analysis into the website.
4. **Download the project**: green **Code** button above, then **Download ZIP**, and unzip it.
5. **Open** `baltic-energy-transit.Rproj` in RStudio.
6. **Install the packages.** In the Console panel, paste this and press Enter:

   ```r
   install.packages(c("sf", "dplyr", "readr", "ggplot2", "leaflet",
                      "rnaturalearth", "rnaturalearthdata", "scales",
                      "gt", "reactable", "ggrepel", "jsonlite",
                      "rmarkdown", "knitr"))
   ```

7. **Build the site.** In the Terminal panel, run:

   ```
   quarto render
   ```

8. **Open** `docs/index.html` in a browser.

Edit a page, run `quarto render` again, refresh. That is the whole loop.

</details>

<details>
<summary>Repository layout</summary>

<br>

```
index.qmd                      Overview page
01-data.qmd                    Data page
02-analysis.qmd                Analysis page (maps and numbers)
slides.qmd                     Slide deck
brief.qmd                      Printable PDF brief
_quarto.yml                    Site settings
theme.scss / slides.scss       Visual themes
data/processed/                The data tables the analysis reads
scripts/                       R scripts that reproduce the data layers
docs/                          Built site (created by quarto render)
.github/workflows/             Build, publish, and monthly data refresh
```

</details>

## What to check before citing

The structure, maps and method are reproducible, and the Eurostat figures come
straight from the API. Terminal capacities are compiled from operator reporting and
are current to 2024 and 2025, so confirm them against the latest source if you cite
a specific date. Note that published headline figures often describe planned rather
than operating capacity: Mukran is widely quoted at 13.5 bcm, which assumes a second
FSRU that is no longer on charter, so it is counted here at about 6 bcm.

## Limitations

This measures geographic exposure, not the probability of disruption. It uses proxy
measures rather than a causal model, and it is a single snapshot. It shows where
the exposure sits. It is not a risk forecast.

## Licence

Code released under the MIT Licence. Each data source keeps its own terms, listed
on the [Data](https://tobyn-smith.github.io/transit/01-data.html) page.
