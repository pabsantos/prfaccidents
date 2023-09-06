library(data.table)
library(lubridate)
library(magrittr)

file_list <- paste0(
  "unzip -p data-raw/",
  list.files("data-raw", pattern = "^datatran")
)

accidents_list <- lapply(file_list, fread, encoding = "Latin-1")

fix_date <- function(accidents) {
  if (!is.Date(accidents$data_inversa)) {
    accidents[, data_inversa := dmy(data_inversa)]
  } else {
    accidents[, data_inversa := ymd(data_inversa)]
  }
}

lapply(accidents_list, fix_date)

prf_accidents <- rbindlist(accidents_list, fill = TRUE)

prf_accidents[, id := as.character(id)]

prf_accidents[
  , 
  dia_semana := wday(
    data_inversa,
    locale = "pt_BR.UTF-8",
    label = TRUE,
    abbr = FALSE
  )
]

prf_accidents[uf == "(null)", uf := NA]

prf_accidents[br == "(null)", br := NA]

prf_accidents[, causa_acidente := tolower(causa_acidente)]
prf_accidents[causa_acidente == "(null)", causa_acidente := NA]

prf_accidents[tipo_acidente == "", tipo_acidente := NA]

prf_accidents[
  classificacao_acidente %in% c("", "(null)"),
  classificacao_acidente := NA
]

prf_accidents[fase_dia %in% c("", "(null)"), fase_dia := NA][
  , fase_dia := tolower(fase_dia)]

prf_accidents %>% 
  .[
    condicao_metereologica %in% c("", "(null)"),
    condicao_metereologica := NA
  ] %>% 
  .[, condicao_metereologica := tolower(condicao_metereologica)] %>% 
  .[
    condicao_metereologica == "ignorado",
    condicao_metereologica := "ignorada"
  ] %>% 
  .[
    condicao_metereologica == "céu claro",
    condicao_metereologica := "ceu claro"
  ]

prf_accidents[tipo_pista == "(null)", tipo_pista := NA]

prf_accidents[tracado_via %in% c("(null)", "Não Informado"), tracado_via := NA]

prf_accidents[uso_solo == "Sim"]

prf_accidents$uso_solo %>% table()

usethis::use_data(prf_accidents, overwrite = TRUE)


