#' Center timestamps on a daily time
#'
#' Shift each timestamp so that its nearest sunrise, sunset, or fixed local
#' time falls at a chosen local clock time on the event's calendar date.
#' Timestamps exactly halfway between two events use the later event. The
#' shift is measured in elapsed seconds.
#'
#' @param timestamps A non-empty `POSIXct` vector. Non-missing values must be
#'   finite. Its time zone applies to the whole vector.
#' @param as The desired local clock time of the event, in decimal hours from
#'   midnight, in `[0, 24)`. Defaults to noon.
#' @param to `"rise"` (default), `"set"`, or a single numeric local clock time
#'   in decimal hours from midnight, in `[0, 24)`.
#' @param ... Additional arguments passed to [sun_rise_set()], such as
#'   `latitude`, `longitude`, and `angle`. The time zone is taken from
#'   `timestamps` and must not be supplied here. No additional arguments are
#'   accepted when `to` is numeric.
#'
#' @return A `POSIXct` vector of the same length and time zone as `timestamps`,
#'   in the original order, with missing timestamps returned as missing.
#'   If all timestamps are missing, no solar events are calculated and
#'   arguments passed to [sun_rise_set()] are not validated.
#'   If a required local clock time does not exist
#'   because of a time zone transition, an error is raised. Ambiguous local
#'   clock times are resolved according to the platform's time zone rules.
#'   Solar events are calculated for each input date and its adjacent dates;
#'   errors from [sun_rise_set()], including polar day or night, are propagated.
#' @examples
#' times <- as.POSIXct(c("2021-06-21 06:00", "2021-06-21 18:00"),
#'                     tz = "Australia/Brisbane")
#' center_time(times, to = "rise", latitude = -27.5, longitude = 153)
#' center_time(times, to = 6)
#'
#' # Two days of hourly temperatures, with the 06:00 peak centered at noon.
#' hours <- 0:47
#' times <- as.POSIXct("2021-06-21 00:00:00", tz = "Australia/Brisbane") +
#'   hours * 3600
#' temperature <- 20 + 8 * sin(2 * pi * hours / 24)
#' centered <- center_time(times, to = 6, as = 12)
#'
#' plot(times, temperature, type = "o", pch = 16, cex = 0.5,
#'      col = "#0072B2", lwd = 2, xaxt = "n",
#'      xlim = range(c(times, centered)), ylim = c(10, 30),
#'      xlab = "Local date and time (Australia/Brisbane)",
#'      ylab = "Temperature (degrees C)",
#'      main = "Centering a two-day hourly temperature series")
#' ticks <- seq(times[1], max(centered), by = "6 hours")
#' axis(1, at = ticks, labels = format(ticks, "%d %b\n%H:%M",
#'                                    tz = "Australia/Brisbane"), cex.axis = 0.75)
#' lines(centered, temperature, type = "o", pch = 1, cex = 0.5,
#'       col = "#D55E00", lwd = 2, lty = 2)
#' abline(v = as.numeric(times[1] + c(6, 12) * 3600),
#'        col = c("#0072B2", "#D55E00"), lty = 3)
#' legend("topright", legend = c("Original", "Centered (06:00 to 12:00)"),
#'        col = c("#0072B2", "#D55E00"), lty = c(1, 2),
#'        pch = c(16, 1), lwd = 2, bty = "n")
#' @export
center_time <- function(timestamps, as = 12, to = c("rise", "set"), ...) {
    if (!inherits(timestamps, "POSIXct") || length(timestamps) < 1) {
        stop("timestamps must be a non-empty vector of POSIXct values")
    }
    timestamp_seconds <- as.numeric(timestamps)
    present <- !is.na(timestamp_seconds)
    if (any(!is.finite(timestamp_seconds[present]))) {
        stop("non-missing timestamps must be finite")
    }
    if (!is.numeric(as) || length(as) != 1L || !is.finite(as) ||
        as < 0 || as >= 24) {
        stop("as must be a single finite number in [0, 24)")
    }
    if (is.character(to)) {
        to <- match.arg(to, c("rise", "set"))
    } else if (!is.numeric(to) || length(to) != 1L || !is.finite(to) ||
            to < 0 || to >= 24) {
        stop("to must be 'rise', 'set', or a single finite number in [0, 24)")
    }

    timezone <- attr(timestamps, "tzone")
    if (is.null(timezone) || identical(timezone, "")) {
        timezone <- Sys.timezone()
    }
    if (!is.character(timezone) || length(timezone) != 1L ||
        is.na(timezone) || !timezone %in% OlsonNames()) {
        stop("timestamps must have a valid Olson time zone")
    }

    dots <- list(...)
    if (is.numeric(to) && length(dots)) {
        stop("additional arguments are only allowed for sunrise or sunset")
    }
    if ("timezone" %in% names(dots)) {
        stop("timezone is taken from timestamps and cannot be supplied in ...")
    }

    result <- as.POSIXct(rep(NA_real_, length(timestamps)),
                        origin = "1970-01-01", tz = timezone)
    names(result) <- names(timestamps)
    if (!any(present)) {
        return(result)
    }

    dates <- as.Date(format(timestamps[present], "%Y-%m-%d", tz = timezone))
    event_dates <- sort(unique(c(dates - 1, dates, dates + 1)))

    local_time <- function(date, hour) {
        seconds <- hour * 3600
        whole <- floor(seconds)
        clock <- sprintf("%02d:%02d:%02d",
                         whole %/% 3600, (whole %% 3600) %/% 60, whole %% 60)
        text <- paste(format(date), clock)
        value <- as.POSIXct(text, format = "%Y-%m-%d %H:%M:%S", tz = timezone)
        if (anyNA(value) ||
            any(format(value, "%Y-%m-%d %H:%M:%S", tz = timezone) != text)) {
            stop("a required local clock time does not exist in the timestamps time zone")
        }
        value + (seconds - whole)
    }

    if (is.numeric(to)) {
        events <- local_time(event_dates, to)
    } else {
        events <- do.call(sun_rise_set, c(list(date = event_dates,
                                               timezone = timezone, flag = to),
                                          dots))
    }
    event_seconds <- as.numeric(events)
    if (any(!is.finite(event_seconds)) || any(diff(event_seconds) <= 0)) {
        stop("daily event times must be finite and strictly increasing")
    }
    midpoints <- event_seconds[-length(event_seconds)] + diff(event_seconds) / 2
    index <- findInterval(timestamp_seconds[present], midpoints) + 1L
    target <- local_time(event_dates[index], as)
    result[present] <- as.POSIXct((timestamp_seconds[present] - event_seconds[index]) +
                                      as.numeric(target),
                                  origin = "1970-01-01", tz = timezone)
    result
}
