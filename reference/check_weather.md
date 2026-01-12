# Check weather records for data quality issues

This function validates weather records for:

- Continuous weather data (no gaps in dates)

- No missing values in key columns (mint, maxt, radn, rain)

- No extreme values (e.g., less than -100 or above 100 for temperature,
  less than 0 for radiation and rain)

## Usage

``` r
check_weather(
  data,
  key_cols = c("mint", "maxt", "radn", "rain"),
  temp_range = c(-100, 100),
  radn_range = c(0, 50),
  rain_range = c(0, 500),
  stop_on_error = FALSE
)
```

## Arguments

- data:

  A data.frame or tibble containing weather records with at minimum a
  date column and key weather variables (mint, maxt, radn, rain).

- key_cols:

  A character vector of column names to check for missing values and
  extreme values. Default is c("mint", "maxt", "radn", "rain").

- temp_range:

  A numeric vector of length 2 specifying the acceptable range for
  temperature values (mint, maxt). Default is c(-100, 100).

- radn_range:

  A numeric vector of length 2 specifying the acceptable range for
  radiation values. Default is c(0, 50).

- rain_range:

  A numeric vector of length 2 specifying the acceptable range for
  rainfall values. Default is c(0, 500).

- stop_on_error:

  Logical. If TRUE, the function will stop with an error when issues are
  found. If FALSE, it will return a list of issues. Default is FALSE.

## Value

If stop_on_error is FALSE, returns a list with the following components:

- is_valid:

  Logical indicating if all checks passed

- date_gaps:

  Data frame of date gaps found, or NULL if none

- missing_values:

  Data frame summarizing missing values, or NULL if none

- extreme_values:

  Data frame of rows with extreme values, or NULL if none

If stop_on_error is TRUE and issues are found, the function stops with
an error message.

## Examples

``` r
file <- system.file("extdata/ppd_72150.met", package = "tidyweather")
records <- read_weather(file)
result <- check_weather(records)
if (result$is_valid) {
  print("Weather data passed all quality checks")
} else {
  print(result)
}
#> [1] "Weather data passed all quality checks"
```
