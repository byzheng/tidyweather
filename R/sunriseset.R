#' The time for sunrise and sunset from 90 degree in am and pm. +ve above the horizon, -ve below the horizon.
#' 
#' @param date dates of class `Date`.
#' @param lat latitude of site (deg)
#' @param long longitude of site (deg)
#' @param timezone Olson time zone name of the returned times, such as
#' `"UTC"` (default) or `"Australia/Brisbane"`. See [OlsonNames()].
#' @param  angle angle to measure time between, such as twilight (deg).
#' angular distance between 90 deg and end of twilight - altitude of sun. +ve up, -ve down.
#' @param flag `"rise"` or `"set"`
#' @return A `POSIXct` vector in `timezone`, on the local calendar day of `date`.
#' @examples
#' date <- as.Date("2021-06-21")
#' sun_rise_set(date, lat = -27.5, long = 153, angle = 0)
#' sun_rise_set(date, lat = -27.5, long = 153, timezone = "Australia/Brisbane",
#'              angle = 0, flag = "rise")
#' sun_rise_set(date, lat = -27.5, long = 153, timezone = "Australia/Brisbane",
#'              angle = 0, flag = "set")
#' @export
sun_rise_set <- function(date, lat, long, timezone = "UTC", angle = 6, flag = c("rise", "set")) {
    flag <- match.arg(flag)
    stopifnot(inherits(date, "Date"), length(date) > 0, !anyNA(date))
    stopifnot(is.numeric(lat) && is.numeric(long) && length(lat) == 1 && length(long) == 1)
    stopifnot(is.character(timezone) && length(timezone) == 1)
    stopifnot(is.numeric(angle) && length(angle) == 1)

    doy <- as.POSIXlt(date)$yday + 1
    doy_len <- length(doy)
    lat <- rep(lat, length.out = doy_len)
    long <- rep(long, length.out = doy_len)
    dg2rdn <- pi / 180
    rdn2dg <- 180 / pi
    lngHour <- long / 15
    if (flag == 'rise') {
        tt <- doy + ((6 - lngHour) / 24)
    } else {
        tt <- doy + ((18 - lngHour) / 24)
    }
    MM <- (0.9856 * tt) - 3.289
    LL <- MM + (1.916 * sin(MM * dg2rdn)) + (0.020 * sin(2 * MM * dg2rdn)) + 282.634
    LL <- (LL + 360 * 100) %% 360
    RA <- rdn2dg * atan(0.91764 * tan(LL * dg2rdn))
    RA <- (RA + 360 * 100) %% 360
    Lquadrant <- (floor(LL/90)) * 90
    RAquadrant <- (floor(RA/90)) * 90
    RA <- RA + (Lquadrant - RAquadrant)
    RA <- RA / 15
    sinDec <- 0.39782 * sin(LL * dg2rdn)
    cosDec <- cos(asin(sinDec))
    cosH <- (cos((angle + 90)* dg2rdn) - (sinDec * sin(lat * dg2rdn))) / (cosDec * cos(lat * dg2rdn))

    if (sum(cosH > 1) > 0)
    {
        stop('the sun never rises on this location (on the specified date)')
    }
    if (sum(cosH < -1) > 0)
    {
        stop('the sun never sets on this location (on the specified date)')
    }

    if (flag == 'rise')
    {
        HH <- 360 - rdn2dg * acos(cosH)
    } else
    {
        HH <- rdn2dg * acos(cosH)
    }
    HH <- HH / 15
    TT <- HH + RA - (0.06571 * tt) - 6.622
    UT <- TT - lngHour
    UT <- (UT + 24 * 100) %% 24

    base <- as.POSIXct(format(date), tz = "UTC")
    result <- base + UT * 3600
    for (shift in c(-1, 1)) {
        candidate <- base + UT * 3600 + shift * 86400
        local_date <- as.Date(format(candidate, "%Y-%m-%d", tz = timezone))
        current <- as.Date(format(result, "%Y-%m-%d", tz = timezone))
        use <- current != date & local_date == date
        result[use] <- candidate[use]
    }
    attr(result, "tzone") <- timezone
    result
}
