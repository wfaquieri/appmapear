## code to prepare `DATASET` dataset goes here

uf_cities = readr::read_csv("data-raw/state_cities.csv")

df_cnae =
  readr::read_csv("data-raw/cnae_descr.csv") |>
  dplyr::mutate(cnae_descr = paste(cnae_fiscal, descricao, sep = " - "))

cnaes = readr::read_csv("data-raw/cnaes.csv")

usethis::use_data(uf_cities, overwrite = TRUE)
usethis::use_data(df_cnae, overwrite = TRUE)
usethis::use_data(cnaes, overwrite = TRUE)


