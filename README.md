<h1 align="center">Baltic Energy Transit Risk</h1>

<p align="center">
  A student project on the coastal LNG (liquefied natural gas) terminals that replaced Russian pipeline gas around the Baltic after 2022, and how exposed each one looks from public data alone.
</p>

<p align="center">
  <a href="https://tobynsmith.me/baltic/"><strong>Read the site</strong></a> ·
  <a href="https://tobynsmith.me/baltic/slides.html">Slides</a> ·
  <a href="https://tobynsmith.me/baltic/02-analysis.html">Analysis</a> ·
  <a href="https://tobynsmith.me/baltic/01-data.html">Data</a>
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
  <img src="https://tobynsmith.me/baltic/02-analysis_files/figure-html/map-concentration-1.png"
       alt="Map of Baltic LNG import terminals sized by capacity and coloured by exposure" width="620">
</p>

---

## What this is

This started as a student project in international affairs. I wanted to map the terminals the Baltic region built after Russian pipeline gas stopped, and to work out how exposed each one looks from public data alone.

In 2021 the eight countries on that sea took about 70 bcm (billion cubic metres) of gas from Russia by pipe. By 2023 that was almost nothing. Five working coastal terminals, plus a sixth planned at Gdańsk, can land about 23 bcm a year, which is roughly a third of what stopped arriving. The rest of the gap closed because demand fell and because gas still comes in by pipe from Norway and the west.

On a normal year, then, the region is not short of gas. What I kept coming
back to is how concentrated those terminals are, how close they sit to Russian
territory, and how much of the supply run depends on ships coming through the
Danish Straits.

> After 2022, Baltic energy imports shifted onto a small set of coastal LNG
> terminals. How concentrated is that infrastructure, and how exposed is it,
> measured by capacity, by distance to Russian territory, and by how far a
> cargo has to run past the Danish Straits?

## What I found

The part I care most about is the overbuild in Finland and Lithuania. The spare capacity sits on the terminals closest to Russia.

| | |
|:--|:--|
| The terminals only partly filled the hole | About 23 bcm of operating capacity against roughly 70 bcm of Russian pipeline gas that stopped. Lower demand and western pipeline gas closed the rest. |
| Capacity sits in the south | Świnoujście and Mukran hold about three fifths of operating capacity. The northeast runs on one or two terminals each. |
| The small terminals are the close ones | Hamina, Klaipėda and Gdańsk sit nearest Russian territory. The two largest sites sit farthest away. |
| There is one way in | Every cargo passes the Danish Straits. The Kiel Canal is too small for LNG carriers. |
| Finland and Lithuania overbuilt on purpose | They hold capacity worth several times their own demand, and neighbours draw on it. |
| Knock out the largest terminal and the cover goes | Finland drops to about a fifth of demand on Hamina alone. Lithuania, Poland and Germany drop to no seaborne capacity. |

## What is on the site

- **Overview:** the question, what I found, what I would take from it, and the
  limits.
- **Data:** every source, with the tables sortable, searchable and
  downloadable.
- **Analysis:** maps and charts, a ranked exposure table, and sliders that
  recompute the ranking when you change the weights.
- **Slides:** a short deck of the same argument.
- **Brief:** a printable PDF.

## Data

Everything is public, with no logins and no paid sources.

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

## How the score works

I measure distances in a projection suited to Europe (ETRS89 / LAEA Europe), which gives kilometres rather than degrees. I score each terminal on three things, each with a stated weight: proximity to Russian territory (0.4), share of the region's import capacity (0.3), and the length of the supply route past the Danish Straits (0.3).

I put the most weight on proximity because the question is about exposure to one neighbour, and distance is the most direct thing the public data will support. The weights are my own judgement, and on the Analysis page you can change them and watch the ranking move.

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

The structure, maps and method are reproducible, and the Eurostat figures come straight from the API. I compiled the terminal capacities from operator reporting, and they are current to 2024 and 2025. If you cite one for a specific date, check it against the latest source. Published headline figures often describe planned rather than operating capacity. Mukran, for example, is widely quoted at 13.5 bcm, which assumes a second FSRU (a floating terminal ship) that is no longer on charter, and I count it here at about 6 bcm.

## Limitations

This measures geographic exposure. It does not measure the probability of disruption. It uses proxy measures and is not a causal model, and it is a single snapshot. I would use it to see where the exposure sits, and I would not cite it as a forecast.

## Licence

Code released under the MIT Licence. Each data source keeps its own terms,
listed on the [Data](https://tobynsmith.me/baltic/01-data.html) page.
