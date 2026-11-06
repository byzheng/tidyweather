test_that("dp_mint equals air temperature at saturation", {
    expect_equal(dp_mint(20, 100), 20)
    expect_equal(dp_mint(c(-5, 0, 30), c(100, 100, 100)), c(-5, 0, 30))
})

test_that("dp_mint matches known Magnus-Tetens values", {
    expect_equal(dp_mint(10, 80), 6.706013, tolerance = 1e-6)
    expect_equal(dp_mint(0, 50), -9.20202, tolerance = 1e-5)
})

test_that("dp_mint satisfies the Magnus equation", {
    a <- 17.62
    b <- 243.12
    mint <- c(5, 10, 15, 25)
    minrh <- c(90, 70, 50, 35)
    t_dew <- dp_mint(mint, minrh)
    # Relative humidity is the ratio of saturation vapour pressure at dew point and air temperature
    rh <- 100 * exp(a * t_dew / (b + t_dew)) / exp(a * mint / (b + mint))

    expect_equal(rh, minrh, tolerance = 1e-8)
})

test_that("dp_mint is vectorized and below air temperature when unsaturated", {
    mint <- c(5, 10, 15)
    minrh <- c(90, 70, 50)
    result <- dp_mint(mint, minrh)

    expect_equal(length(result), 3)
    expect_equal(result, c(3.495014, 4.775543, 4.651626), tolerance = 1e-6)
    expect_true(all(result < mint))
})

test_that("dp_mint increases with relative humidity", {
    result <- dp_mint(15, c(20, 40, 60, 80, 100))

    expect_true(all(diff(result) > 0))
})

test_that("dp_mint propagates NA values", {
    result <- dp_mint(c(10, NA, 15), c(80, 70, NA))

    expect_equal(result[1], dp_mint(10, 80))
    expect_true(all(is.na(result[2:3])))
})

test_that("dp_mint warns for relative humidity outside (0, 100]", {
    expect_warning(dp_mint(10, 0), "between 0 and 100")
    expect_warning(dp_mint(10, 120), "between 0 and 100")
    expect_no_warning(dp_mint(10, 100))
})

test_that("dp_mint requires numeric input", {
    expect_error(dp_mint("10", 80))
    expect_error(dp_mint(10, "80"))
})

test_that("rh_from_dp is 100% when dew point equals air temperature", {
    expect_equal(rh_from_dp(c(-5, 0, 20, 30), c(-5, 0, 20, 30)), rep(100, 4))
})

test_that("rh_from_dp matches known values", {
    expect_equal(rh_from_dp(10, 6.706013094), 80, tolerance = 1e-6)
    expect_equal(rh_from_dp(0, -9.202019777), 50, tolerance = 1e-6)
})

test_that("rh_from_dp is the inverse of dp_mint", {
    mint <- c(-5, 0, 5, 10, 15, 25, 35)
    minrh <- c(95, 80, 60, 45, 30, 70, 20)

    expect_equal(rh_from_dp(mint, dp_mint(mint, minrh)), minrh, tolerance = 1e-8)
    expect_equal(dp_mint(mint, rh_from_dp(mint, mint - 3)), mint - 3, tolerance = 1e-8)
})

test_that("rh_from_dp is vectorized, bounded and decreases with dew point depression", {
    result <- rh_from_dp(20, c(20, 15, 10, 5, 0, -10))

    expect_equal(length(result), 6)
    expect_true(all(result > 0 & result <= 100))
    expect_true(all(diff(result) < 0))
})

test_that("rh_from_dp propagates NA values", {
    result <- rh_from_dp(c(10, NA, 15), c(5, 5, NA))

    expect_false(is.na(result[1]))
    expect_true(all(is.na(result[2:3])))
})

test_that("rh_from_dp warns when dew point exceeds air temperature", {
    expect_warning(rh_from_dp(10, 12), "should not exceed")
    expect_no_warning(rh_from_dp(10, 10))
})

test_that("rh_from_dp requires numeric input", {
    expect_error(rh_from_dp("10", 5))
    expect_error(rh_from_dp(10, "5"))
})
