#' Estimate Dew Point Temperature from Air Temperature and Relative Humidity
#'
#' @description
#' Computes the dew point temperature (°C) using the **Magnus–Tetens approximation**,
#' a widely used empirical relationship between air temperature, relative humidity,
#' and the saturation vapor pressure of water vapor. The method provides a good
#' approximation for typical atmospheric conditions and is suitable for most
#' meteorological and agricultural applications. It works for any air temperature
#' (for example minimum, maximum or mean) with the matching relative humidity.
#' The inverse is [relative_humidity()].
#'
#' @param temperature Numeric. Air temperature (°C). Must have the same length as
#'   `rh`; inputs are not recycled.
#' @param rh Numeric. Relative humidity (%) corresponding to `temperature`.
#' @param na.action Either `"na.pass"` (the default), which propagates missing
#'   values without removing them, or `"na.fail"`, which errors if either input
#'   contains `NA` or `NaN`.
#'
#' @return Numeric. Dew point temperature (°C), with the same length as the
#'   inputs. If either input is entirely missing, the result is entirely `NA`.
#'
#' @details
#' The dew point temperature is estimated using the Magnus–Tetens equation:
#'
#' \deqn{
#' \gamma = \frac{a \cdot T}{b + T} + \ln\left(\frac{RH}{100}\right)
#' }
#' \deqn{
#' T_{dew} = \frac{b \cdot \gamma}{a - \gamma}
#' }
#'
#' where \eqn{T} is air temperature (°C), \eqn{RH} is relative humidity (%),
#' and the empirical constants are \eqn{a = 17.62} and \eqn{b = 243.12} (for water over a
#' liquid surface). This formulation is based on improvements to the original
#' Magnus equation proposed by **Alduchov and Eskridge (1996)**.
#'
#' For air temperatures below 0 °C, slightly different coefficients are sometimes
#' used to account for ice surfaces, but the above constants are generally suitable
#' for most temperature ranges encountered in agricultural or meteorological data.
#'
#' @references
#' Alduchov, O. A., & Eskridge, R. E. (1996). *Improved Magnus Form Approximation of Saturation Vapor Pressure*.
#' Journal of Applied Meteorology, 35(4), 601–609. \doi{10.1175/1520-0450(1996)035<0601:IMFAOS>2.0.CO;2}
#'
#' @examples
#' # Dew point for 10 °C and 80% RH
#' dew_point(10, 80)
#'
#' # Vectorized input
#' dew_point(c(5, 10, 15), c(90, 70, 50))
#'
#' @export
dew_point <- function(temperature, rh, na.action = c("na.pass", "na.fail")) {
    na.action <- match.arg(na.action)
    validate_humidity_inputs(temperature, rh, "rh", na.action)
    a <- 17.62
    b <- 243.12

    if (all(is.na(temperature)) || all(is.na(rh))) {
        return(rep(NA_real_, length(temperature)))
    }
        
    if (any(rh <= 0 | rh > 100, na.rm = TRUE)) {
        warning("Relative humidity values should be between 0 and 100.")
    }

    gamma <- (a * temperature) / (b + temperature) + log(rh / 100)
    t_dew <- (b * gamma) / (a - gamma)
    
    return(t_dew)
}


#' Estimate Relative Humidity from Air Temperature and Dew Point Temperature
#'
#' @description
#' Computes relative humidity (%) from air temperature and dew point temperature
#' using the **Magnus-Tetens approximation**. This is the inverse of [dew_point()].
#'
#' @param temperature Numeric. Air temperature (°C). Must have the same length as
#'   `dewpoint`; inputs are not recycled.
#' @param dewpoint Numeric. Dew point temperature (°C). Should not exceed `temperature`.
#' @param na.action Either `"na.pass"` (the default), which propagates missing
#'   values without removing them, or `"na.fail"`, which errors if either input
#'   contains `NA` or `NaN`.
#'
#' @return Numeric. Relative humidity (%), between 0 and 100 when
#' `dewpoint <= temperature`, with the same length as the inputs. If either
#' input is entirely missing, the result is entirely `NA`.
#'
#' @details
#' Relative humidity is the ratio of the saturation vapour pressure at the dew
#' point to that at the air temperature:
#'
#' \deqn{
#' RH = 100 \cdot \exp\left(\frac{a \cdot T_{dew}}{b + T_{dew}} -
#' \frac{a \cdot T}{b + T}\right)
#' }
#'
#' with \eqn{a = 17.62} and \eqn{b = 243.12} (Alduchov and Eskridge, 1996).
#'
#' @references
#' Alduchov, O. A., & Eskridge, R. E. (1996). *Improved Magnus Form Approximation of Saturation Vapor Pressure*.
#' Journal of Applied Meteorology, 35(4), 601–609. \doi{10.1175/1520-0450(1996)035<0601:IMFAOS>2.0.CO;2}
#'
#' @examples
#' # Relative humidity for 10 °C air temperature and 6.7 °C dew point
#' relative_humidity(10, 6.7)
#'
#' # Vectorized input
#' relative_humidity(c(5, 10, 15), c(3.5, 4.8, 4.7))
#'
#' @export
relative_humidity <- function(temperature, dewpoint, na.action = c("na.pass", "na.fail")) {
    na.action <- match.arg(na.action)
    validate_humidity_inputs(temperature, dewpoint, "dewpoint", na.action)
    a <- 17.62
    b <- 243.12


    if (all(is.na(temperature)) || all(is.na(dewpoint))) {
        return(rep(NA_real_, length(temperature)))
    }

    if (any(dewpoint > temperature, na.rm = TRUE)) {
        warning("Dew point temperature should not exceed air temperature.")
    }

    100 * exp((a * dewpoint) / (b + dewpoint) - (a * temperature) / (b + temperature))
}

validate_humidity_inputs <- function(temperature, other, other_name, na.action) {
    is_numeric_or_missing <- function(x) {
        is.numeric(x) || (is.logical(x) && all(is.na(x)))
    }
    if (!is_numeric_or_missing(temperature) || !is_numeric_or_missing(other)) {
        stop("temperature and ", other_name, " must be numeric.", call. = FALSE)
    }
    if (length(temperature) != length(other)) {
        stop("temperature and ", other_name, " must have the same length.", call. = FALSE)
    }
    if (na.action == "na.fail" && (anyNA(temperature) || anyNA(other))) {
        stop("temperature and ", other_name, " must not contain missing values.", call. = FALSE)
    }
}
