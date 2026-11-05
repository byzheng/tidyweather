# Sunrise and sunset times

Calculate the time of sunrise or sunset (or of the sun reaching a given
angle below the horizon, such as twilight) for a vector of dates at a
site, using the low-precision algorithm from the Almanac for Computers
(accurate to about a minute or two).

## Usage

``` r
sun_rise_set(
  date,
  latitude,
  longitude,
  timezone = "UTC",
  angle = 6,
  flag = c("rise", "set")
)
```

## Arguments

- date:

  dates of class `Date`.

- latitude:

  latitude of site (deg), positive north, in `[-90, 90]`.

- longitude:

  longitude of site (deg), positive east, in `[-180, 180]`.

- timezone:

  Olson time zone name of the returned times, such as `"UTC"` (default)
  or `"Australia/Brisbane"`. See
  [`OlsonNames()`](https://rdrr.io/r/base/timezones.html).

- angle:

  angle of the sun below the horizon (deg) at which the time is
  calculated. Use `0` for the geometric horizon, `0.833` for the
  conventional sunrise and sunset (refraction and solar disc), and `6`,
  `12` or `18` for civil, nautical and astronomical twilight. Positive
  values are below the horizon. Default is `6`.

- flag:

  `"rise"` for the morning event or `"set"` for the evening event.

## Value

A `POSIXct` vector in `timezone`, on the local calendar day of `date`.
An error is raised if the sun does not reach `angle` on a date (for
example polar day or night).

## Examples

``` r
date <- as.Date("2021-06-21")
sun_rise_set(date, latitude = -27.5, longitude = 153, angle = 0)
#> [1] "2021-06-21 20:41:42 UTC"
sun_rise_set(date, latitude = -27.5, longitude = 153, timezone = "Australia/Brisbane",
             angle = 0, flag = "rise")
#> [1] "2021-06-21 06:41:42 AEST"
sun_rise_set(date, latitude = -27.5, longitude = 153, timezone = "Australia/Brisbane",
             angle = 0, flag = "set")
#> [1] "2021-06-21 16:57:27 AEST"
```
