## ---------------------------------------------------------------------------------------
# assign a single value
var <- 1
var


## ---------------------------------------------------------------------------------------
var <- "hello world"
class(var)


## ---------------------------------------------------------------------------------------
# assign a vector
vec <- c(1,2,3,4)
vec

# assign a dataframe
df <- data.frame(col1 = c(1,2,3,4),
                 col2 = c("a","b","c","d"))
df


## ---- eval = FALSE----------------------------------------------------------------------
## install.packages("terra")


## ---- eval = FALSE----------------------------------------------------------------------
## library(terra)


## ---- eval = FALSE----------------------------------------------------------------------
## ?terra


## ---- eval = FALSE----------------------------------------------------------------------
## ?rasterize


## ---- eval = FALSE----------------------------------------------------------------------
## install.packages(c("bangladesh", # maps of Bangladesh
##                    "sf", # Work with vector data
##                    "raster", # raster data manipulation
##                    "dplyr", # data manipulation
##                    "dismo", # species distribution modelling
##                    "rgbif", # species occurrence data
##                    "lavaan", # latent variable analysis and SEM
##                    "lavaanPlot") # Additional functionalities for SEM)


## ---- eval=FALSE------------------------------------------------------------------------
## getwd()


## ---------------------------------------------------------------------------------------
setwd("./")


## ---- echo = FALSE----------------------------------------------------------------------
setwd("C:/Users/uqachare/OneDrive - The University of Queensland/Documents/WB project/bangladesh_model/r_codes/tutorial_workshop2")


## ---------------------------------------------------------------------------------------
library(terra)

bc1 <- rast("./data/wc2.1_5m_bio_1.tif")


## ---------------------------------------------------------------------------------------
bc1


## ---------------------------------------------------------------------------------------
plot(bc1)


## ---------------------------------------------------------------------------------------
library(bangladesh)
head(map_upazila)


## ---------------------------------------------------------------------------------------
plot(map_upazila['Upazila'])


## ---------------------------------------------------------------------------------------
cropped_bc1 <- crop(bc1, map_country, mask = TRUE)
plot(cropped_bc1)
plot(map_country['geometry'], add = T)


## ---------------------------------------------------------------------------------------
empres_data <- read.csv("data/empress_i_AIV.csv")
head(empres_data)


## ---------------------------------------------------------------------------------------
empres_bgd <- dplyr::filter(empres_data, Country == 'Bangladesh')
head(empres_bgd)


## ---------------------------------------------------------------------------------------
library(sf)
sp_empres_bgd <- st_as_sf(empres_bgd, coords = c("longitude", "latitude"), crs = 4326)
head(sp_empres_bgd)


## ---------------------------------------------------------------------------------------
plot(map_country['geometry'])
plot(sp_empres_bgd['geometry'], add = T, col = 'red', cex = 0.5, pch = 16)


## ---------------------------------------------------------------------------------------
r_AIV <- rasterize(sp_empres_bgd, cropped_bc1)
names(r_AIV) <- "AIV_cases"
plot(r_AIV)
plot(map_country['geometry'], add = T)
plot(sp_empres_bgd['geometry'], add = T, col = 'red', cex = 0.5, pch = 16)


## ---------------------------------------------------------------------------------------
rasters <- c(cropped_bc1,r_AIV)
plot(rasters)

