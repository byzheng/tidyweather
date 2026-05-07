# Calculate the sphere distance between two points on the Earth

Calculate the sphere distance between two points on the Earth

## Usage

``` r
spherical_distance(lat1, lon1, lat2, lon2)
```

## Arguments

- lat1:

  Latitude of the first point in degrees

- lon1:

  Longitude of the first point in degrees

- lat2:

  Latitude of the second point in degrees

- lon2:

  Longitude of the second point in degrees

## Value

Distance in km

## Examples

``` r
spherical_distance(34.05, -118.25, 40.7128, -74.0060) # Distance between Los Angeles and New York
#> [1] 3936.376
```
