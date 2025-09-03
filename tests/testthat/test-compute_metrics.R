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
  expect_length(compas_vec, 4)

  csas_vec <- compute_fairness(
    data = csas25,
    target = "y",
    prediction = csas25$y_hat,
    protected_attribute = "stand"
  )

  expect_type(csas_vec, "double")
  expect_length(csas_vec, 4)

  bad <- c("overall_time", "world_record")
  ironman2 <- ironman[, !names(ironman) %in% bad]
  ironman_vec <- compute_fairness(
    data = ironman2,
    target = "y",
    prediction = ironman$y_hat,
    protected_attribute = "gender"
  )
  expect_type(ironman_vec, "double")
  expect_length(ironman_vec, 4)

})
