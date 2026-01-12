# Set or get options for tidyweather

This function allows users to get or set configuration options for the
tidyweather package.

## Usage

``` r
weather_options(...)
```

## Arguments

- ...:

  Option names to retrieve or key-value pairs to set.

## Value

If called with no arguments, returns all current options. If called with
named arguments, updates and returns the modified options.

## Details

The options are managed via a nested structure that distinguishes
between the tidyweather package.

## Supported options

- `extreme.frost_threshold`:

  Frost threshold for extreme weather events.

- `require_full_year`:

  Whether to require a full year of data for calculations.

## Examples

``` r
# Get all options
weather_options()
#> $extreme
#> $extreme$frost_threshold
#> [1] 0
#> 
#> 
#> $require_full_year
#> [1] FALSE
#> 

# Set frost_threshold
weather_options(extreme.frost_threshold = 2)
```
