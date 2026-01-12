# Write weather data to file

Exports weather records to a file in the specified format. Currently
supports APSIM format for agricultural modeling applications.

## Usage

``` r
write_weather(records, file, format = "APSIM", overwrite = FALSE)
```

## Arguments

- records:

  A data frame containing weather data with columns for date,
  temperature, precipitation, and other meteorological variables

- file:

  Character string specifying the output file path

- format:

  Character string specifying the output format. Currently supports
  "APSIM" (default)

- overwrite:

  Logical indicating whether to overwrite existing files. Default is
  FALSE

## Value

Invisibly returns the file path of the written file

## Examples

``` r
# Read sample weather data from package
file <- system.file("extdata/ppd_72150.met", package = "tidyweather")
records <- read_weather(file)

# Write to temporary file
temp_file <- tempfile(fileext = ".met")

# Write to APSIM format
write_weather(records, temp_file, format = "APSIM")

# Overwrite existing file
write_weather(records, temp_file, format = "APSIM", overwrite = TRUE)
```
