#' Calculate thermal time using cardinal temperatures
#'
#' @param maxt The maximum temperature
#' @param mint The minimum temperature
#' @param x_temp The cardinal temperatures 
#' @param y_temp The effective thermal time
#' @param method The method to calculate thermal time. 
#' The default method is ( maxt + mint ) / 2 - base. 
#' The three hour temperature methods will be usesd if method = '3hr'
#' @return The thermal time.
#' @export
#' @examples 
#' mint <- c(0, 10)
#' maxt <- c(30, 40)
#' x_temp <- c(0, 20, 35)
#' y_temp <- c(0, 20, 0)
#' thermal_time(mint, maxt, x_temp, y_temp)
#' thermal_time(mint, maxt, x_temp, y_temp, method = '3hr')
thermal_time <- function(mint, maxt, x_temp, y_temp,
                         method = NULL)
{
    if (!is.numeric(maxt) | !is.numeric(mint)) {
        stop("Numeric vector is required for mint and maxt.")
    }
    if (length(mint) != length(maxt)) {
        stop("mint and maxt require the same length.")
    }
    if (!is.numeric(x_temp) | !is.numeric(y_temp)) {
        stop("Numeric vector is required for x_temp and y_temp.")
    }
    if (length(x_temp) != length(y_temp)) {
        stop("x_temp and y_temp require the same length.")
    }
    if (!is.null(method) && !method %in% c("3hr")) {
        stop("Method should be either NULL or '3hr'.")
    }
    if (is.null(method)) {
        meant <- (maxt + mint) / 2
        tt <- interpolation_function(x = x_temp, y = y_temp, values = meant)
        return (tt)
    } else if (method == "3hr") {
        pos <- mint > maxt
        if (sum(pos) > 0) {
            stop("Minimum temperature is more than maximum temperature.")
        }
        # Calculate the 3hour temperature
        hour <- seq(1, 8)
        frac <- 0.92105 + 0.1140 * hour - 0.0703 * 
            hour * hour + 0.0053 * hour * hour * hour
        mint2 <- matrix(rep(mint, times = 8), ncol = 8)
        maxt2 <- matrix(rep(maxt, times = 8), ncol = 8)
        frac2 <- matrix(rep(frac, each = length(mint)), ncol = 8)
        temp <- mint2 + (maxt2 - mint2) * frac2
        tt <- matrix(interpolation_function(x = x_temp, y = y_temp, values = temp), ncol = 8)
        res <- apply(tt, 1, mean)
        return(res)
    } else {
        stop("Not implemented for method ", method)
    }
}

