# Read weather records from a file list and/or a folder list

Read weather records from a file list and/or a folder list

## Usage

``` r
read_weather(file, format = "APSIM", ...)
```

## Arguments

- file:

  A character string to specify weather filename.

- format:

  A character string to specify the format of weather file.

- ...:

  Other arguments

## Value

A data.frame which contains all weather data.

## Examples

``` r
file <- system.file("extdata/ppd_72150.met", package = "tidyweather")
records <- read_weather(file)
head(records)
#> # A tibble: 6 × 17
#>    year   day  radn  maxt  mint  rain  evap    vp   code date        avgt name  
#>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>  <int> <date>     <dbl> <chr> 
#> 1  2023   335  26.1  28.7  14.4     0   4.7  16.4 400020 2023-12-01  21.6 WAGGA…
#> 2  2023   336  23    29.1  15.1     0   5.3  17.4 400020 2023-12-02  22.1 WAGGA…
#> 3  2023   337  30.7  27.8  10       1   5.5  14.7 400020 2023-12-03  18.9 WAGGA…
#> 4  2023   338  31.5  30.4  14.6     0   6.7  14.8 400020 2023-12-04  22.5 WAGGA…
#> 5  2023   339  28.5  37.9  15.1     0   7.1  15.2 400020 2023-12-05  26.5 WAGGA…
#> 6  2023   340  25.1  33.3  18.5     0   8    14.5 400020 2023-12-06  25.9 WAGGA…
#> # ℹ 5 more variables: number <chr>, latitude <dbl>, longitude <dbl>, tav <dbl>,
#> #   amp <dbl>
```
