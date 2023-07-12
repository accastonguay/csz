## What we will see today

1.  Species distribution modelling
2.  Structural equation modelling
3.  Climate change scenarios
4.  Model uncertainty and sensitivity

## Setting up the working directory

Using the `setwd()` function,

## Species distribution modelling

Species distribution models (SDMs) or Ecological Niche Models (ENMs) are
used to explore how the occurrence of a species is related to the
environment, and how a species might respond to changes in its
environment.

Comprehensive documentation on [distribution modelling in
R](https://rspatial.org/raster/sdm/).

There are many types of SDMs, we will be using Maxent (Maximum Entropy
modelling).

## Species distribution modelling

<img
src="C:/Users/uqachare/Downloads/quarto_pics/AI_model_BGD_quarto_full.png"
data-fig-align="center" />

## Species distribution modelling

<img
src="C:/Users/uqachare/Downloads/quarto_pics/AI_model_BGD_quarto.png"
data-fig-align="center" width="300" />

## Inputs of Maxent

To develop an SDM, we need two main inputs:

-   Point data of occurence of a species

-   Rasters of environmental predictors.

## Outputs of Maxent

The main output of a SDM is a raster map of probability of occurrence of
a species given environmental predictors.

More analysis can then be done by looking at the importance of each
predictor.

## Dependencies

To run a maxent model in R we will need to

1.  Have
    [Java](https://www.java.com/en/download/help/download_options.html)
    installed, as maxent is a software written in Java
2.  Have the `dismo` (distribution modelling) package installed to
    access the R maxent function
3.  `rgibf` library to access occurrence of species online of the
    [Global Biodiversity Infrastructure
    Facility](https://www.gbif.org/).

## Dependencies

Once dependencies have been installed, we can load the required
libraries

    library(dismo)

    ## Loading required package: raster

    ## Loading required package: sp

    ## The legacy packages maptools, rgdal, and rgeos, underpinning the sp package,
    ## which was just loaded, will retire in October 2023.
    ## Please refer to R-spatial evolution reports for details, especially
    ## https://r-spatial.org/r/2023/05/15/evolution4.html.
    ## It may be desirable to make the sf package available;
    ## package maintainers should consider adding sf to Suggests:.
    ## The sp package is now running under evolution status 2
    ##      (status 2 uses the sf package in place of rgdal)

    library(terra)

    ## terra 1.7.39

    library(rgbif)
    library(bangladesh)
    library(dplyr)

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:terra':
    ## 
    ##     intersect, union

    ## The following objects are masked from 'package:raster':
    ## 
    ##     intersect, select, union

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    # setwd("")

## Reading the inputs: occurrence of species

Download occurrence points of (**Indian pied myna) *Gracupica contra***
from the **Passeriformes** order from GBIF

## Reading the inputs: occurrence of species

    myspecies <- "Gracupica contra"

    gbif_data <- occ_data(scientificName = myspecies, 
                            country  = 'BD', 
                            limit = 1000,
                            hasCoordinate = TRUE)
    occ <- gbif_data$data %>%
      dplyr::select(lon = decimalLongitude, lat = decimalLatitude)

    head(occ)

    ## # A tibble: 6 × 2
    ##     lon   lat
    ##   <dbl> <dbl>
    ## 1  90.4  23.9
    ## 2  88.6  26.1
    ## 3  88.6  24.4
    ## 4  90.4  23.8
    ## 5  90.4  23.7
    ## 6  90.4  23.7

## Plot occurrence

    plot(map_country['geometry'])
    points(occ, col = 'red', pch = 16, cex = 0.5)

![](md_day2_files/figure-markdown_strict/unnamed-chunk-3-1.png)

## Process occurrence data

Partition the occurrence dataset to create a model testing subset with
the `kfold` function

    # witholding a 20% sample for testing 
    fold <- kfold(occ, k=5)
    occtest <- occ[fold == 1, ]
    occtrain <- occ[fold != 1, ]

## Reading the inputs: predictors

Reading rasters of environmental predictors. We will use rasters of
proximity to nesting wetland, temperature and cropland fraction as
environmental predictors.

    # path <- "./" 
    # setwd(path)  
    predictors <- rast("./data_day2/sdm_inputs.tif") 
    predictors <- predictors[[c("Annual_Mean_Temp", "dist_wetlands", "cropland_fraction")]]

## Reading the inputs

    plot(predictors)

![](md_day2_files/figure-markdown_strict/unnamed-chunk-6-1.png)

## Run the Maxent model

    raster_predictors <- stack(predictors)
    occtrain_df <- as.data.frame(occtrain)

    me <- maxent(raster_predictors, occtrain_df)

    ## Loading required namespace: rJava

    me

    ## class    : MaxEnt 
    ## variables: Annual_Mean_Temp dist_wetlands cropland_fraction

Maxent requires a `raster` object for predictors and a `data.frame`
object, therefore

## Predict occurrence

    r <- predict(me, stack(predictors)) 

    plot(r)

![](md_day2_files/figure-markdown_strict/unnamed-chunk-8-1.png)

## Predict and map occurrence

    r <- predict(me, stack(predictors)) 

    plot(r)
    points(occ, pch = 16, col = 'red', cex = 0.5)

![](md_day2_files/figure-markdown_strict/unnamed-chunk-9-1.png)

## Explore the contribution of predictors

    plot(me)

![](md_day2_files/figure-markdown_strict/unnamed-chunk-10-1.png)

## Model validation

Assess the goodness-of-fit of the model with the area under the curve
(AUC) of the Receiver Operating Characteristic (ROC) Curve metric

    #Generate background/random data
    bg <- randomPoints( stack(predictors), 1000)

    e1 <- evaluate(me, p=occtest, a=bg, x=predictors)
    e1

    ## class          : ModelEvaluation 
    ## n presences    : 200 
    ## n absences     : 1000 
    ## AUC            : 0.837225 
    ## cor            : 0.4707388 
    ## max TPR+TNR at : 0.8167796

## Exercise

Apply the model with different predictors and explore their
contribution:

-   Annual precipitation
-   Mean temperature of the warmest quarter
-   Urban fraction
-   Forest fraction

## Exercise

Run maxent model for other species, e.g.:

-   House crow (*Corvus splendens*)
-   House sparrow (*Passer domesticus*)
-   Northern pintail (*Anas acuta*)
-   Tufted duck (*Aythya fuligula*)

## Full maxent model with 27 predictors

![](md_day2_files/figure-markdown_strict/unnamed-chunk-12-1.png)

## Full maxent model with 27 predictors

    ## class          : ModelEvaluation 
    ## n presences    : 200 
    ## n absences     : 1000 
    ## AUC            : 0.9541275 
    ## cor            : 0.738594 
    ## max TPR+TNR at : 0.481757

## Full maxent model with 27 predictors

![](md_day2_files/figure-markdown_strict/unnamed-chunk-14-1.png)

## Species distribution modelling

-   Wild birds (111 species) for avian influenza

-   Vectors (Culex spp., Phlebotomus spp, Aedes aegypti)

-   Rodents (25 species), bats (40 species)

![](C:/Users/uqachare/Downloads/quarto_pics/dengue_qrto.png)

## Structural equation modelling

#### What is a structural equation model

A multivariate statistical analysis technique that combines of factor
analysis and multiple regression analysis to evaluate the structural
relationship between measured variables and latent constructs.

## Why use a SEM?

We use SEM to identify the importance of factors driving the different
exposures

<img
src="C:/Users/uqachare/Downloads/quarto_pics/AI_model_BGD_subset_qrto.png"
data-fig-align="center" width="422" />

## How to we build a SEM in R

We will use the `lavaan` package for latent variable analysis. Lavaan
has a specific syntax that must be respected for R to understand the
model.

The operator `=~` signifies *is measured by*

The operator `~` signifies *is* *regressed on*

More information can be found on the [lavaan
website](https://lavaan.ugent.be/tutorial/syntax1.html).

## Syntax for submodel of avian influenza

    library(lavaan)

    ## This is lavaan 0.6-15
    ## lavaan is FREE software! Please report any bugs.

    mod <- '
      ### measurement model

      # Environmental exposures
      Bird_Nesting_exposure =~ waterfowl_ai_cases 

      # Animal exposures
      Commercial_exposure =~ cases_c_farms 
      Human_exposure =~ human_cases 
      
      ### regressions
      # Environmental exposures
      Bird_Nesting_exposure ~ curr_bird_dist + dist_wetlands

      # Animal exposures
      Commercial_exposure ~ Bird_Nesting_exposure + chicken_density  + duck_density
      Human_exposure ~ Commercial_exposure + urban_fraction + poverty + pop_density
    '

## Read data to input in model

    r <- rast("./data_day2/sem_inputs.tif")

    plot(r[[1:4]])

![](md_day2_files/figure-markdown_strict/unnamed-chunk-16-1.png)

## Process data to input in model

    r.scaled <- scale(r) %>%
      mask(map_country)
    plot(r.scaled[[1:4]])

![](md_day2_files/figure-markdown_strict/unnamed-chunk-17-1.png)

    df <- as.data.frame(r.scaled, na.rm = FALSE, xy=TRUE)
    df[is.na(df)] = 0

## Model fitting

Then we need to fit the data (`df`) to the model with the `sem()`
function

    fit <- sem(mod, data = df)

## Visualize graph

You can visualise the graph and look at the coefficients of the multiple
regressions to identify the importance of the different predictors

    library(lavaanPlot)
    lp <- lavaanPlot(model = fit, , coefs = TRUE)
    lp

![](md_day2_files/figure-markdown_strict/unnamed-chunk-19-1.png)

## Inspect summary of model fit

    summary(fit, standardized = TRUE)

    ## lavaan 0.6.15 ended normally after 35 iterations
    ## 
    ##   Estimator                                         ML
    ##   Optimization method                           NLMINB
    ##   Number of model parameters                        12
    ## 
    ##   Number of observations                          4088
    ## 
    ## Model Test User Model:
    ##                                                       
    ##   Test statistic                               482.456
    ##   Degrees of freedom                                15
    ##   P-value (Chi-square)                           0.000
    ## 
    ## Parameter Estimates:
    ## 
    ##   Standard errors                             Standard
    ##   Information                                 Expected
    ##   Information saturated (h1) model          Structured
    ## 
    ## Latent Variables:
    ##                            Estimate  Std.Err  z-value  P(>|z|)   Std.lv
    ##   Bird_Nesting_exposure =~                                             
    ##     waterfowl__css            1.000                               0.999
    ##   Commercial_exposure =~                                               
    ##     cases_c_farms             1.000                               0.990
    ##   Human_exposure =~                                                    
    ##     human_cases               1.000                               0.967
    ##   Std.all
    ##          
    ##     1.000
    ##          
    ##     1.000
    ##          
    ##     1.000
    ## 
    ## Regressions:
    ##                           Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##   Bird_Nesting_exposure ~                                                      
    ##     curr_bird_dist           0.144    0.027    5.383    0.000    0.144    0.084
    ##     dist_wetlands           -0.036    0.019   -1.893    0.058   -0.036   -0.029
    ##   Commercial_exposure ~                                                        
    ##     Brd_Nstng_xpsr           0.011    0.015    0.688    0.492    0.011    0.011
    ##     chicken_densty           0.217    0.040    5.459    0.000    0.219    0.172
    ##     duck_density            -0.127    0.036   -3.502    0.000   -0.129   -0.111
    ##   Human_exposure ~                                                             
    ##     Commercil_xpsr           0.010    0.003    3.554    0.000    0.010    0.010
    ##     urban_fraction           0.026    0.010    2.589    0.010    0.026    0.015
    ##     poverty                 -0.041    0.006   -7.289    0.000   -0.043   -0.022
    ##     pop_density              0.990    0.006  161.875    0.000    1.024    0.973
    ## 
    ## Variances:
    ##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
    ##    .waterfowl__css    0.000                               0.000    0.000
    ##    .cases_c_farms     0.000                               0.000    0.000
    ##    .human_cases       0.000                               0.000    0.000
    ##    .Brd_Nstng_xpsr    0.991    0.022   45.211    0.000    0.992    0.992
    ##    .Commercil_xpsr    0.972    0.022   45.211    0.000    0.991    0.991
    ##    .Human_exposure    0.030    0.001   45.211    0.000    0.032    0.032

## Model validation: assess performance of SEM

We can assess the performance of the model with the performance package
that include several validation metrics, including the comparative fit
index (CFI) and the root mean square error or approximation (RMSEA)

    library(performance)
    model_performance(fit, metrics = c('CFI', 'RMSEA'))

    ## # Indices of model performance
    ## 
    ## CFI   | RMSEA
    ## -------------
    ## 0.968 | 0.087

## Map the results of the SEM

To map results, we need to extract coefficients

    library(stringr)
    library(tidyr)

    ## 
    ## Attaching package: 'tidyr'

    ## The following object is masked from 'package:terra':
    ## 
    ##     extract

    ## The following object is masked from 'package:raster':
    ## 
    ##     extract

    cf <- lavaan::coef(fit)

    dfcf <- as.data.frame(cf) %>%
      filter(!str_detect(rownames(.), '~~')) %>%
      mutate(regression = rownames(.)) %>%
      separate(col =  regression, into= c('exposure', 'param'), sep = '~') 

    list_weights <- list()

    exposures <- distinct(dfcf, exposure)

    for (exp in exposures$exposure){
      sub <- dplyr::filter(dfcf, exposure == exp)
      plist = list()
      for (param in sub$param){
        plist[param] = sub[sub$param == param, 'cf']
      }
      list_weights[[exp]] = plist
    }

    Bird_Nesting_exposure = 
      r.scaled$curr_bird_dist * list_weights$Bird_Nesting_exposure$curr_bird_dist + 
      r.scaled$dist_wetlands * list_weights$Bird_Nesting_exposure$dist_wetlands

    Commercial_exposure = 
      Bird_Nesting_exposure * list_weights$Commercial_exposure$Bird_Nesting_exposure +
      r.scaled['chicken_density'] * list_weights$Commercial_exposure$chicken_density +
      r.scaled['duck_density'] * list_weights$Commercial_exposure$duck_density

    Human_exposure = 
      Commercial_exposure * list_weights$Human_exposure$Commercial_exposure + 
      r.scaled$urban_fraction * list_weights$Human_exposure$urban_fraction + 
      r.scaled$poverty * list_weights$Human_exposure$poverty + 
      r.scaled$pop_density * list_weights$Human_exposure$pop_density

## Bird nesting exposure

    ## Linking to GEOS 3.11.2, GDAL 3.6.2, PROJ 9.2.0; sf_use_s2() is TRUE

    ## Warning: Expected 2 pieces. Missing pieces filled with `NA` in 1 rows [20].

    ## Joining with `by = join_by(address)`

    ## Warning in plot.sf(wb2, add = TRUE, col = "red", cex = 0.75, pch = 16):
    ## ignoring all but the first attribute

![](md_day2_files/figure-markdown_strict/unnamed-chunk-23-1.png)

## Commercial farm exposure

    ## Warning: There was 1 warning in `mutate()`.
    ## ℹ In argument: `Lattitude = as.numeric(Lattitude)`.
    ## Caused by warning:
    ## ! NAs introduced by coercion

![](md_day2_files/figure-markdown_strict/unnamed-chunk-24-1.png)

## Human exposure

![](md_day2_files/figure-markdown_strict/unnamed-chunk-25-1.png)

## Exercise

#### Change the structure of the SEM

    mod <- '
      ### measurement model

      # Environmental exposures
      Bird_Nesting_exposure =~ waterfowl_ai_cases 

      # Animal exposures
      Commercial_exposure =~ cases_c_farms 
      Human_exposure =~ human_cases 
      
      ### regressions
      # Environmental exposures
      Bird_Nesting_exposure ~ curr_bird_dist + dist_wetlands

      # Animal exposures
      Commercial_exposure ~ Bird_Nesting_exposure + chicken_density  + duck_density
      Human_exposure ~ Commercial_exposure + urban_fraction + poverty + pop_density
    '

## Exercise

#### Fit the new model with `sem()`

#### Assess the new coefficients with `summary()`

#### Evaluate the performance of the new model with `model_performance()`

## Climate change scenarios

#### How do we assess the impact of climate change on the suitability of zoonoses?

1.  What is “climate change”, what is the variable of interest? What
    Shared Socioeconomic pathway (SSP)? What Representative
    Concentration Pathway (RCP)?

2.  “When” is “climate change”? What is the timeframe of climate change
    in the model?

## Where to get information on climate change?

-   IPCC, Regional Climate Models

-   Climate projections processed from
    [WorldClim](https://www.worldclim.org/) (`raster::getData()`)

## How to include this information in the model?

Climate information is included in the SDM as climate variables.

Use projected instead of current bioclimatic variable to predict the
occurrence of the Indian pied myna (*Gracupica contra*)

## How to include this information in the model?

1.  We need to read rasters of projected bioclimatic variables

2.  Re-run the maxent model with the new bioclimatic variables to
    generate species occurrence map under climate change

3.  Add the new species distribution map into the SEM model

## Read rasters of projected bioclimatic variables

    cc <- rast("./data_day2/cc_sdm_inputs.tif")

    plot(cc)

![](md_day2_files/figure-markdown_strict/unnamed-chunk-27-1.png)

## Create new predictor raster for maxent

    predictors <- rast("./data_day2/sdm_inputs.tif")

    s1 <- stack(predictors[[c( "dist_wetlands","cropland_fraction", "forest_fraction", "urban_fraction")]])
    s2 <- stack(ifel(is.na(cc), 0, cc))
     
    cc_predictors <- stack(s1, s2)

## Re-run the prediction of occurrence

Predicted occurrence of the Indian pied myna

    me <- maxent(stack(predictors[[c("dist_wetlands", "urban_fraction", "Annual_Precipitation", "Mean_Temp_Warmest_qrt")]]), occtrain_df)

    predicted <- rast(predict(me, stack(predictors))) 
    predicted_cc <- rast(predict(me, cc_predictors)) 

    names(predicted) <- "Current"
    names(predicted_cc) <- "Projected"

    plot(c(predicted, predicted_cc))

![](md_day2_files/figure-markdown_strict/unnamed-chunk-29-1.png)

## Plot the change in occurrence

We can also plot the relative change in occurrence

    plot((predicted_cc - predicted)/predicted)

![](md_day2_files/figure-markdown_strict/unnamed-chunk-30-1.png)

## Feed the projected species distribution in the SEM

    sem_inputs <- rast("./data_day2/sem_inputs.tif")

    sem_inputs_cc <- c(sem_inputs, predicted_cc)
    sem_inputs_cc <- scale(sem_inputs_cc)

## Reassess exposures

    Bird_Nesting_exposure_cc = 
      sem_inputs_cc$Projected * list_weights$Bird_Nesting_exposure$curr_bird_dist +
      sem_inputs_cc$dist_wetlands * list_weights$Bird_Nesting_exposure$dist_wetlands

    Commercial_exposure_cc = 
      Bird_Nesting_exposure * list_weights$Commercial_exposure$Bird_Nesting_exposure +
      sem_inputs_cc['chicken_density'] * list_weights$Commercial_exposure$chicken_density +
      sem_inputs_cc['duck_density'] * list_weights$Commercial_exposure$duck_density

    Human_exposure_cc = 
      Commercial_exposure * list_weights$Human_exposure$Commercial_exposure + 
      sem_inputs_cc$urban_fraction * list_weights$Human_exposure$urban_fraction + 
      sem_inputs_cc$poverty * list_weights$Human_exposure$poverty + 
      sem_inputs_cc$pop_density * list_weights$Human_exposure$pop_density

## Map new suitability of bird exposure

    names(Bird_Nesting_exposure) <- "Current bird exposure"
    names(Bird_Nesting_exposure_cc) <- "Projected bird exposure"

    plot(c(Bird_Nesting_exposure, Bird_Nesting_exposure_cc))

![](md_day2_files/figure-markdown_strict/unnamed-chunk-33-1.png)

## Map new suitability of bird exposure

    names(Commercial_exposure) <- "Current poultry exposure"
    names(Commercial_exposure_cc) <- "Projected poultry exposure"

    plot(c(Commercial_exposure, Commercial_exposure_cc))

![](md_day2_files/figure-markdown_strict/unnamed-chunk-34-1.png)

## Map new suitability of human exposure

    names(Human_exposure) <- "Current human exposure"
    names(Human_exposure_cc) <- "Projected human exposure"
    plot(c(Human_exposure, Human_exposure_cc))

![](md_day2_files/figure-markdown_strict/unnamed-chunk-35-1.png)

## Small impact of wild birds on commercial farms

    lp

![](md_day2_files/figure-markdown_strict/unnamed-chunk-36-1.png)

## Exercise

#### Map current and projected suitability given the distribution of other species, e.g.:

-   House crow (*Corvus splendens*)
-   House sparrow (*Passer domesticus*)
-   Northern pintail (*Anas acuta*)
-   Tufted duck (*Aythya fuligula*)

## Further model assessment: uncertainty and sensitivity analysis

#### Sources of uncertainty:

-   Parameter uncertainty: are the inputs we are using to inform the
    model reliable? If not how can we improve them?
-   Model or structural uncertainty
-   Amplification of uncertainty: Uncertainty of climate model -&gt;
    Uncertainty of SDM -&gt; Uncertainty of SEM

## Further model assessment: uncertainty and sensitivity analysis

#### How do we assess uncertainty?

Run model with different climate change scenarios (climate models,
SSPs), run SDMs and SEMs with with data from different source if
possible.

Results can be presented as an envelop of outputs.

## Further model assessment: uncertainty and sensitivity analysis

To what extent results are varying when we change a given input. Not
only it informs us on the variability of results but it also help
identify drivers of exposure to support decisions.

-   One-factor-at-a-time (local)
-   [Sensobol](https://cran.r-project.org/web/packages/sensobol/index.html):
    Global variance-based sensitivity analysis with Sobol sampling
    (global)
-   Morris method (Global) [Morris
    method](https://www.rdocumentation.org/packages/sensitivity/versions/1.28.1/topics/morris)
    from the
    [sensitivity](https://www.rdocumentation.org/packages/sensitivity/versions/1.28.1)
    package
