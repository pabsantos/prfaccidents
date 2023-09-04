library(data.table)
library(lubridate)

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

usethis::use_data(prf_accidents, overwrite = TRUE)
