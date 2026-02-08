# Calculate thermal time using cardinal temperatures

Calculate thermal time using cardinal temperatures

## Usage

``` r
thermal_time(mint, maxt, x_temp, y_temp, method = NULL)
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
  method = '3hr'

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
```
