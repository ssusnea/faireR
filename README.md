
<!-- README.md is generated from README.Rmd. Please edit that file -->

# faireR

<!-- badges: start -->

[![R-CMD-check](https://github.com/ssusnea/faireR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ssusnea/faireR/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of faireR is to …

## Installation

You can install the development version of faireR from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("ssusnea/faireR")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(dplyr)
library(faireR)
# Compute fairness measures for baseball
csas25 |>
  group_by(stand) |>
  fairness_cube()
#> # A tibble: 1 × 3
#>   independence separation sufficiency
#>          <dbl>      <dbl>       <dbl>
#> 1       0.0104     0.0496      0.0856
```
