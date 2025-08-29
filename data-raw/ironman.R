## code to prepare `ironman` dataset goes here

library(tidyverse)

marathon <- read_csv(here::here("data-large/ironman_texas_2024.csv"), skip = 35) |>
  slice_head(n = 2769)

ironman <- marathon |>
  select(Gender, Division, `Division Rank`, `Overall Time`, `Finish Status`) |>
  filter(Division %in% c("MPRO", "FPRO") & `Finish Status` == "Finisher") |>
  mutate(y = case_when(Gender == "Female" & `Division Rank` %in% c(1:10) ~ 1,
                           Gender == "Male" & `Division Rank` %in% c(1:10) ~ 1,
                           .default = 0),
         quotient_model = case_when(Gender == "Female" ~ hms(`Overall Time`)/hms("8:10:34"),
                                    Gender == "Male" ~ hms(`Overall Time`)/hms("7:24:20")),
         y_hat = case_when(Gender == "Male" & quotient_model >= 1.041185 & quotient_model <= 1.089985 ~ 1,
                             Gender == "Female" & quotient_model >= 1.064823 & quotient_model <= 1.101243 ~ 1,
                             .default = 0),
         y = as.factor(y),
         y_hat = as.factor(y_hat)
        )

female_wr <- hms("8:10:34")
male_wr <- hms("7:24:20")

# idk if this worked.... even though it seems like it should?

ironman2 <- marathon |>
  select(Gender, Division, `Division Rank`, `Overall Time`, `Finish Status`) |>
  filter(Division %in% c("MPRO", "FPRO") & `Finish Status` == "Finisher") |>
  mutate(`Quotient Model` = case_when(Gender == "Female" ~ hms(`Overall Time`)/female_wr,
                                      Gender == "Male" ~ hms(`Overall Time`)/male_wr),
         Yhat = case_when(Gender == "Male" & dense_rank(`Quotient Model`) <= 10 ~ 1,
                       Gender == "Female" & dense_rank(`Quotient Model`) <= 7 ~ 1,
                       .default = 0)
         )


  # group_by(Gender) |>
  # mutate(y = ifelse(`Division Rank` <= 10, 1, 0),
  #        y_hat = ifelse(dense_rank(desc(`Quotient Model`)) <= 10, 1, 0)) |>
  # ungroup()

usethis::use_data(ironman, overwrite = TRUE)
