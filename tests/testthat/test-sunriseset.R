test_that("sun_rise_set returns POSIXct in the requested time zone", {
    date <- as.Date("2021-06-21")
    sunrise <- sun_rise_set(date, latitude = -27.5, longitude = 153, timezone = "Australia/Brisbane", angle = 0)
    sunset <- sun_rise_set(
        date, latitude = -27.5, longitude = 153, timezone = "Australia/Brisbane",
        angle = 0, flag = "set")

    expect_s3_class(sunrise, "POSIXct")
    expect_equal(attr(sunrise, "tzone"), "Australia/Brisbane")
    expect_equal(format(sunrise, "%Y-%m-%d %H:%M"), "2021-06-21 06:41")
    expect_equal(format(sunset, "%Y-%m-%d %H:%M"), "2021-06-21 16:57")
})

test_that("sun_rise_set uses UTC by default and the calendar day of the time zone", {
    date <- as.Date("2021-06-21")
    utc <- sun_rise_set(date, latitude = -27.5, longitude = 153, angle = 0)

    expect_equal(attr(utc, "tzone"), "UTC")
    expect_equal(format(utc, "%Y-%m-%d %H:%M"), "2021-06-21 20:41")
    expect_equal(as.Date(format(utc, tz = "UTC")), date)
})

test_that("sun_rise_set supports vectorized dates", {
    dates <- as.Date(c("2021-06-21", "2021-06-22"))
    result <- sun_rise_set(dates, latitude = -27.5, longitude = 153, timezone = "Australia/Brisbane", angle = 0)

    expect_equal(length(result), 2)
    expect_equal(as.Date(format(result, tz = "Australia/Brisbane")), dates)
})

test_that("sun_rise_set requires Date input", {
    chr <- c("2021-06-21", "2021-06-22")
    expect_error(sun_rise_set(chr, latitude = -27.5, longitude = 153))
    expect_error(sun_rise_set(172, latitude = -27.5, longitude = 153))
    expect_error(sun_rise_set(as.POSIXct("2021-06-21", tz = "UTC"), latitude = -27.5, longitude = 153))
})

test_that("sun_rise_set validates inputs", {
    date <- as.Date("2021-06-21")
    expect_error(sun_rise_set(as.Date(c("2021-06-21", NA)), latitude = -27.5, longitude = 153))
    expect_error(sun_rise_set(as.Date(character()), latitude = -27.5, longitude = 153))
    expect_error(sun_rise_set(date, latitude = c(-27.5, -28), longitude = 153))
    expect_error(sun_rise_set(date, latitude = "a", longitude = 153))
    expect_error(sun_rise_set(date, latitude = 91, longitude = 153))
    expect_error(sun_rise_set(date, latitude = -90.1, longitude = 153))
    expect_error(sun_rise_set(date, latitude = NA_real_, longitude = 153))
    expect_error(sun_rise_set(date, latitude = -27.5, longitude = 181))
    expect_error(sun_rise_set(date, latitude = -27.5, longitude = -180.5))
    expect_error(sun_rise_set(date, latitude = -27.5, longitude = c(150, 153)))
    expect_error(sun_rise_set(date, latitude = -27.5, longitude = Inf))
    expect_error(sun_rise_set(date, latitude = -27.5, longitude = 153, timezone = 10))
    expect_error(sun_rise_set(date, latitude = -27.5, longitude = 153, angle = "6"))
})

test_that("sun_rise_set errors when the sun does not rise", {
    expect_error(
        sun_rise_set(as.Date("2021-06-21"), latitude = -80, longitude = 0, angle = 0, flag = "rise"),
        "the sun never rises"
    )
    expect_error(sun_rise_set(as.Date("2021-06-21"), latitude = 0, longitude = 0, flag = "noon"))
})

