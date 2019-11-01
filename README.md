# baseApp

<!-- badges: start -->
[![pipeline status](https://gitlab.com/kapsner/baseApp/badges/master/pipeline.svg)](https://gitlab.com/kapsner/baseApp/commits/master)
[![coverage report](https://gitlab.com/kapsner/baseApp/badges/master/coverage.svg)](https://gitlab.com/kapsner/baseApp/commits/master)
<!-- badges: end -->

This repository includes an example of a basic shiny app wrapped into an R package.

## Docker 

To build a deployable docker container run:

```
cd ./docker/
chmod +x build_image.sh
./build_image.sh
```

## Installation

You can install the development version of baseApp with:

``` r
install.packages("devtools")
devtools::install_github("kapsner/baseApp")
```

## Example

This is a basic example which shows you how to launch the baseApp:

``` r
library(baseApp)
launch_app()
```

To open the shiny application in your webbrowser, go to http://localhost:3838


# More Infos:
- about Shiny: https://www.rstudio.com/products/shiny/  
- RStudio and Shiny are trademarks of RStudio, Inc.  
