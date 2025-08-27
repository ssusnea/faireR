#' Ironman Texas race results from 2024
#'
#' @description Data from the 2024 Ironman Texas race
#' @details
#' Contains data for professional racers' times and rankings as well as
#' predicted outcomes derived from Marten and Starflinger's proposed quotient method
#'
#' @format ## `ironman`
#' A data frame with 70 rows and 8 columns:
#' \describe{
#'  \item{Gender}{Individual's gender}
#'  \item{Division}{Individual's division within the competition}
#'  \item{Division Rank}{Individual's ranking within their division}
#'  \item{Overall Time}{Individual's total time to complete the race}
#'  \item{Finish Status}{Indicates if an individual completed the race or not}
#'  \item{y}{Indicates if the individual was awarded prize money or not}
#'  \item{quotient_model}{Quotient between an individual's overall time and the 2024 world reccord}
#'  \item{y_hat}{Indicates if an individual would've recieved prize money or not using Martens and Starflinger's quotient method}
#' }
#'
#' @docType data
#' @source <https://www.coachcox.co.uk/imstats/race/2148/results/>
"ironman"
