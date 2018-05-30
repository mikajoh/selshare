## Mikael Poul Johannesson
## 2018

## Start matter ------------------------------------------------------

library(here)
library(haven)
library(readxl)
library(tidyverse)

## Load data ---------------------------------------------------------

## NCP wave 1-7 combined file.
## Md5sum: b1995a87fca30e9f42388bde2128777c
## tools::md5sum(here("data", "Norwegian citizen panel - wave 1-7 EN.sav"))
w17_raw <- read_sav(
  here("raw", "Norwegian citizen panel - wave 1-7 EN.sav")
)

## Variable recoding scheme. It is an overview of the variablees
## across waves, showing which wave and new variable name to use when
## recoding to long (tidy) format.
## Md5sum: afa842c6edc8dc2e60c44ca425aa7cf0
## tools::md5sum(here("raw", "ncp_rsp_w17_vars.csv"))
vars <- read.csv(
  here("raw", "ncp_rsp_w17_vars.csv"),
  stringsAsFactors = FALSE
)

## Reshape to long (tidy) format -------------------------------------

## Variables names and wave to join.

## Responses with 96, 97, etc., are missing values.
for (val in c(96, 97, 98, 99, 999))
  w17_raw[w17_raw == val] <- NA

## Time-constant variables.
vars_constant <- vars$variable[vars$time_constant == 1]
ncp_constant <-
  w17_raw %>%
  select(responseid, one_of(vars_constant)) %>%
  gather(variable, value, -responseid, na.rm = TRUE) %>%
  left_join(vars, by = "variable") %>% # if there are data from several
  arrange(wave) %>%                    # waves, then keep the most recent
  group_by(responseid, id) %>%         # one
  summarize(value = last(value)) %>%
  ungroup() %>%
  spread(id, value)

## Time-varying variables
vars_varying <- vars$variable[vars$time_constant == 0]
ncp_varying <-
  w17_raw %>%
  select(responseid, one_of(vars_varying)) %>%
  gather(variable, value, -responseid) %>%
  left_join(vars, by = "variable") %>%
  select(-variable) %>%
  spread(id, value)

## The full data set. The variables indicating when the respondent
## were recruited are coded differently pre/post wave 3. Also, the
## voting variable were split in two in one wave for some
## reason. Missing subgroup means resp did not participate in that
## wave.
ncp_w17_full <-
  full_join(
    ncp_constant,
    ncp_varying,
    by = "responseid"
  ) %>%
  filter(!is.na(subgroup)) %>%
  mutate(
    recruited = case_when(
      !is.na(recruited)  ~ recruited,
      wave %in% 1:2      ~ 1,
      recruited_w01 == 1 ~ 1,
      recruited_w03 == 1 ~ 3),
    voted_party_2013 = ifelse(
      is.na(voted_party_2013), voted_party_2013_2,
      voted_party_2013),
    would_vote_party = ifelse(
      is.na(would_vote_party), would_vote_party_2,
      would_vote_party)
  ) %>%
  select(
    -recruited_w01, -recruited_w03,
    -voted_party_2013_2, -would_vote_party_2) %>%
  mutate_at(
    unique(vars$id[vars$reverse_scale == 1]),
    function(x) min(x, na.rm = TRUE) + max(x, na.rm = TRUE) - x) %>%
  mutate(responseid = as.integer(responseid))

## Adapt for the need of the experiment ------------------------------

## Only select the variables needed for the analyses; Keep last
## observed value to match treatment (headline) on; Recode variables
## as used in the analyses; Add resp_ before name to signal unit
## level.
w17 <-
  ncp_w17_full %>%
  select(
    responseid, wave, mobile,                   # paradata
    age, gender, education, political_interest, # ses
    matches("like_"), would_vote_party,         # pary pref
    ref_social_rights, reduce_ineq, eq_rights,  # attitudes to match on
    allow_priv, lower_taxes, not_allow_love,
    priv_better, rel_div_good
  ) %>%
  gather(variable, value, -responseid, -wave) %>%
  arrange(wave) %>%
  group_by(responseid, variable) %>%
  summarize(value = last(value)) %>%
  ungroup() %>%
  spread(variable, value) %>%
  mutate(
    gender = case_when(
      gender == 1 ~ "Male",
      gender == 2 ~ "Female"),
    polint = case_when(
      political_interest > 3 ~ "Interested in politics",
      political_interest < 4 ~ "Not interested in politics"),
    polside = case_when(                # rød sv ap vs. høyre frp
      would_vote_party %in% c(5, 8, 9) ~ "Respondents on\nthe left",
      would_vote_party %in% c(2, 3)    ~ "Respondents on\nthe right")
  ) %>%
  rename_at(vars(-responseid), function(x) paste0("rsp_", x)) %>%
  rename(rsp_id = responseid)

## Save data ---------------------------------------------------------

write.csv(
  x = w17,
  file = here("data", "ncp_rsp_w17.csv"),
  row.names = FALSE
)
