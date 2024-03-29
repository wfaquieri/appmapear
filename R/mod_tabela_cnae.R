#' tabela_cnae UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_tabela_cnae_ui <- function(id) {
  ns <- NS(id)
  tagList(
    bs4Dash::box(
      title = "Consulta de Códigos CNAE - Tabela Completa",
      width = 12,
      icon = icon('table-list'),
      markdown(

        "Este sistema de busca permite: pesquisar códigos ou atividades econômicas na CNAE. O usuário pode encontrar, a partir da digitação da descrição de uma dada atividade ou de uma palavra-chave, os códigos das subclasses CNAE, que contêm as palavras digitadas, ou a partir da especificação de um código, o conjunto de atividades a ele associadas.

    A origem dos dados [IBGE](https://concla.ibge.gov.br/estrutura/atividades-economicas-estrutura/cnae.html).
    "
      ),
      br(),
      DT::DTOutput(ns("cnaes_table_id"))
    ))
}

#' tabela_cnae Server Functions
#'
#' @noRd
mod_tabela_cnae_server <- function(id, res_auth) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$cnaes_table_id <-
      DT::renderDT(
        cnaes,
        server = FALSE,
        extensions = c('Buttons', 'Responsive'),
        options = list(
          pageLength = 15,
          language = list(url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Portuguese-Brasil.json'),
          dom = 'Bfrtip',
          searchHighlight = TRUE,
          buttons = list(
            list(
              extend = 'excel',
              title = NULL,
              footer = FALSE
            )
          )
        )
      )
  })
}

