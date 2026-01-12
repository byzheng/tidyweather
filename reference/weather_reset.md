# Reset all tidyweather options to defaults

This restores all package settings to their initial defaults as defined
when tidyweather was loaded. Use this if you want to undo all
customizations.

## Usage

``` r
weather_reset()
```

## Value

Invisibly returns the default settings after reset.

## Examples

``` r
weather_options(extreme.frost_threshold = -2)
weather_reset()
weather_options()
#> $extreme
#> $extreme$frost_threshold
#> [1] 0
#> 
#> 
#> $require_full_year
#> [1] TRUE
#> 
```
