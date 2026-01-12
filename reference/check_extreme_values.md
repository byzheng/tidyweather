# Check for extreme values in weather columns

Check for extreme values in weather columns

## Usage

``` r
check_extreme_values(data, key_cols, temp_range, radn_range, rain_range)
```

## Arguments

- data:

  A data frame

- key_cols:

  Character vector of column names to check

- temp_range:

  Acceptable range for temperature

- radn_range:

  Acceptable range for radiation

- rain_range:

  Acceptable range for rainfall

## Value

A data frame of rows with extreme values, or NULL if none found
