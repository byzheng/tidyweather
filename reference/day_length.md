# The time elapsed in hours between the specified sun angle from 90 degree in am and pm. +ve above the horizon, -ve below the horizon.

The time elapsed in hours between the specified sun angle from 90 degree
in am and pm. +ve above the horizon, -ve below the horizon.

## Usage

``` r
day_length(doy, latitude = NULL, angle = -6)
```

## Arguments

- doy:

  day of year number

- latitude:

  latitude of site (deg)

- angle:

  angle to measure time between, such as twilight (deg). angular
  distance between 90 deg and end of twilight - altitude of sun. +ve up,
  -ve down.

## Value

day length in hours
