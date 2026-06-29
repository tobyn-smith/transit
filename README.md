# Baltic Energy Transit Risk

This project looks at a real energy security problem in the Baltic Sea region.
Before 2022, much of the region's natural gas arrived by pipeline from Russia.
After the invasion of Ukraine and the sabotage of the Nord Stream pipelines,
that supply was cut or abandoned, and imports shifted onto a small number of
coastal LNG terminals and ports. This project maps where that infrastructure
sits and measures how exposed it is to geopolitical pressure.

It is built in R, uses spatial (GIS) methods, relies only on public data, and
publishes as a small website.

## The research question

After 2022, Baltic energy imports shifted onto a small set of coastal LNG
terminals and ports. How concentrated is that infrastructure, and how exposed is
it, measured by capacity, by distance to Russian territory (including the
Kaliningrad exclave), and by reliance on the single shipping route through the
Danish Straits?

## What the project shows

The website has three pages:

- **Overview**: the question, the main findings in plain language, and a list of
  limitations.
- **Data**: every source, all public, with notes on what is solid and what is
  still approximate.
- **Analysis**: the maps and the numbers. A map of the terminals sized by
  capacity, a chart of how close each one is to Russian territory, a map of
  national gas import dependence, a ranked table of exposure, and an interactive
  map you can click through.

## Data sources

All public, no logins, no paid datasets:

- Natural Earth, for country shapes and coastlines (loaded through an R package,
  so nothing to download by hand).
- A small table of the region's LNG terminals (name, country, location,
  approximate capacity, status), kept in `data/processed/lng_terminals.csv`.
- National gas import dependence from Eurostat (indicator `nrg_ind_id`), kept in
  `data/processed/import_dependence.csv` and reproduced by `scripts/03_eurostat.R`.

## Run it yourself (no programming experience needed)

You do not need to know R to build this. Follow these steps in order.

1. **Install R.** Go to [https://cloud.r-project.org](https://cloud.r-project.org)
   and install the version for your computer (Windows or Mac). R is the language
   the analysis is written in.

2. **Install RStudio.** Go to
   [https://posit.co/download/rstudio-desktop](https://posit.co/download/rstudio-desktop)
   and install the free version. RStudio is the program you actually open to work
   with R.

3. **Install Quarto.** Go to
   [https://quarto.org/docs/get-started](https://quarto.org/docs/get-started)
   and install it. Quarto is the tool that turns the analysis into a website.

4. **Get the project onto your computer.** On the project's GitHub page, click
   the green **Code** button, choose **Download ZIP**, and unzip it somewhere you
   can find, such as your Desktop.

5. **Open the project in RStudio.** Open RStudio, go to **File > Open Project**,
   and pick `baltic-energy-transit.Rproj` in the folder you just unzipped.

6. **Install the R packages the project needs.** In RStudio, find the
   **Console** panel (usually bottom left), paste the line below, and press
   Enter. This downloads the tools the analysis uses. It only has to be done
   once and may take a few minutes.

   ```r
   install.packages(c("sf", "dplyr", "readr", "ggplot2", "leaflet",
                      "rnaturalearth", "rnaturalearthdata", "scales",
                      "rmarkdown", "knitr"))
   ```

7. **Build the website.** Open the **Terminal** panel in RStudio (the tab next to
   Console), type the line below, and press Enter:

   ```
   quarto render
   ```

8. **Look at the result.** A folder called `docs` now contains the finished site.
   Open `docs/index.html` in your web browser to read it.

That is the whole loop. Edit a page, run `quarto render` again, refresh the
browser.

## How it publishes online

The project is set up to publish to GitHub Pages automatically. Every time the
project is updated on GitHub, a routine in `.github/workflows/publish.yml`
rebuilds the site and posts it online. There is nothing extra to run for this to
happen.

## What is solid and what to double check

The structure, the maps, and the method are real and reproducible. The gas
import dependence values in `import_dependence.csv` come from Eurostat (indicator
`nrg_ind_id`, natural gas, 2023), and `scripts/03_eurostat.R` reproduces that
pull. One input still needs checking before anyone treats the rankings as
authoritative:

- The terminal capacities in `lng_terminals.csv` are compiled from public
  reporting. Check them against the Global Energy Monitor LNG tracker and
  operator figures.

Both files are plain spreadsheets. You can open and edit them in Excel.

## What is in the folder

```
README.md                      this file
baltic-energy-transit.Rproj    the RStudio project file
_quarto.yml                    settings for the website
index.qmd                      the Overview page
01-data.qmd                    the Data page
02-analysis.qmd                the Analysis page (maps and numbers)
data/processed/                the small data tables the analysis reads
scripts/                       R scripts that reproduce the data layers
docs/                          the finished website (created when you build)
.github/workflows/             the routine that publishes the site online
```

## A note on method

All distances are measured in a projection suited to Europe (ETRS89 / LAEA
Europe), so they come out in kilometres rather than degrees. The exposure score
combines three things, each given a stated weight: how close a terminal is to
Russian territory, how large its capacity is, and how close it is to the Danish
Straits. The weights are written plainly in the analysis so anyone can see, and
change, the assumptions.

## License

Code is released under the MIT License. Each data source keeps its own terms,
listed on the Data page.
