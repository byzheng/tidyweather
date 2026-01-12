# Get weather package option

Retrieves the value of a specified option from the weather package
configuration. This function provides access to package-level settings
and preferences.

## Usage

``` r
get_weather_option(name)
```

## Arguments

- name:

  A character string specifying the name of the option to retrieve.

## Value

The value of the specified option, or NULL if the option does not exist.

## Examples

``` r
# Get the default frost threshold
get_weather_option("extreme.frost_threshold")
#> [1] 0
```
