library(data.table)

file_list <- paste0(
  "unzip -p data-raw/",
  list.files("data-raw", pattern = "^datatran")
)

sinistros_list <- lapply(file_list, fread, encoding = "Latin-1")

sinistros_list[[1]][, data_inversa := lubridate::dmy(data_inversa)]


rbindlist(sinistros_list, fill = TRUE)

usethis::use_data(sinistros, overwrite = TRUE)
