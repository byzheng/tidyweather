test_that("fixed clock times are centered in the input time zone", {
    times <- as.POSIXct(c(
        first = "2021-06-21 06:30:00",
        second = "2021-06-22 05:45:00"),
                        tz = "Australia/Brisbane")
    result <- center_time(times, to = 6)

    expect_s3_class(result, "POSIXct")
    expect_identical(attr(result, "tzone"), "Australia/Brisbane")
    expect_identical(names(result), names(times))
    expect_equal(format(result, "%Y-%m-%d %H:%M:%S"),
                c(first = "2021-06-21 12:30:00",
                second = "2021-06-22 11:45:00"))
    expect_equal(as.numeric(center_time(times[1], as = 8.5, to = 6.25)) -
                     as.numeric(times[1]), 2.25 * 3600)
})

test_that("solar events are centered using local dates and forwarded arguments", {
    dates <- as.Date(c("2021-06-21", "2021-06-22"))
    for (event in c("rise", "set")) {
        times <- sun_rise_set(dates, latitude = -27.5, longitude = 153,
                            timezone = "Australia/Brisbane", angle = 0,
                            flag = event)
        result <- center_time(times, to = event, latitude = -27.5,
                            longitude = 153, angle = 0)
        expect_identical(attr(result, "tzone"), "Australia/Brisbane")
        expect_equal(format(result, "%Y-%m-%d %H:%M:%S"),
                    c("2021-06-21 12:00:00", "2021-06-22 12:00:00"))
    }
    expect_equal(center_time(times[1], as = 12, to = "set", -27.5, 153, angle = 0),
                center_time(times[1], to = "set", latitude = -27.5,
                            longitude = 153, angle = 0))
})

test_that("UTC solar events are centered at longitudes around the world", {
    dates <- as.Date(c("2021-06-21", "2021-06-22"))
    sites <- data.frame(
        longitude = c(-179, -90, 0, 90, 179),
        rise_hour = c(18, 12, 6, 0, 18),
        set_hour = c(6, 0, 18, 12, 6)
    )
    targets <- as.POSIXct(paste(dates, "09:30:00"), tz = "UTC")

    for (i in seq_len(nrow(sites))) {
        for (event in c("rise", "set")) {
            events <- sun_rise_set(dates, latitude = 0,
                                longitude = sites$longitude[i],
                                timezone = "UTC", angle = 0, flag = event)
            approximate_hour <- sites[[paste0(event, "_hour")]][i]
            approximate <- as.POSIXct(paste(dates, "00:00:00"), tz = "UTC") +
                approximate_hour * 3600
            expect_lt(max(abs(as.numeric(events) - as.numeric(approximate))), 10 * 60)

            offsets <- c(-1800, 0, 1800)
            times <- as.POSIXct(rep(as.numeric(events), each = length(offsets)) +
                                    offsets,
                                origin = "1970-01-01", tz = "UTC")
            result <- center_time(times, as = 9.5, to = event, latitude = 0,
                                longitude = sites$longitude[i], angle = 0)
            expected <- rep(as.numeric(targets), each = length(offsets)) + offsets

            expect_identical(attr(result, "tzone"), "UTC")
            expect_equal(as.numeric(result), expected, tolerance = 1e-8)
        }
    }
})

test_that("the nearest solar event is used, including midpoint ties", {
    dates <- as.Date(c("2021-06-21", "2021-06-22"))
    events <- sun_rise_set(dates, latitude = -27.5, longitude = 153,
                        timezone = "Australia/Brisbane")
    midpoint <- mean(as.numeric(events))
    times <- as.POSIXct(c(midpoint, as.numeric(events[1]), midpoint - 1,
                        as.numeric(events[2]), as.numeric(events[1])),
                        origin = "1970-01-01", tz = "Australia/Brisbane")
    targets <- as.POSIXct(c("2021-06-21 12:00:00", "2021-06-22 12:00:00"),
                        tz = "Australia/Brisbane")
    index <- c(2, 1, 1, 2, 1)
    expected <- as.numeric(times) + as.numeric(targets[index]) -
        as.numeric(events[index])

    expect_equal(as.numeric(center_time(times, latitude = -27.5, longitude = 153)),
                expected, tolerance = 1e-8)
})

test_that("local clock times account for daylight saving time", {
    times <- as.POSIXct(c("2024-03-09 01:00:00", "2024-03-10 01:00:00"),
                        tz = "America/New_York")
    result <- center_time(times, to = 1)
    expect_equal(format(result, "%Y-%m-%d %H:%M:%S"),
                c("2024-03-09 12:00:00", "2024-03-10 12:00:00"))
    expect_equal(as.numeric(result) - as.numeric(times), c(11, 10) * 3600)

    midpoint <- as.POSIXct(c("2024-03-09 12:59:59", "2024-03-09 13:00:00"),
                        tz = "America/New_York")
    expect_equal(as.numeric(center_time(midpoint, to = 1)) - as.numeric(midpoint),
                 c(11, 10) * 3600)
    expect_error(center_time(times[2], to = 2.5), "does not exist")
    expect_error(center_time(times[2], as = 2.5, to = 1), "does not exist")
})

test_that("missing timestamps remain missing for fixed and solar events", {
    times <- as.POSIXct(c(before = NA, first = "2021-06-21 06:00:00",
                        middle = NA, second = "2021-06-22 07:00:00",
                        after = NA), tz = "Australia/Brisbane")
    present <- !is.na(times)
    for (event in list(6, "rise", "set")) {
        args <- if (is.character(event)) list(latitude = -27.5, longitude = 153) else list()
        result <- do.call(center_time, c(list(timestamps = times, to = event), args))
        expected <- do.call(center_time, c(list(timestamps = times[present], to = event), args))
        expect_identical(is.na(result), is.na(times))
        expect_identical(names(result), names(times))
        expect_identical(attr(result, "tzone"), "Australia/Brisbane")
        expect_equal(result[present], expected)
    }

    missing <- times[!present]
    for (event in list(6, "rise", "set")) {
        result <- center_time(missing, to = event)
        expect_identical(result, missing)
    }
    expect_error(center_time(missing, as = 24, to = 6), "as must")
    expect_error(center_time(missing, to = 6, latitude = 0), "additional arguments")
})

test_that("center_time validates inputs and propagates solar errors", {
    time <- as.POSIXct("2021-06-21 06:00:00", tz = "UTC")
    expect_error(center_time(as.Date("2021-06-21"), to = 6), "POSIXct")
    expect_error(center_time(as.POSIXct(character(), tz = "UTC"), to = 6), "POSIXct")
    expect_error(center_time(as.POSIXct(Inf, origin = "1970-01-01", tz = "UTC"),
                            to = 6), "finite")
    expect_error(center_time(as.POSIXct(c(NA_real_, -Inf), origin = "1970-01-01",
                                        tz = "UTC"), to = 6), "finite")
    for (value in list(NA_real_, Inf, -1, 24, c(1, 2), "12")) {
        expect_error(center_time(time, as = value, to = 6), "as must")
    }
    for (value in list(NA_real_, Inf, -1, 24, c(1, 2), "noon", NA_character_)) {
        expect_error(center_time(time, to = value))
    }
    expect_error(center_time(time, to = 6, latitude = 0), "additional arguments")
    expect_error(center_time(time, latitude = 0, longitude = 0, timezone = "UTC"),
                "timezone is taken")
    invalid_zone <- time
    attr(invalid_zone, "tzone") <- "not/a/timezone"
    expect_error(center_time(invalid_zone, to = 6), "valid Olson time zone")
    expect_error(center_time(time, latitude = -80, longitude = 0, angle = 0),
                "sun never rises")
})
