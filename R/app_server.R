#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  res_auth <- shinymanager::secure_server(
    check_credentials = shinymanager::check_credentials(credentials)
  )

  mod_sobre_server("sobre_1", res_auth)

  mod_cons_cnpj_server("cons_cnpj_1", res_auth)

  mod_cons_cnae_uf_server("cons_cnae_uf_1", res_auth)

  mod_cons_cnae_cidades_server("cons_cnae_cidades_1", res_auth)

  mod_overview_server("overview_1", res_auth)

  mod_tabela_cnae_server("tabela_cnae_1", res_auth)

  mod_layout_server("layout_1", res_auth)

}
