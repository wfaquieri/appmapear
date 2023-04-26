
# Atualizando os quantitativos para o modulo 'OVERVIEW'

load("C:/Users/winicius.faquieri/OneDrive - FGV/Área de Trabalho/appmapear/data/conn.rda")

query <- "SELECT COUNT(DISTINCT cnpj) FROM mvp_cons;"

tot <- DBI::dbGetQuery(conn, query)

usethis::use_data(tot, overwrite = TRUE)

query <- "SELECT cnae_descr, uf, COUNT(*) FROM mvp_cons GROUP BY cnae_descr, uf;"

count1 = DBI::dbGetQuery(conn, query)

usethis::use_data(count1, overwrite = TRUE)

query <- "SELECT cnae_descr, uf, municipio, COUNT(*) FROM mvp_cons GROUP BY cnae_descr, uf, municipio;"

count2 = DBI::dbGetQuery(conn, query)

usethis::use_data(count2, overwrite = TRUE)

DBI::dbDisconnect(conn)
