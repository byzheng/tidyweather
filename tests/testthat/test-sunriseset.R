test_that("sun_rise_set returns expected local sunrise and sunset times", {
    sunrise <- sun_rise_set(172, lat = -27.5, long = 153, timezone = 10, angle = 0, flag = "rise")
    sunset <- sun_rise_set(172, lat = -27.5, long = 153, timezone = 10, angle = 0, flag = "set")

    expect_equal(sunrise, 6.695048, tolerance = 1e-5)
    expect_equal(sunset, 16.95761, tolerance = 1e-5)
})

test_that("sun_rise_set supports vectorized days of year", {
    result <- sun_rise_set(c(172, 173), lat = -27.5, long = 153, timezone = 10, angle = 0)

    expect_equal(result, c(6.695048, 6.698772), tolerance = 1e-5)
})

test_that("sun_rise_set errors when the sun does not rise", {
    expect_error(
        sun_rise_set(172, lat = -80, long = 0, angle = 0, flag = "rise"),
        "the sun never rises"
    )
})
