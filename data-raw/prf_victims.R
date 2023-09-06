library(data.table)

file_list <- paste0(
  "unzip -p data-raw/",
  list.files("data-raw", pattern = "^acidentes")
)

victims_list <- lapply(file_list, fread, encoding = "Latin-1")

usethis::use_data(prf_victims, overwrite = TRUE)
