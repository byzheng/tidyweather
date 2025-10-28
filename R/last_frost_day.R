#' Calculate the last frost day
#'
#' This function calculates the last frost day from a numeric vector of daily
#' minimum temperatures using tidyverse principles.
#'
#' @param .data A data frame or tibble containing daily minimum temperatures in a column named "mint".
#' @param threshold The stress temperature threshold for frost (default: 0)
#' @param hemisphere Hemisphere indicator: "south" or "north" (default: "south").
#'      If latitude information is available in the data, it will be used to determine the hemisphere.
#' @param require_full_year Logical. If TRUE, requires exactly 365 or 366 days (default: TRUE)
#'
#' @return An data.frame or tibble representing the day of year for the last frost, or NA if no frost occurs
#' @export
#'
#' @examples
#' file <- system.file("extdata/ppd_72150.met", package = "tidyweather")
#' records <- read_weather(file)
#' records |>
#'     dplyr::group_by(year) |> 
#'     last_frost_day(require_full_year = FALSE)
last_frost_day <- function(.data,
                           threshold = 0,
                           hemisphere = "south",
                           require_full_year = TRUE) {

    stopifnot(tibble::is_tibble(.data) || is.data.frame(.data))
    stopifnot(is.numeric(threshold) && length(threshold) == 1)
    stopifnot(is.logical(require_full_year) && length(require_full_year) == 1)
    stopifnot(is.character(hemisphere) && length(hemisphere) == 1)
    if (!tibble::has_name(.data, "mint")) {
        stop("Input data should be a column mint for daily minimum temperatures.")
    }
    # Group-wise operation
    .data |>
        dplyr::group_modify(~ {
            df <- .x

            # Check for completeness if required
            if (require_full_year) {
                .check_full_year(df)
            }

            # Hemisphere detection
            if (tibble::has_name(df, "latitude")) {
                if (length(unique(df$latitude)) != 1) {
                    stop("Latitude values are not consistent within a group.")
                }
                if (df$latitude[1] < 0) {
                    hemisphere <- "south"
                } else {
                    hemisphere <- "north"
                }
            }
            match.arg(hemisphere, c("south", "north"))
            if (hemisphere == "north") {
                stop("Northern hemisphere calculations not yet implemented")
            }
            # Main calculation
            mint <- rev(df$mint)
            mint[mint < threshold] <- -99999
            min_pos <- which.min(mint)
            if (min(mint) > -99999) {
                return(tibble::tibble(last_frost_day = NA_integer_))
            }
            min_pos <- length(mint) + 1 - min_pos

            tibble::tibble(last_frost_day = min_pos)
        })
}
