test_that("dew_point equals air temperature at saturation", {
    expect_equal(dew_point(20, 100), 20)
    expect_equal(dew_point(c(-5, 0, 30), c(100, 100, 100)), c(-5, 0, 30))
})

test_that("dew_point matches known Magnus-Tetens values", {
    expect_equal(dew_point(10, 80), 6.706013, tolerance = 1e-6)
    expect_equal(dew_point(0, 50), -9.20202, tolerance = 1e-5)
})

test_that("dew_point satisfies the Magnus equation", {
    a <- 17.62
    b <- 243.12
    temperature <- c(5, 10, 15, 25)
    rh <- c(90, 70, 50, 35)
    t_dew <- dew_point(temperature, rh)
    # Relative humidity is the ratio of saturation vapour pressure at dew point and air temperature
    rh_check <- 100 * exp(a * t_dew / (b + t_dew)) / exp(a * temperature / (b + temperature))

    expect_equal(rh_check, rh, tolerance = 1e-8)
})

test_that("dew_point is vectorized and below air temperature when unsaturated", {
    temperature <- c(5, 10, 15)
    rh <- c(90, 70, 50)
    result <- dew_point(temperature, rh)

    expect_equal(length(result), 3)
    expect_equal(result, c(3.495014, 4.775543, 4.651626), tolerance = 1e-6)
    expect_true(all(result < temperature))
})

test_that("dew_point increases with relative humidity", {
    result <- dew_point(rep(15, 5), c(20, 40, 60, 80, 100))

    expect_true(all(diff(result) > 0))
})

test_that("dew_point propagates NA values", {
    result <- dew_point(c(10, NA, 15), c(80, 70, NA))

    expect_equal(result[1], dew_point(10, 80))
    expect_true(all(is.na(result[2:3])))
})

test_that("dew_point warns for relative humidity outside (0, 100]", {
    expect_warning(dew_point(10, 0), "between 0 and 100")
    expect_warning(dew_point(10, 120), "between 0 and 100")
    expect_no_warning(dew_point(10, 100))
})

test_that("dew_point requires numeric input", {
    expect_error(dew_point("10", 80))
    expect_error(dew_point(10, "80"))
})

test_that("relative_humidity is 100% when dew point equals air temperature", {
    expect_equal(relative_humidity(c(-5, 0, 20, 30), c(-5, 0, 20, 30)), rep(100, 4))
})

test_that("relative_humidity matches known values", {
    expect_equal(relative_humidity(10, 6.706013094), 80, tolerance = 1e-6)
    expect_equal(relative_humidity(0, -9.202019777), 50, tolerance = 1e-6)
})

test_that("relative_humidity is the inverse of dew_point", {
    temperature <- c(-5, 0, 5, 10, 15, 25, 35)
    rh <- c(95, 80, 60, 45, 30, 70, 20)

    expect_equal(relative_humidity(temperature, dew_point(temperature, rh)), rh, tolerance = 1e-8)
    expect_equal(dew_point(temperature, relative_humidity(temperature, temperature - 3)),
                 temperature - 3, tolerance = 1e-8)
})

test_that("relative_humidity is vectorized, bounded and decreases with dew point depression", {
    result <- relative_humidity(rep(20, 6), c(20, 15, 10, 5, 0, -10))

    expect_equal(length(result), 6)
    expect_true(all(result > 0 & result <= 100))
    expect_true(all(diff(result) < 0))
})

test_that("relative_humidity propagates NA values", {
    result <- relative_humidity(c(10, NA, 15), c(5, 5, NA))

    expect_false(is.na(result[1]))
    expect_true(all(is.na(result[2:3])))
})

test_that("relative_humidity warns when dew point exceeds air temperature", {
    expect_warning(relative_humidity(10, 12), "should not exceed")
    expect_no_warning(relative_humidity(10, 10))
})

test_that("relative_humidity requires numeric input", {
    expect_error(relative_humidity("10", 5))
    expect_error(relative_humidity(10, "5"))
})

test_that("humidity functions require inputs of equal length", {
    for (fun in list(dew_point, relative_humidity)) {
        expect_error(fun(10, c(5, 6)), "same length")
        expect_error(fun(c(10, 11), 5), "same length")
        expect_error(fun(numeric(0), 5), "same length")
        expect_error(fun(c(10, NA), 5, na.action = "na.fail"), "same length")
        expect_equal(fun(numeric(0), numeric(0)), numeric(0))
    }
})

test_that("humidity functions handle missing inputs according to na.action", {
    for (fun in list(dew_point, relative_humidity)) {
        expected <- fun(10, 5)
        expect_equal(fun(c(10, NA, 10), c(5, 5, NA)), c(expected, NA_real_, NA_real_))
        expect_equal(fun(c(10, NA), c(5, 5), na.action = "na.pass"), c(expected, NA_real_))
        expect_equal(fun(c(NA, NA), c(5, 5)), rep(NA_real_, 2))
        expect_equal(fun(c(10, 10), c(NA, NA)), rep(NA_real_, 2))
        expect_equal(fun(c(NA, NA), c(NA, NA)), rep(NA_real_, 2))
        expect_identical(fun(c(NaN, NaN), c(5, 5)), rep(NA_real_, 2))
        expect_equal(fun(10, 5, na.action = "na.fail"), expected)
        expect_error(fun(c(10, NA), c(5, 5), na.action = "na.fail"), "missing")
        expect_error(fun(c(10, 10), c(5, NA), na.action = "na.fail"), "missing")
        expect_error(fun(10, NaN, na.action = "na.fail"), "missing")
        expect_error(fun(10, 5, na.action = "invalid"), "arg")
        expect_error(fun(TRUE, 5), "numeric")
        expect_error(fun(10, NA_character_), "numeric")
    }
})

test_that("missing values do not hide existing validation warnings", {
    expect_warning(dew_point(c(NA, 10), c(80, 120)), "between 0 and 100")
    expect_warning(relative_humidity(c(NA, 10), c(5, 12)), "should not exceed")
})
