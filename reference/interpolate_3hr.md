# Interpolate 3-Hourly Temperature Values using sine curve.

Interpolates temperature values at 3-hourly intervals from daily minimum
and maximum temperatures using a sine curve.

## Usage

``` r
interpolate_3hr(mint, maxt)
```

## Arguments

- mint:

  A numeric vector of daily minimum temperatures.

- maxt:

  A numeric vector of daily maximum temperatures.

## Value

A numeric matrix of interpolated 3-hourly temperature values. Rows
correspond to input minimum and maximum temperatures and columns
correspond to the eight interpolated 3-hourly intervals.

## Examples

``` r
mint <- c(0, 10)
maxt <- c(30, 40)
interpolate_3hr(mint = mint, maxt = maxt)
#>         [,1]    [,2]    [,3]    [,4]    [,5]    [,6]    [,7]    [,8]
#> [1,] 29.1015 27.3075 23.2035 17.7435 11.8815  6.5715  2.7675  1.4235
#> [2,] 39.1015 37.3075 33.2035 27.7435 21.8815 16.5715 12.7675 11.4235
```
