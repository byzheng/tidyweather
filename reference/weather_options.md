# tidyweather options

An options manager for configuring tidyweather parameters. This object
provides methods to get and set weather-related parameters.

## Usage

``` r
weather_options
```

## Format

An object of class `list` of length 3.

## Available Options

- extreme.frost_threshold:

  Frost threshold for extreme weather events. Default: 0

- require_full_year:

  Whether to require a full year of data for certain calculations.
  Default: TRUE

## Methods

- get(key):

  Retrieve the value of an option by its key (e.g.,
  "extreme.frost_threshold")

- set(key, value):

  Set the value of an option by its key

- reset():

  Reset all options to their default values

## Examples

``` r
# Get default frost threshold
weather_options$get("extreme.frost_threshold")
#> [1] 0

# Set custom values
weather_options$set("extreme.frost_threshold" = -2)

# Reset to defaults
weather_options$reset()
```
