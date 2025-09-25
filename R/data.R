#' Statcast pitch data from 2024
#'
#' @description Data from the CSAS 2025 Data Challenge
#' @details
#' Contains data for all pitches thrown in Major League Baseball during
#' April, May, and June of 2024.
#'
#' @docType data
#' @seealso [baseballr::scrape_statcast_savant()]
#' @references <https://baseballsavant.mlb.com/csv-docs>
#' @source <https://statds.org/events/csas2025/challenge.html>
"csas25"

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
#'  \item{gender}{Individual's gender}
#'  \item{division}{Individual's division within the competition}
#'  \item{division_rank}{Individual's ranking within their division}
#'  \item{overall_time}{Individual's total time to complete the race}
#'  \item{finish_status}{Indicates if an individual completed the race or not}
#'  \item{y}{Indicates if the individual was awarded prize money or not}
#'  \item{quotient_model}{Quotient between an individual's overall time and the 2024 world reccord}
#'  \item{y_hat}{Indicates if an individual would've recieved prize money or not using Martens and Starflinger's quotient method}
#' }
#'
#' @docType data
#' @references \doi{10.1007/978-3-031-24907-5_40}
#' @source <https://www.coachcox.co.uk/imstats/race/2148/results/>
"ironman"

#' COMPAS data
#'
#' @docType data
#' @seealso [mlr3fairness::compas]
"compas_binary"

#' Master's swimming the 1650
#' @description
#' Time, in seconds, for master's swimmers in the 1650 freestyle event.
#' The data covers the years 2006-2016.
#' @docType data
#' @references \doi{10.1515/jqas-2024-0018}
#' @source <https://github.com/elizabeth-upton/Age_and_Performance_SwimRun>
"swimming1650"

#' New Zealand master's swimming
#' @description Time, in seconds, for New Zealand master's swimmers in different events.
#' The data covers years 2013-2020
#' @docType data
#' @references \doi{10.1515/jqas-2023-0051}
#' @source <https://osf.io/gcpwv>
"nz_swim"

#' Dipsea 2021 race results
#' @description Results for the 2021 Dipsea race.
#' @docType data
#' @references \doi{10.1080/09332480.2022.2145138}
#' @source <https://www.dipsea.org/search/dipsearesults.php>
"dipsea2021"

#' Baseball Holl of Fame classifier data
#' @docType data
#' @references <https://baseballwithr.wordpress.com/2014/11/18/building-a-hall-of-fame-classifier-2/>
"hof2025"
