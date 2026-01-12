# Calculate the last frost day

This function calculates the last frost day from a numeric vector of
daily minimum temperatures using tidyverse principles.

## Usage

``` r
last_frost_day(
  .data,
  threshold = get_weather_option("extreme.frost_threshold"),
  hemisphere = "south",
  require_full_year = get_weather_option("require_full_year")
)
```

## Arguments

- .data:

  A data frame or tibble containing daily minimum temperatures in a
  column named "mint".

- threshold:

  The stress temperature threshold for frost (default: 0)

- hemisphere:

  Hemisphere indicator: "south" or "north" (default: "south"). If
  latitude information is available in the data, it will be used to
  determine the hemisphere.

- require_full_year:

  Logical. If TRUE, requires exactly 365 or 366 days (default: TRUE)

## Value

An data.frame or tibble representing the day of year for the last frost,
or NA if no frost occurs

## Examples

``` r
file <- system.file("extdata/ppd_72150.met", package = "tidyweather")
records <- read_weather(file)
records |>
    dplyr::group_by(year) |>
    last_frost_day(require_full_year = FALSE)
#> # A tibble: 3 × 2
#> # Groups:   year [3]
#>    year last_frost_day
#>   <dbl>          <dbl>
#> 1  2023             NA
#> 2  2024            262
#> 3  2025            183
```
