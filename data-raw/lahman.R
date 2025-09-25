# Baseball Hall of Fame classifier

library(tidyverse)
library(Lahman)

inductees <- Lahman::HallOfFame |>
  group_by(playerID) |>
  filter(votedBy %in% c("BBWAA", "Special Election") & category == "Player") |>
  summarise(
    yearsOnBallot = n(),
    inducted = sum(inducted == "Y"),
    best = max(votes/ballots)
  ) |>
  arrange(desc(best))

batters <- Lahman::Batting |>
  group_by(playerID) |>
  summarise(
    numSeasons = n_distinct(yearID),
    lastSeason = max(yearID),
    tH = sum(H),
    tHR = sum(HR)
  ) |>
  arrange(desc(tH))

pitchers <- Pitching |>
  group_by(playerID) |>
  summarise(
    numSeasons = n_distinct(yearID),
    lastSeason = max(yearID),
    tW = sum(W),
    tSO = sum(SO),
    tSV = sum(SV)
  ) |>
  arrange(desc(tW))

awards <- AwardsPlayers |>
  group_by(playerID) |>
  summarise(
    mvp = sum(awardID == "Most Valuable Player"),
    gg = sum(awardID == "Gold Glove"),
    cy = sum(awardID == "Cy Young Award")
  )

candidates <- batters |>
  full_join(pitchers, by = join_by(playerID)) |>
  full_join(awards, by = join_by(playerID)) |>
  full_join(inductees, by = join_by(playerID))

candidates[is.na(candidates)] <- 0

library(parsnip)

# 1. Define the model specification
# The engine is 'rpart' and the mode is 'classification' because the target is a factor.
tree_spec <- decision_tree() |>
  set_engine("rpart") |>
  set_mode("classification")

# 2. Fit the model using the formula and data
# Use the tidymodels piping to fit the model
hof_dt <- tree_spec |>
  fit(as.factor(inducted) ~ tH + tHR + mvp + gg + tW + tSO + tSV + cy,
      data = candidates)

hof_dt |>
  extract_fit_engine() |>
  rpart.plot::rpart.plot()

library(yardstick)

hof2025 <- hof_dt |>
  broom::augment(new_data = candidates) |>
  mutate(
    y = factor(inducted),
    y_hat = factor(.pred_class)
  )

usethis::use_data(hof2025, overwrite = TRUE)

sshof_d |>
  conf_mat(truth = y, estimate = y_hat)

hof_data |>
  roc_curve(truth = y, .pred_1) |>
  autoplot()

hof_data |>
  mutate(is_pitcher = tSO > 100) |>
  group_by(is_pitcher) |>
  faireR::fairness_cube(truth = y, estimate = y_hat)
