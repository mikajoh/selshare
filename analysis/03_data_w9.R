## Mikael Poul Johannesson
## 2018

## Start matter ------------------------------------------------------

library(here)
library(haven)
library(tidyverse)

## Load data ---------------------------------------------------------

## Prepared data from the Norwegian Citizen Panel on the respondents
## from wave 1 through 7. Generated with `01_data_rsp.R`.
## Md5sum: 93fe0067d8bdc6f129dceddb11c65f0c
## tools::md5sum(here("data", "w17_rsp_data.csv"))
w17 <- read.csv(
  here("data", "ncp_rsp_w17.csv"),
  stringsAsFactors = FALSE
)

## The Norwegian Citizen Panel, Wave 9
## Md5sum: 74d22c43548599e69ea50b78f8630ce3
## tools::md5sum(here("raw", "Norwegian Citizen Panel - wave 9 EN.sav"))
w9_raw <- read_sav(
  here("raw", "Norwegian Citizen Panel - wave 9 EN.sav")
)

## Data on treatments included in the headlines in wave 9.
## Md5sum: 00db67a4fed2d4e6c9560a509a6441ad
## tools::md5sum(here("raw", "headlines_w9.csv"))
headlines_w9 <- read.csv(
  here("raw", "headlines_w9.csv"),
  stringsAsFactors = FALSE
)

## Prep party favorability -------------------------------------------

rsp_party <-
  w17 %>%
  select(rsp_id, matches("rsp_like_")) %>%
  gather(rsp_party, like, matches("rsp_like_"), na.rm = TRUE) %>%
  mutate(
    rsp_party = case_when(
      rsp_party == "rsp_like_ap"   ~ "Labour party (CL)",
      rsp_party == "rsp_like_frp"  ~ "Progress party (FR)",
      rsp_party == "rsp_like_h"    ~ "Conservative party (CR)",
      rsp_party == "rsp_like_krf"  ~ "Christian Democratic party (C)",
      rsp_party == "rsp_like_mdg"  ~ "Green party (C)",
      rsp_party == "rsp_like_rodt" ~ "Red party (FL)",
      rsp_party == "rsp_like_sp"   ~ "Agrarian party (C)",
      rsp_party == "rsp_like_sv"   ~ "Socialist Left party (L)",
      rsp_party == "rsp_like_v"    ~ "Liberal party (C)")
  )

## Prep wave 9 experiment --------------------------------------------

w9_01 <-
  w9_raw %>%
  mutate(
    rsp_id = as.integer(responseid),
    rsp_age = as.numeric(R9P5_1),
    rsp_age_cat = case_when(
      R9P5_2 == 1 ~ "18-29 yrs",
      R9P5_2 == 2 ~ "30-59 yrs",
      R9P5_2 == 3 ~ "60 yrs and above"),
    rsp_gender = case_when(
      R9P1 == 1 ~ "Male",
      R9P1 == 2 ~ "Female"),
    rsp_edu = case_when(
      R9P4_1 == 1 ~ "Lower or intermediate",
      R9P4_1 == 2 ~ "Lower or intermediate",
      R9P4_1 == 3 ~ "Higher"),
    rsp_party = case_when(
      r9k204 == 1 ~ "Christian Democratcs (C)",
      r9k204 == 2 ~ "Conservative Party (CR)",
      r9k204 == 3 ~ "Progress Party (FR)",
      r9k204 == 4 ~ "Liberal Party (C)",
      r9k204 == 5 ~ "Socialist Left Party (L)",
      r9k204 == 6 ~ "Agrarian Party (C)",
      r9k204 == 7 ~ "Green Party (C)",
      r9k204 == 8 ~ "Labour Party (CL)",
      r9k204 == 9 ~ "Red Party (FL)"),
    rsp_polscale = case_when(
      r9k8_1 %in% 1:11 ~ as.numeric(r9k8_1)),
    rsp_polside = case_when(
      rsp_polscale %in% 1:5  ~ "Left",
      rsp_polscale == 6      ~ "Centre",
      rsp_polscale %in% 7:11 ~ "Right"),
    rsp_polint = case_when(
      r9k1 %in% 1:5 ~ 6 - as.numeric(r9k1)),
    rsp_para_phone = case_when(
      mobil == 1 ~ "Used smart phone",
      mobil == 0 ~ "Did not use smart phone")
  )

w9_02 <-
  w9_01 %>%
  gather(
    exp_version, exp_post,
    r9selexp2_1a, r9selexp2_1b, r9selexp2_2a, r9selexp2_2b,
    na.rm = TRUE
  ) %>%
  mutate(
    exp_post = ifelse(exp_post %in% 97:98, NA, exp_post),
    exp_type = case_when(
      exp_version %in% c("r9selexp2_1a", "r9selexp2_2a") ~ "Read",
      exp_version %in% c("r9selexp2_1b", "r9selexp2_2b") ~ "Share"),
    exp_version = case_when(
      exp_version %in% c("r9selexp2_1a", "r9selexp2_1b") ~ "Person and headline",
      exp_version %in% c("r9selexp2_2a", "r9selexp2_2b") ~ "Person, headline, and comment")
    ) %>%
  filter(!is.na(exp_post)) %>%
  select(matches("rsp_"), matches("exp_"), matches("r9selexp2")) %>%
  select(-r9selexp2_ran, -matches("r9selexp2_sporsmal_"))

w9_03 <-
  w9_02 %>%
  gather(var, val_num, matches("r9selexp2_\\w+_\\w+\\d"), na.rm = TRUE) %>%
  mutate(
    prs_n = as.numeric(gsub("r9selexp2_\\w+_\\w+(\\d)", "\\1", var)),
    treat_lab = gsub("r9selexp2_(\\w+_\\w+)\\d", "\\1", var)
  ) %>%
  left_join(treat_names_w9(), by = "treat_lab") %>%
  left_join(val_labs_w9(), by = c("treat", "val_num")) %>%
  mutate(val = ifelse(treat == "prs_hl_id", val_num, val)) %>%  
  select(matches("rsp_"), matches("exp_"), matches("prs_"), treat, val) %>%  
  spread(treat, val) %>%
  mutate(
    prs_post = case_when(
      exp_post == prs_n ~ 1,
      exp_post != prs_n ~ 0
    ),
    prs_hl_id = as.numeric(prs_hl_id)
  )

w9_04 <-
  w9_03 %>%
  left_join(
    headlines_w9 %>% set_names(paste0("prs_", names(headlines_w9))),
    by = "prs_hl_id"
  ) %>%
  left_join(
    w17 %>%
      select(
        rsp_id, matches("rsp_like_"),
        one_of(paste0("rsp_", unique(headlines_w9$hl_opinion)))),
    by = "rsp_id"
  ) %>%    
  match_prs_hl_with_rsp() %>%
  recode_hl() %>%
  select(matches("rsp_"), matches("exp_"), matches("prs_"))

w9 <- w9_04



match_prs_hl_with_rsp <- function(data) {

  raw <-
    data %>%
    rowwise() %>%
    mutate(
      prs_hl_matched_att_raw = ifelse(
        is.na(prs_hl_opinion), NA,
        get(paste0("rsp_", prs_hl_opinion))),
      prs_hl_matched_party_raw = ifelse(
        prs_hl_party == "none" | is.na(prs_hl_party), NA,
        get(paste0("rsp_like_", prs_hl_party)))
    ) %>%
    ungroup()

  recoded <-
    raw %>%
    mutate(
      prs_hl_matched_att = case_when(
        prs_hl_direction == "agree"    ~ as.integer(prs_hl_matched_att_raw),
        prs_hl_direction == "disagree" ~ as.integer(8 - prs_hl_matched_att_raw)),
      prs_hl_matched_att_dir = case_when(
        prs_hl_matched_att_raw > 4  ~ "agree",
        prs_hl_matched_att_raw < 4  ~ "disagree"),
      prs_hl_matched_att_cat = case_when(
        prs_hl_matched_att_raw == 4                ~ "Neither",
        prs_hl_direction == prs_hl_matched_att_dir ~ "Attitude consistent",
        prs_hl_direction != prs_hl_matched_att_dir ~ "Attitude inconsistent"),
      prs_hl_matched_party = prs_hl_matched_party_raw,
      prs_hl_matched_party_cat = case_when(
        prs_hl_matched_party_raw > 4  ~ "Likes party",
        prs_hl_matched_party_raw == 4 ~ "Neither",
        prs_hl_matched_party_raw < 4  ~ "Dislikes party"),
      prs_hl_matched_source = case_when(
        prs_hl_source != "Klassekampen" ~ as.character(NA),
        rsp_polside == "Right"          ~ "Klassekampen (right)",
        rsp_polside == "Left"           ~ "Klassekampen (left)")
    )

  recoded
}


recode_hl <- function(data) {
  data %>%
    mutate(
      prs_hl_opinion = case_when(
        prs_hl_opinion == "allow_priv"     ~ "Commercialize public schools",
        prs_hl_opinion == "eq_rights"      ~ "Increase gay rights",
        prs_hl_opinion == "lower_taxes"    ~ "Reduce taxes",
        prs_hl_opinion == "not_allow_love" ~ "Ban offshore drilling in the North",
        prs_hl_opinion == "priv_better"    ~ "Privatize public servies",
        prs_hl_opinion == "rel_div_good"   ~ "Religous diversity is a good thing",
        prs_hl_opinion == "resp_reduce_ineq" ~ "The state should reduce income inequality"),
      prs_hl_party_nor = case_when(
        prs_hl_party == "ap"   ~ "Ap",
        prs_hl_party == "frp"  ~ "Frp",
        prs_hl_party == "h"    ~ "Høyre",
        prs_hl_party == "krf"  ~ "Krf",
        prs_hl_party == "mdg"  ~ "Mdg",
        prs_hl_party == "rodt" ~ "Rødt",
        prs_hl_party == "sp"   ~ "Sp",
        prs_hl_party == "sv"   ~ "Sv",
        prs_hl_party == "v"    ~ "Venstre"),
      prs_hl_direction = case_when(
        prs_hl_direction == "agree"    ~ "Support",
        prs_hl_direction == "disagree" ~ "Oppose"),
      prs_hl_valance = case_when(
        prs_hl_valance == "negative" ~ "Negative",
        prs_hl_valance == "neutral"  ~ "Neutral",
        prs_hl_valance == "positive" ~ "Positive"),
      prs_hl_message_cue = case_when(
        prs_hl_matched_att_cat == "Attitude consistent"   ~ "Attitude consistent",
        prs_hl_matched_att_cat == "Attitude inconsistent" ~ "Attitude inconsistent"),
      prs_hl_party_cue = case_when(
        prs_hl_matched_party_cat == "Dislikes party" ~ "Dislikes party",
        prs_hl_matched_party_cat == "Likes party"    ~ "Likes party"),
      prs_hl_source_cue = prs_hl_matched_source
    )
}

## Write data to file ------------------------------------------------

write.csv(
  w9,
  file = here("data", "ncp_exp_w9.csv"),
  row.names = FALSE
)
