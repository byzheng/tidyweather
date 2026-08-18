# Interpolate Hourly Temperature Values using APSIM HourlySinPpAdjusted.

Interpolates hourly temperatures from daily minimum and maximum
temperatures using the APSIM HourlySinPpAdjusted method. Daytime
temperatures are sinusoidal and nighttime temperatures follow an
exponential cooling curve.

## Usage

``` r
interpolate_hourly_sin_pp_adjusted(
  mint,
  maxt,
  daylength = 12,
  sunrise = NULL,
  sunset = NULL
)
```

## Arguments

- mint:

  A numeric vector of daily minimum temperatures.

- maxt:

  A numeric vector of daily maximum temperatures.

- daylength:

  Day length in hours. Either a scalar or a numeric vector with the same
  length as `mint`. Defaults to 12.

- sunrise:

  Sunrise hour. Either a scalar or a numeric vector with the same length
  as `mint`. Defaults to `12 - daylength / 2`.

- sunset:

  Sunset hour. Either a scalar or a numeric vector with the same length
  as `mint`. Defaults to `sunrise + daylength`.

## Value

A numeric vector of daily mean temperatures, with one value per input
day.

## Examples

``` r
mint <- c(10, 11, 12)
maxt <- c(30, 31, 32)
interpolate_hourly_sin_pp_adjusted(mint, maxt)
#> [1] 19.01875 20.00625 20.82052
```
