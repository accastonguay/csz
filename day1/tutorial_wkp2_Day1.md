Workshop on modelling and mapping suitability of climate-sensitive
zoonotic diseases
================
2023-07-12

# Overview of Day 1 training

## What are we going to learn?

Today:

1.  [R Overview and installation](#installation)
2.  [Understanding R Studio](#understanding-r-studio)
3.  [Assigning variables](#assigning-variables)
4.  [Data types](#data-types)
5.  [Data structures](#data-structures)
6.  [Packages](#packages)
7.  [Working with spatial data](#working-with-spatial-data)

Tomorrow:

1.  Species distribution modelling
2.  Structural equation modelling
3.  Climate change scenarios
4.  Model uncertainty and sensitivity

## R + RStudio

The [R programming language](https://cran.r-project.org/) is a language
used for calculations, statistics, visualisations and many more data
science tasks.

[RStudio](https://rstudio.com/products/rstudio/) is an open source
Integrated Development Environment (IDE) for R, which means it provides
many features on top of R to make it easier to write and run code.

## Installation

For this workshop, you need to have both R and RStudio installed
([installation
instructions](https://github.com/uqlibrary/technology-training/blob/master/R/Installation.md#r--rstudio-installation-instructions)).

## Understanding R Studio

- Console: interactive coding
- Script: write code first and then run chunks of code
- Additional panels: visualise plots, install packages, view environment

<figure>
<img
src="C:/Users/uqachare/OneDrive%20-%20The%20University%20of%20Queensland/Pictures/Screenshot%202023-07-10%20215558.png"
alt="Rstudio" />
<figcaption aria-hidden="true">Rstudio</figcaption>
</figure>

## Assigning variables

When working with R, we need to assign values we want to work with to
variables. In R this is typically done with the `<-` operator. The left
term (`var`) is the variable and the term on the right (`1`) is the
value assigned

``` r
# assign a single value
var <- 1
var
```

    ## [1] 1

## Data types

In R we have 4 main types (classes) of data:

1.  numeric (e.g., `2.21`)
2.  integer (e.g., `2`)
3.  character (using `''` or `""`, e.g., `"hello world"`)
4.  logical (`TRUE` or `FALSE`)

You can inspect the type of data with the `class()` function:

``` r
var <- "hello world"
class(var)
```

    ## [1] "character"

## Data structures

- vectors
- dataframes
- lists
- matrix
- arrays

``` r
# assign a vector
vec <- c(1,2,3,4)
vec
```

    ## [1] 1 2 3 4

``` r
# assign a dataframe
df <- data.frame(col1 = c(1,2,3,4),
                 col2 = c("a","b","c","d"))
df
```

    ##   col1 col2
    ## 1    1    a
    ## 2    2    b
    ## 3    3    c
    ## 4    4    d

## Packages

Packages are a group of functions that add functionalities to R and
RStudio but that require to be loaded before use.

You can install a package with the command `install.packages("package")`
or using the user interface with the Packages tab on the right panel. To
use a function in a package, the package need to be loaded for each new
active session with the command `library(package)`.

### Exercise

1.  To work with spatial data we will use the `terra` package. Install
    `terra` with

``` r
install.packages("terra")
```

2.  Then we need to load `terra` with

``` r
library(terra)
```

3.  Open the documentation page for the `terra` package with `?`

``` r
?terra
```

4.  Look at the documentation to explore specific `terra` functions, for
    instance `rasterize()`

``` r
?rasterize
```

5.  Install multiple packages that we will need for modelling by using a
    vector of package names

``` r
install.packages(c("bangladesh", # maps of Bangladesh
                   "sf", # Work with vector data
                   "raster", # raster data manipulation
                   "dplyr", # data manipulation 
                   "dismo", # species distribution modelling
                   "rgbif", # species occurrence data
                   "lavaan", # latent variable analysis and SEM
                   "lavaanPlot") # Additional functionalities for SEM)
```

## Working with spatial data

### Data structure for spatial data

#### 1. Rasters

- Grid with determined by extent and size (rows, columns)
- Grid cells all have the same resolution
- Metadata, e.g., resolution, extent, size, coordinate reference system.
  name of layer (layers if more than one).

#### 2. Vectors:

- Points, lines and polygons
- Each spatial entity has its location (e.g., lon, lat) or boundary
- Metadata include coordinate reference system

<figure>
<img
src="https://upload.wikimedia.org/wikipedia/commons/b/b8/Raster_vector_tikz.png"
alt="Wegmann, CC BY-SA 3.0 https://creativecommons.org/licenses/by-sa/3.0, via Wikimedia Commons" />
<figcaption aria-hidden="true">Wegmann, CC BY-SA 3.0 <a
href="https://creativecommons.org/licenses/by-sa/3.0"
class="uri">https://creativecommons.org/licenses/by-sa/3.0</a>, via
Wikimedia Commons</figcaption>
</figure>

### Reading and writing (spatial) data

- Reading spatial data: You need to read a file first to process or
  visualise it. With the `terra` package, a raster file can be read with
  the command `rast("file_path")` and a vector file can be read with
  `vect("file_path")` or `st_read("file_path")`. Remember to assign the
  data to a variable to be able to use it, e.g.,
  `var <- rast("file_path")`.

- Reading non-spatial tabular data can be read with different functions
  depending on the data type, e.g., `read.table()` for .txt file,
  `read.csv()` for comma separated values (CSV) or `readxl()` for excel
  files

- Writing spatial data: A raster file that was modified in R can be
  saved with `writeRaster(variable, "file_path")`. Make sure metadata is
  correct before saving a file.

### Understanding working directories

Getting to know your working directory, i.e., where your R file is
located and where it will look to read and write files

``` r
getwd()
```

You can change your working directory with the command

``` r
setwd("./")
```

### Manipulating spatial data

#### Rasters:

- Crop
- mask
- resample

#### Vectors:

- Filter
- Rasterize
- Clip
- Buffer

## Exercise

Generally we want to stick to one type of spatial data to make it easier
to work with, for instance using only raster layers with the same size,
resolution and extent. Some times we obtain data in both vector and
raster formats and need to process the data in order to have all
datasets in the same format.

1.  Read raster
2.  Read vector
3.  Crop raster to vector extent
4.  Read non-spatial csv file and convert it to vector

#### 1. Read the bioclimatic raster data from [WorldClim](https://www.worldclim.org/data/bioclim.html) online repository and inspect the file

``` r
library(terra)
```

    ## terra 1.7.39

``` r
bc1 <- rast("./data/wc2.1_5m_bio_1.tif")
```

Then you can inspect the metadata:

``` r
bc1
```

    ## class       : SpatRaster 
    ## dimensions  : 2160, 4320, 1  (nrow, ncol, nlyr)
    ## resolution  : 0.08333333, 0.08333333  (x, y)
    ## extent      : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)
    ## coord. ref. : lon/lat WGS 84 (EPSG:4326) 
    ## source      : wc2.1_5m_bio_1.tif 
    ## name        : wc2.1_5m_bio_1 
    ## min value   :      -54.73946 
    ## max value   :       31.05112

Visualise the layer(s) of the raster with the `plot` function:

``` r
plot(bc1)
```

![](tutorial_wkp2_Day1_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

#### 2. Read and plot vector

Load the `bangladesh` library and inspect the vector dataframe

``` r
library(bangladesh)
```

    ## The legacy packages maptools, rgdal, and rgeos, underpinning the sp package,
    ## which was just loaded, will retire in October 2023.
    ## Please refer to R-spatial evolution reports for details, especially
    ## https://r-spatial.org/r/2023/05/15/evolution4.html.
    ## It may be desirable to make the sf package available;
    ## package maintainers should consider adding sf to Suggests:.
    ## The sp package is now running under evolution status 2
    ##      (status 2 uses the sf package in place of rgdal)

``` r
head(map_upazila)
```

    ## Simple feature collection with 6 features and 8 fields
    ## Geometry type: MULTIPOLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: 88.96239 ymin: 22.9003 xmax: 91.37802 ymax: 26.10616
    ## Geodetic CRS:  WGS 84
    ##      Upazila ADM3_PCODE    District ADM2_PCODE Division ADM1_PCODE    ADM0_EN
    ## 1 Abhaynagar     404104     Jessore       4041   Khulna         40 Bangladesh
    ## 2     Adabor     302602       Dhaka       3026    Dhaka         30 Bangladesh
    ## 3  Adamdighi     501006       Bogra       5010 Rajshahi         50 Bangladesh
    ## 4   Aditmari     555202 Lalmonirhat       5552  Rangpur         55 Bangladesh
    ## 5 Agailjhara     100602     Barisal       1006  Barisal         10 Bangladesh
    ## 6 Ajmiriganj     603602    Habiganj       6036   Sylhet         60 Bangladesh
    ##   ADM0_PCODE                       geometry
    ## 1         BD MULTIPOLYGON (((89.50107 23...
    ## 2         BD MULTIPOLYGON (((90.35766 23...
    ## 3         BD MULTIPOLYGON (((89.08524 24...
    ## 4         BD MULTIPOLYGON (((89.45985 25...
    ## 5         BD MULTIPOLYGON (((90.22204 22...
    ## 6         BD MULTIPOLYGON (((91.21907 24...

Notice that, as opposed to a raster, vector data are organised as a
dataframe. Plot the geometries and specify the column “Upazila” to be
shown

``` r
plot(map_upazila['Upazila'])
```

![](tutorial_wkp2_Day1_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

#### 3. Crop raster to the geographical extent of Bangladesh with the `crop()` function.

Values outside of the area of interest can be masked (converted to NA)
with the `mask = TRUE` argument.

``` r
cropped_bc1 <- crop(bc1, map_country, mask = TRUE)
plot(cropped_bc1)
plot(map_country['geometry'], add = T)
```

![](tutorial_wkp2_Day1_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

#### 4. Convert a point dataset to raster in three step:

1.  Read non-spatial data from FAO EMPRES-i+
    (<https://empres-i.apps.fao.org/>) as dataframe
2.  Convert dataframe to spatial data structure using the `sf` package  
3.  Convert polygon data to raster

``` r
empres_data <- read.csv("data/empress_i_AIV.csv")
head(empres_data)
```

    ##   Event.ID           Disease    Serotype latitude longitude       Locality
    ## 1   231391 Influenza - Avian ;H5N8 HPAI; 34.99470  34.04310      PARALIMNi
    ## 2   337075 Influenza - Avian ;H5N1 HPAI; 35.01985  33.97469      Paralimni
    ## 3   337074 Influenza - Avian ;H5N1 HPAI; 35.02081  33.98746    Paralimni 1
    ## 4   355354 Influenza - Avian ;H5N1 HPAI; 57.45099  22.89886   Rojas parish
    ## 5   356560 Influenza - Avian ;H5N1 HPAI; 57.28137  22.64120 LAIDZES PARISH
    ## 6   305918 Influenza - Avian ;H5N1 HPAI; 57.40813  22.94220   Rojas county
    ##   Country Region     observation_date          report_date
    ## 1  Cyprus   Asia 2017-09-20T00:00:00Z 2017-10-24T00:00:00Z
    ## 2  Cyprus   Asia 2022-11-24T00:00:00Z 2022-12-09T00:00:00Z
    ## 3  Cyprus   Asia 2022-11-24T00:00:00Z 2022-12-09T00:00:00Z
    ## 4  Latvia Europe 2023-05-28T00:00:00Z 2023-06-08T00:00:00Z
    ## 5  Latvia Europe 2023-06-21T00:00:00Z 2023-06-22T00:00:00Z
    ## 6  Latvia Europe 2021-06-02T00:00:00Z 2021-11-02T00:00:00Z
    ##                                                     Species Diagnosis.Source
    ## 1     Wild,Eurasian buzzard (common buzzard) (Buteo buteo),              OIE
    ## 2                                Domestic,Unspecified bird,              OIE
    ## 3                                Domestic,Unspecified bird,              OIE
    ## 4              Wild,Herring Gull:Larus argentatus(Laridae),              OIE
    ## 5 Wild,Laridae (unidentified):Laridae (incognita)(Laridae),              OIE
    ## 6              Wild,Herring Gull:Larus argentatus(Laridae),              OIE
    ##   Humans.Affected Human.Deaths Diagnosis.Status
    ## 1              NA           NA        Confirmed
    ## 2              NA           NA        Confirmed
    ## 3              NA           NA        Confirmed
    ## 4              NA           NA        Confirmed
    ## 5              NA           NA        Confirmed
    ## 6              NA           NA        Confirmed

#### 5. Only keep data for Bangladesh using the `filter` function

``` r
empres_bgd <- dplyr::filter(empres_data, Country == 'Bangladesh')
head(empres_bgd)
```

    ##   Event.ID           Disease    Serotype latitude longitude
    ## 1   133793 Influenza - Avian ;H5N1 HPAI; 22.67368  90.62346
    ## 2   161709 Influenza - Avian ;H5N1 HPAI; 22.41000  90.25000
    ## 3   133776 Influenza - Avian ;H5N1 HPAI; 22.13435  90.11112
    ## 4   133811 Influenza - Avian ;H5N1 HPAI; 22.13435  90.11112
    ## 5   133772 Influenza - Avian ;H5N1 HPAI; 22.13435  90.11112
    ## 6   161691 Influenza - Avian ;H5N1 HPAI; 22.39000  90.13000
    ##                    Locality    Country Region     observation_date
    ## 1              Char Noaabad Bangladesh   Asia 2008-01-27T00:00:00Z
    ## 2 Shamim Ahmed poultry farm Bangladesh   Asia 2011-03-07T00:00:00Z
    ## 3                    Ward-3 Bangladesh   Asia 2008-01-18T00:00:00Z
    ## 4                     Crock Bangladesh   Asia 2008-02-01T00:00:00Z
    ## 5                    Thalua Bangladesh   Asia 2008-01-13T00:00:00Z
    ## 6 Aminul Islam poultry farm Bangladesh   Asia 2011-03-03T00:00:00Z
    ##            report_date                    Species     Diagnosis.Source
    ## 1 2008-03-16T00:00:00Z Domestic,unspecified bird, National authorities
    ## 2 2011-03-24T00:00:00Z Domestic,unspecified bird,                  OIE
    ## 3 2008-03-16T00:00:00Z Domestic,unspecified bird, National authorities
    ## 4 2008-03-16T00:00:00Z Domestic,unspecified bird, National authorities
    ## 5 2008-03-16T00:00:00Z Domestic,unspecified bird, National authorities
    ## 6 2011-03-24T00:00:00Z Domestic,unspecified bird,                  OIE
    ##   Humans.Affected Human.Deaths Diagnosis.Status
    ## 1              NA           NA        Confirmed
    ## 2              NA           NA        Confirmed
    ## 3              NA           NA        Confirmed
    ## 4              NA           NA        Confirmed
    ## 5              NA           NA        Confirmed
    ## 6              NA           NA        Confirmed

#### 6. Convert dataframe to spatial data using the coordinate columns `latitude` and `longitude` with the `sf` package.

``` r
library(sf)
```

    ## Linking to GEOS 3.11.2, GDAL 3.6.2, PROJ 9.2.0; sf_use_s2() is TRUE

``` r
sp_empres_bgd <- st_as_sf(empres_bgd, coords = c("longitude", "latitude"), crs = 4326)
head(sp_empres_bgd)
```

    ## Simple feature collection with 6 features and 13 fields
    ## Geometry type: POINT
    ## Dimension:     XY
    ## Bounding box:  xmin: 90.11112 ymin: 22.13435 xmax: 90.62346 ymax: 22.67368
    ## Geodetic CRS:  WGS 84
    ##   Event.ID           Disease    Serotype                  Locality    Country
    ## 1   133793 Influenza - Avian ;H5N1 HPAI;              Char Noaabad Bangladesh
    ## 2   161709 Influenza - Avian ;H5N1 HPAI; Shamim Ahmed poultry farm Bangladesh
    ## 3   133776 Influenza - Avian ;H5N1 HPAI;                    Ward-3 Bangladesh
    ## 4   133811 Influenza - Avian ;H5N1 HPAI;                     Crock Bangladesh
    ## 5   133772 Influenza - Avian ;H5N1 HPAI;                    Thalua Bangladesh
    ## 6   161691 Influenza - Avian ;H5N1 HPAI; Aminul Islam poultry farm Bangladesh
    ##   Region     observation_date          report_date                    Species
    ## 1   Asia 2008-01-27T00:00:00Z 2008-03-16T00:00:00Z Domestic,unspecified bird,
    ## 2   Asia 2011-03-07T00:00:00Z 2011-03-24T00:00:00Z Domestic,unspecified bird,
    ## 3   Asia 2008-01-18T00:00:00Z 2008-03-16T00:00:00Z Domestic,unspecified bird,
    ## 4   Asia 2008-02-01T00:00:00Z 2008-03-16T00:00:00Z Domestic,unspecified bird,
    ## 5   Asia 2008-01-13T00:00:00Z 2008-03-16T00:00:00Z Domestic,unspecified bird,
    ## 6   Asia 2011-03-03T00:00:00Z 2011-03-24T00:00:00Z Domestic,unspecified bird,
    ##       Diagnosis.Source Humans.Affected Human.Deaths Diagnosis.Status
    ## 1 National authorities              NA           NA        Confirmed
    ## 2                  OIE              NA           NA        Confirmed
    ## 3 National authorities              NA           NA        Confirmed
    ## 4 National authorities              NA           NA        Confirmed
    ## 5 National authorities              NA           NA        Confirmed
    ## 6                  OIE              NA           NA        Confirmed
    ##                    geometry
    ## 1 POINT (90.62346 22.67368)
    ## 2       POINT (90.25 22.41)
    ## 3 POINT (90.11112 22.13435)
    ## 4 POINT (90.11112 22.13435)
    ## 5 POINT (90.11112 22.13435)
    ## 6       POINT (90.13 22.39)

plot points on map

``` r
plot(map_country['geometry'])
plot(sp_empres_bgd['geometry'], add = T, col = 'red', cex = 0.5, pch = 16)
```

![](tutorial_wkp2_Day1_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

#### 7. Rasterize infection cases points based on raster file with `terra` package

``` r
r_AIV <- rasterize(sp_empres_bgd, cropped_bc1)
names(r_AIV) <- "AIV_cases"
plot(r_AIV)
plot(map_country['geometry'], add = T)
plot(sp_empres_bgd['geometry'], add = T, col = 'red', cex = 0.5, pch = 16)
```

![](tutorial_wkp2_Day1_files/figure-gfm/unnamed-chunk-22-1.png)<!-- -->

Plot the two raster maps side-by-side

``` r
rasters <- c(cropped_bc1,r_AIV)
plot(rasters)
```

![](tutorial_wkp2_Day1_files/figure-gfm/unnamed-chunk-23-1.png)<!-- -->
