# Calculate thermal time using cardinal temperatures

Calculate thermal time using cardinal temperatures

## Usage

``` r
thermal_time(
  mint,
  maxt,
  x_temp,
  y_temp,
  method = NULL,
  lat = NULL,
  date = NULL
)
```

## Arguments

- mint:

  The minimum temperature

- maxt:

  The maximum temperature

- x_temp:

  The cardinal temperatures

- y_temp:

  The effective thermal time

- method:

  The method to calculate thermal time. The default method is ( maxt +
  mint ) / 2 - base. The three hour temperature methods will be usesd if
  method = '3hr'. The APSIM HourlySinPpAdjusted method can be selected
  with method = 'HourlySinPpAdjusted'.

- lat:

  Latitude of the site (deg), required when method =
  'HourlySinPpAdjusted'. A single numeric value.

- date:

  A `Date` vector with the same length as `mint`, required when method =
  'HourlySinPpAdjusted'.

## Value

The thermal time.

## Examples

``` r
mint <- c(0, 10)
maxt <- c(30, 40)
x_temp <- c(0, 20, 35)
y_temp <- c(0, 20, 0)
thermal_time(mint, maxt, x_temp, y_temp)
#> [1] 15.00000 13.33333
thermal_time(mint, maxt, x_temp, y_temp, method = '3hr')
#> [1] 9.279687 8.790563
date <- as.Date(c("2020-01-01", "2020-01-02"))
thermal_time(mint, maxt, x_temp, y_temp, method = 'HourlySinPpAdjusted',
             lat = -27.5, date = date)
#> [1] 16.66864 13.45011
```
