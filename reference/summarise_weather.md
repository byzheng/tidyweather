# Summarise Weather Extremes and Key Indicators

This function calculates summary metrics for weather data, including the
number of frost days and the last frost day, grouped by one or more
grouping variables. The function uses package-wide options for
thresholds and year completeness.

## Usage

``` r
summarise_weather(.data)
```

## Arguments

- .data:

  A tibble or data frame containing daily weather data. Must include at
  least a `mint` column for daily minimum temperatures. A `day` column
  is recommended if `require_full_year = TRUE`.

## Value

A tibble with one row per group, containing the following columns:

- number_frost_days:

  Number of days where minimum temperature is below the frost threshold.

- last_frost_day:

  The day of year of the last frost (or `NA` if none).

## Details

The function retrieves thresholds and settings from the global
tidyweather options via `weather_options$get()`. The default frost
threshold is `weather_options$get("extreme.frost_threshold")` and
`require_full_year` is `weather_options$get("require_full_year")`. These
can be changed using `weather_options$set()`.

This function is designed to work with grouped tibbles (e.g., after
[`dplyr::group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)),
applying the summary per group.

## Examples

``` r
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union

# Example weather data (daily minimum temperatures)
weather_data <- read_weather(system.file("extdata/ppd_72150.met", package = "tidyweather"))

# Summarise without grouping
weather_options$set("require_full_year" = FALSE)
summarise_weather(weather_data)
#> # A tibble: 1 × 2
#>   number_frost_days last_frost_day
#>               <int>          <dbl>
#> 1                38            580

# Summarise by group (e.g., year)
weather_data_grouped <- weather_data %>% group_by(year)
summarise_weather(weather_data_grouped)
#> # A tibble: 3 × 3
#> # Groups:   year [3]
#>    year number_frost_days last_frost_day
#>   <dbl>             <int>          <dbl>
#> 1  2023                 0             NA
#> 2  2024                29            262
#> 3  2025                 9            183
```
