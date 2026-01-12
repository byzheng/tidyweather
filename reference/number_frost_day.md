# Calculate the number of frost days

This function calculates the number of frost days from a numeric vector
of daily minimum temperatures using tidyverse principles.

## Usage

``` r
number_frost_day(
  .data,
  threshold = get_weather_option("extreme.frost_threshold"),
  require_full_year = get_weather_option("require_full_year")
)
```

## Arguments

- .data:

  A data frame or tibble containing daily minimum temperatures in a
  column named "mint".

- threshold:

  The stress temperature threshold for frost (default: 0)

- require_full_year:

  Logical. If TRUE, requires exactly 365 or 366 days (default: TRUE)

## Value

An data.frame or tibble representing the number of frost days, or 0 if
no frost occurs

## Examples

``` r
file <- system.file("extdata/ppd_72150.met", package = "tidyweather")
records <- read_weather(file)
records |>
    dplyr::group_by(year) |> 
    number_frost_day(require_full_year = FALSE)
#> # A tibble: 3 × 2
#> # Groups:   year [3]
#>    year number_frost_days
#>   <dbl>             <int>
#> 1  2023                 0
#> 2  2024                29
#> 3  2025                 9
```
