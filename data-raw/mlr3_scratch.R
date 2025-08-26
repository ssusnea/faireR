## code to prepare `DATASET` dataset goes here

library(mlr3fairness)
library(mlr3learners)

t = tsk("adult_train")$filter(1:1000)
t$col_roles$pta

l = lrn("classif.ranger")
l$train(t)

test = tsk("adult_test")
prd = l$predict(test)

prd$score(msr("fairness.tpr"), task = test)

meas = groupwise_metrics(msr("classif.tpr"), test)
prd$score(meas, task = test)



cmp <- mlr3fairness::compas
y <- cmp$two_year_recid
a <- cmp$race
y_hat <- cmp$score_text

library(tidyverse)
cmp |>
  group_by(race) |>
  summarize(n = n())

mlr3fairness::compas


library(mlr3fairness)
cmp <- mlr3::tsk("compas")
cmp
cmp$nrow
cmp$data()$race |> summary()

prd <- cmp

cmp_task <- tsk("compas")
cmp_pred <- lrn("classif.rpart")$train(cmp_task)$predict(cmp_task)
cmp_pred$confusion
fairness_tensor(cmp_pred, task = task)

library(mlr3viz)
autoplot(task, type = "pairs")



tsk <- Lahman::Teams |>
  filter(yearID > 1954) |>
  mutate(
    wpct = W / (W + L),
    won_lg = ifelse(LgWin == "Y", 1, 0),
    is_nyc = grepl(pattern = "New York|Brooklyn", name)
  ) |>
  select(won_lg, R, RA, teamID, is_nyc) |>
  filter(!is.na(won_lg)) |>
  as_task_classif(target = "won_lg", id = "baseball")

tsk$col_roles$pta <- "is_nyc"
# autoplot(tsk)

lrn <- tsk |>
  lrn("classif.rpart")$train()

prd <- lrn$predict(tsk)

m <- groupwise_metrics(msr("classif.acc"), tsk)
m2 <- msrs(c("regr.mse", "regr.rmse"))
prd$score(m, tsk)

ind <- msr("fairness.ppv")
sep <- msr("fairness.acc")
suf <- c(msr("fairness.fpr"), msr("fairness.tpr"))

ours <- c(ind, sep, suf)

prd$score(c(ind, sep, suf), tsk)
