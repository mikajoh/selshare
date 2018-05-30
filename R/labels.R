
#' Treatment Variable Names in the Wave 8 Experiment
#'
#' Treatment variable names matched with the norwegian header labels
#' in the raw data for the experiment in wave 8.
#' 
#' @importFrom tibble tribble
#' 
#' @export
treat_names_w8 <- function() {
  tribble(
    ~treat_lab,                                  ~treat,
    "Religiøs tilhørighet",                      "prs_religion",
    "Vennskap",                                  "prs_friends",
    "Diskuterer eller skriver om politikk",      "prs_discuss",
    "Kjønn",                                     "prs_gender",
    "Popularitet",                               "prs_popularity",
    "Språkferdigheter",                          "prs_language",
    "Politisk standpunkt",                       "prs_party",
    "Kunnskap om politikk",                      "prs_polknow",
    "Vinkling i de ti siste delte nyhetssakene", "prs_shr_angle",
    "Tema i de ti siste delte nyhetssakene",     "prs_shr_theme",
    "Parti i de ti siste delte nyhetssakene",    "prs_shr_party"
  )
}

#' Treatment Variable Names in the Wave 9 Experiment
#'
#' Treatment variable names matched with the norwegian header labels
#' in the raw data for the experiment in wave 9
#' 
#' @importFrom tibble tribble
#' 
#' @export
treat_names_w9 <- function() {  
  tribble(
    ~treat_lab,           ~treat,
    "diskuterer_person",  "prs_discuss",
    "enighet_person",     "prs_agree",
    "kjonn_person",       "prs_gender",
    "kunnskap_person",    "prs_knowledge",
    "vennskap_person",    "prs_friends",
    "sprak_person",       "prs_language",
    "popularitet_person", "prs_popularity",
    "kilde_person",       "prs_hl_source",
    "omtale_person",      "prs_hl_comment",
    "overskrift_person",  "prs_hl_id"
  )
}

#' Value labels in the Wave 8 Experiment
#'
#' Value labels in english matched with the treatment variable and
#' norwegian labels in the raw data.
#' 
#' @importFrom tibble tribble
#' 
#' @export
val_labs_w8 <- function() {  
  tribble(
    ~treat,          ~val_no,                                             ~val,
    "prs_polknow",    "Lite kunnskap",                                    "A little knowledge",
    "prs_polknow",    "Mye kunnskap",                                     "A lot of knowledge",
    "prs_discuss",    "Av og til",                                        "Sometimes",
    "prs_discuss",    "Ofte",                                             "Often",
    "prs_discuss",    "Sjelden eller aldri",                              "Seldom or never",
    "prs_party",      "Høyre",                                            "Conservative Party (CR)",
    "prs_party",      "Venstre",                                          "Liberal Party (C)",
    "prs_party",      "Rødt",                                             "Red Party (FL)",
    "prs_party",      "Miljøpartiet De Grønne",                           "Green Party (C)",
    "prs_party",      "Senterpartiet",                                    "Agrarian Party (C)",
    "prs_party",      "Kristelig Folkeparti",                             "Christian Democrats (C)",
    "prs_party",      "Arbeiderpartiet",                                  "Labour Party (CL)",
    "prs_party",      "Sosialistisk Venstreparti",                        "Socialist Left Party (L)",
    "prs_party",      "Fremskrittspartiet",                               "Progress Party (FR)",
    "prs_religion",   "Kristendom",                                       "Christianity",
    "prs_religion",   "Ingen",                                            "None",
    "prs_religion",   "Islam",                                            "Islam",
    "prs_gender",     "Mann",                                             "Male",
    "prs_gender",     "Kvinne",                                           "Female",
    "prs_language",   "Skriver godt norsk",                               "Writes good norwegian",
    "prs_language",   "Skriver dårlig norsk",                             "Writes bad norwegian",
    "prs_popularity", "Få deler innleggene videre",                       "Few shares posts",
    "prs_popularity", "Mange deler innleggene videre",                    "Many shares posts",
    "prs_friends",    "Dere har bare hilst (gjennom arbeid eller skole)", "Met (through work or school)",
    "prs_friends",    "Dere har bare hilst, men har felles venner",       "Met (have common friends)",
    "prs_friends",    "Dere er nære venner",                              "Close friends",
    "prs_shr_angle",  "Du er for det mest uenig i vinklingen",            "Mostly disagree",
    "prs_shr_angle",  "Du er like mye enig som uenig med vinklingen",     "Equally agree and disagree",
    "prs_shr_angle",  "Du er for det meste enig i vinklingen",            "Mostly agree",
    "prs_shr_party",  "Sosialistisk Venstreparti har blitt nevnt mest",   "Socialist Left Party (L)",
    "prs_shr_party",  "Kristelig Folkeparti har blitt nevnt mest",        "Christian Democrats (C)",
    "prs_shr_party",  "Høyre har blitt nevnt mest",                       "Conservative Party (CR)",
    "prs_shr_party",  "Rødt har blitt nevnt mest",                        "Red Party (FL)",
    "prs_shr_party",  "Fremskrittspartiet har blitt nevnt mest",          "Progress Party (FR)",
    "prs_shr_party",  "Venstre har blitt nevnt mest",                     "Liberal Party (C)",
    "prs_shr_party",  "Senterpartiet har blitt nevnt mest",               "Agrarian Party (C)",
    "prs_shr_party",  "Arbeiderpartiet har blitt nevnt mest",             "Labour Party (CL)",
    "prs_shr_party",  "Miljøpartiet De Grønn har blitt nevnt mest",       "Green Party (C)",
    "prs_shr_theme",  "Straffesaker og dødsstraff",                       "Crime and punishment",
    "prs_shr_theme",  "Innvandring",                                      "Immigration",
    "prs_shr_theme",  "Økonomi og skattepolitikk",                        "The economy and tax policies",
    "prs_shr_theme",  "EU og europeisk politikk",                         "EU and european politics",
    "prs_shr_theme",  "Homofile rettigheter",                             "Gay rights"
  )  
}

#' Value labels in the Wave 9 Experiment
#'
#' Value labels in english matched with the treatment variable and
#' norwegian labels in the raw data.
#' 
#' @importFrom tibble tribble
#' 
#' @export
val_labs_w9 <- function() {
  tribble(
    ~treat,           ~val_num, ~val,
    "prs_gender",     0,        "Male",
    "prs_gender",     1,        "Female",
    "prs_language",   0,        "Writes bad norwegian",
    "prs_language",   1,        "Writes good norwegian",
    "prs_knowledge",  0,        "A little knowledge",
    "prs_knowledge",  1,        "A lot of knowledge",
    "prs_popularity", 0,        "Few shares posts",
    "prs_popularity", 1,        "Many shares posts",
    "prs_friends",    0,        "Close friends",
    "prs_friends",    1,        "Met (have common friends",
    "prs_friends",    2,        "Met (through workorschool)",
    "prs_agree",      0,        "Mostly agree",
    "prs_agree",      1,        "Mostly disagree",
    "prs_agree",      2,        "Equally agree and disagree",
    "prs_discuss",    0,        "Often",
    "prs_discuss",    1,        "Sometimes",
    "prs_discuss",    2,        "Seldom or never",
    "prs_hl_comment", 0,        "'Could not have agreed more'",
    "prs_hl_comment", 1,        "'Could not have disagreed more'",
    "prs_hl_comment", 2,        "'Worst article ever read'",
    "prs_hl_comment", 3,        "'Best article ever read'",
    "prs_hl_source",  0,        "NRK",
    "prs_hl_source",  1,        "TV2",
    "prs_hl_source",  2,        "Aftenposten",
    "prs_hl_source",  3,        "Dagens Næringsliv",
    "prs_hl_source",  4,        "Klassekampen"
  )  
}
