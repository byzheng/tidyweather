# Calculate the sphere distance between two points on the Earth

Calculate the sphere distance between two points on the Earth

## Usage

``` r
spherical_distance(lat1, lon1, lat2, lon2)
```

## Arguments

- lat1:

  Latitude of the first point in degrees. Numeric scalar (-90 to 90)

- lon1:

  Longitude of the first point in degrees. Numeric scalar (-180 to 180)

- lat2:

  Latitudes of the second point in degrees. Numeric vector (-90 to 90)

- lon2:

  Longitudes of the second point in degrees. Numeric vector (-180 to
  180)

## Value

Distance in km

## Examples

``` r
spherical_distance(34.05, -118.25, 40.7128, -74.0060) # Distance between Los Angeles and New York
#> [1] 3936.376
```
