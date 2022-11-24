#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  mod_sobre_server("sobre_1")

  mod_cons_cnae_uf_server("cons_cnae_uf_1")

  mod_cons_cnae_cidades_server("cons_cnae_cidades_1")

  mod_tabela_cnae_server("tabela_cnae_1")
}
