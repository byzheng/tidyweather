# Estimate Relative Humidity from Air Temperature and Dew Point Temperature

Computes relative humidity (%) from air temperature and dew point
temperature using the **Magnus-Tetens approximation**. This is the
inverse of
[`dew_point()`](https://tidyweather.bangyou.me/reference/dew_point.md).

## Usage

``` r
relative_humidity(temperature, dewpoint, na.action = c("na.pass", "na.fail"))
```

## Arguments

- temperature:

  Numeric. Air temperature (°C). Must have the same length as
  `dewpoint`; inputs are not recycled.

- dewpoint:

  Numeric. Dew point temperature (°C). Should not exceed `temperature`.

- na.action:

  Either `"na.pass"` (the default), which propagates missing values
  without removing them, or `"na.fail"`, which errors if either input
  contains `NA` or `NaN`.

## Value

Numeric. Relative humidity (%), between 0 and 100 when
`dewpoint <= temperature`, with the same length as the inputs. If either
input is entirely missing, the result is entirely `NA`.

## Details

Relative humidity is the ratio of the saturation vapour pressure at the
dew point to that at the air temperature:

\$\$ RH = 100 \cdot \exp\left(\frac{a \cdot T\_{dew}}{b + T\_{dew}} -
\frac{a \cdot T}{b + T}\right) \$\$

with \\a = 17.62\\ and \\b = 243.12\\ (Alduchov and Eskridge, 1996).

## References

Alduchov, O. A., & Eskridge, R. E. (1996). *Improved Magnus Form
Approximation of Saturation Vapor Pressure*. Journal of Applied
Meteorology, 35(4), 601–609.
[doi:10.1175/1520-0450(1996)035\<0601:IMFAOS\>2.0.CO;2](https://doi.org/10.1175/1520-0450%281996%29035%3C0601%3AIMFAOS%3E2.0.CO%3B2)

## Examples

``` r
# Relative humidity for 10 °C air temperature and 6.7 °C dew point
relative_humidity(10, 6.7)
#> [1] 79.96699

# Vectorized input
relative_humidity(c(5, 10, 15), c(3.5, 4.8, 4.7))
#> [1] 90.03161 70.11943 50.16902
```
