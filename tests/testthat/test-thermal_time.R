test_that("Thermal time", {
    old <- options(digits = 20)
    # The daily thermal time
    mint <- c(0, 10)
    maxt <- c(30, 40)
    x_temp <- c(0, 20, 35)
    y_temp <- c(0, 20, 0)
    res <- thermal_time(mint, maxt, x_temp, y_temp)
    expect_equal(res, c(15, 13.3333333333), tolerance=1e-3)
    res <- thermal_time(mint, maxt, x_temp, y_temp, method = '3hr')
    expect_equal(res, c(9.279687499999, 8.7905625000000), tolerance=1e-3)
    
    #expect_equal(res$value[1], 16.391951095089993, tolerance=1e-3)
    # Read weather records
    met_file <- system.file("extdata/ppd_72150.met", package = "tidyweather")
    records <- read_weather(met_file)
    x_temp <- c(0, 26, 34)
    y_temp <- c(0, 26, 0)
    res <- thermal_time(records$mint, records$maxt, x_temp, y_temp)
    expect_equal(round(res[1], 1), 21.6, tolerance=1e-3)
    res <- thermal_time(records$mint, records$maxt, x_temp, y_temp, method = "3hr")
    expect_equal(round(res[1], 1), 19.6, tolerance=1e-3)
    
    options(old)
})
