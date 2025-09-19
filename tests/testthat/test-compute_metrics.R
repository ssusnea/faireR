test_that("metrics works", {
  expect_s3_class(compas_binary, "TaskClassif")
  expect_s3_class(ironman, "tbl")
  expect_s3_class(csas25, "tbl")

  compas <- compas_binary$data()
  compas_vec <- compute_fairness(
    data = compas,
    target = "two_year_recid",
    prediction = factor(ifelse(compas$score_text == "High", 1, 0)),
    protected_attribute = "race"
  )
  expect_type(compas_vec, "double")
  expect_length(compas_vec, 3)

  csas <- csas25 |>
    dplyr::mutate(
      y = factor(ifelse(is_within_strike_zone, 1, 0)),
      y_hat = factor(ifelse(is_called_strike, 1, 0))
    )
  csas_vec <- compute_fairness(
    data = csas,
    target = "y",
    prediction = csas$y_hat,
    protected_attribute = "stand"
  )

  expect_type(csas_vec, "double")
  expect_length(csas_vec, 3)

  bad <- c("overall_time", "world_record")
  ironman2 <- ironman[, !names(ironman) %in% bad] |>
    dplyr::mutate(
     y = factor(division_rank <= 10),
     y_hat = factor(dplyr::dense_rank(quotient_model) <= 20)
    )

  ironman_vec <- compute_fairness(
    data = ironman2,
    target = "y",
    prediction = ironman2$y_hat,
    protected_attribute = "gender"
  )
  expect_type(ironman_vec, "double")
  expect_length(ironman_vec, 3)

})

test_that("metric_set works", {
  blah <- yardstick::metric_set(
    yardstick::detection_prevalence,
  )

  ironman |>
    dplyr::mutate(
      y = factor(division_rank <= 10),
      y_hat = factor(dplyr::dense_rank(quotient_model) <= 20)
    ) |>
  blah(truth = y, estimate = y_hat)
})


test_that("yardstick works", {
  ironman_grp <- ironman |>
    dplyr::mutate(
      y = factor(division_rank <= 10),
      y_hat = factor(dplyr::dense_rank(quotient_model) <= 20)
    ) |>
    dplyr::group_by(gender)

  ironman_vec <- ironman_grp |>
    dplyr::select(-overall_time, -world_record) |>
    compute_fairness(
      target = "y",
      prediction = ironman_grp$y_hat,
      protected_attribute = "gender"
    )

  ironman_vec2 <- ironman_grp |>
    dplyr::select(-overall_time, -world_record) |>
    compute_fairness_tidy(
      truth = "y",
      estimate = "y_hat"
    )

  expect_identical(ironman_vec, ironman_vec2)

  fairness_cube(ironman_grp, truth = y, estimate = y_hat)
  # independence
  cv <- fairness_cv(ironman_grp)
  expect_type(cv, "double")
  expect_equal(cv, fairness_independence(ironman_grp))
  expect_equal(cv, unname(ironman_vec["fairness.pp"]))

  # separation
  eod <- fairness_eod(ironman_grp)
  expect_type(eod, "double")
  expect_equal(eod, fairness_separation(ironman_grp))
  expect_equal(eod, unname(ironman_vec["fairness.equalized_odds"]))

  eod_mlr <- ironman_grp |>
    dplyr::select(-overall_time, -world_record) |>
    mlr3fairness::compute_metrics(
      target = "y",
      prediction = ironman_grp$y_hat,
      protected_attribute = "gender",
      metrics = mlr3::msr("fairness.eod")
    )

  # sufficiency
  pp <- fairness_predictive_parity(ironman_grp)
  expect_type(pp, "double")
  expect_equal(pp, fairness_predictive_parity(ironman_grp))
  expect_equal(pp, unname(ironman_vec["fairness.predictive_parity"]))

  cube <- fairness_cube(ironman_grp)

  expect_equal(
    tibble::tibble(
      independence = cv,
      separation = eod,
      sufficiency = pp
    ),
    cube
  )

  expect_s3_class(cube, "tbl")

})
