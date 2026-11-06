# Estimate Dew Point Temperature from Air Temperature and Relative Humidity

Computes the dew point temperature (°C) using the **Magnus–Tetens
approximation**, a widely used empirical relationship between air
temperature, relative humidity, and the saturation vapor pressure of
water vapor. The method provides a good approximation for typical
atmospheric conditions and is suitable for most meteorological and
agricultural applications. It works for any air temperature (for example
minimum, maximum or mean) with the matching relative humidity. The
inverse is
[`relative_humidity()`](https://tidyweather.bangyou.me/reference/relative_humidity.md).

## Usage

``` r
dew_point(temperature, rh)
```

## Arguments

- temperature:

  Numeric. Air temperature (°C).

- rh:

  Numeric. Relative humidity (%) corresponding to `temperature`.

## Value

Numeric. Dew point temperature (°C).

## Details

The dew point temperature is estimated using the Magnus–Tetens equation:

\$\$ \gamma = \frac{a \cdot T}{b + T} + \ln\left(\frac{RH}{100}\right)
\$\$ \$\$ T\_{dew} = \frac{b \cdot \gamma}{a - \gamma} \$\$

where \\T\\ is air temperature (°C), \\RH\\ is relative humidity (%),
and the empirical constants are \\a = 17.62\\ and \\b = 243.12\\ (for
water over a liquid surface). This formulation is based on improvements
to the original Magnus equation proposed by **Alduchov and Eskridge
(1996)**.

For air temperatures below 0 °C, slightly different coefficients are
sometimes used to account for ice surfaces, but the above constants are
generally suitable for most temperature ranges encountered in
agricultural or meteorological data.

## References

Alduchov, O. A., & Eskridge, R. E. (1996). *Improved Magnus Form
Approximation of Saturation Vapor Pressure*. Journal of Applied
Meteorology, 35(4), 601–609.
[doi:10.1175/1520-0450(1996)035\<0601:IMFAOS\>2.0.CO;2](https://doi.org/10.1175/1520-0450%281996%29035%3C0601%3AIMFAOS%3E2.0.CO%3B2)

## Examples

``` r
# Dew point for 10 °C and 80% RH
dew_point(10, 80)
#> [1] 6.706013

# Vectorized input
dew_point(c(5, 10, 15), c(90, 70, 50))
#> [1] 3.495014 4.775543 4.651626
```
