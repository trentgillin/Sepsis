#' Function that finds the blood culture window according to the CDC definition of Sepsis.
#'
#' According to the CDC, in order for sepsis to take place, ordan dysfunction and antibiotic 
#' administration must have taken place within 2 dasy before or 2 days after blood cultures 
#' being ordered. 
#'
#' @param .data The dataset you are working with.
#' @param timestamp_variable The time for the variable you want to test it it occurs within the
#' blood culture window
#' @param blood_culture_time The timestamp of your blood culture value
#' @return Gives a dataset with a new variable consisting of the difference between two time periods
#' @examples
#' \dontrun{
#' result <- find_bx_window(data, servie_time, culture_draw_time)
#' }
#' @export


find_bx_window <- function(.data, timestamp_variable, blood_culture_time) {
  if (!lubridate::is.POSIXct(.data$timestamp_variable) == TRUE) {
    stop("timestamp_variable must be POSIXct")
  }

  timestamp_variable <- rlang::enquo(timestamp_variable)
  blood_cutlre_time <- rlang::enquo(blood_culture_time)

  .data <- dplyr::mutate(.data, begining_time = !!blood_culture_time - lubridate::days(2),
                  ending_time = !!blood_culture_time + lubridate::days(2))

  .data$within_window <- dplyr::if_else(dplyr::between(timestamp_variable, begining_time, ending_time), TRUE, FALSE)

  .data <- .data[[-c("begining_time", "ending_time")]]

  return(.data)

}

# so that check will ignore begining and ending time
utils::globalVariables(c("begining_time", "ending_time"))
