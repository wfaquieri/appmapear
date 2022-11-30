#' layout UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_layout_ui <- function(id){
  ns <- NS(id)
  tagList(
    bs4Dash::box(
      title = "Dicionário de Dados do Cadastro Nacional da Pessoa Jurídica",
      width = 12,
      icon = icon('table-list'),
      markdown(

        "O Cadastro Nacional da Pessoa Jurídica (CNPJ) é um banco de dados gerenciado pela Secretaria Especial da Receita Federal do Brasil (RFB), que armazena informações cadastrais das pessoas jurídicas e outras entidades de interesse das administrações tributárias da União, dos Estados, do Distrito Federal e dos Municípios.

    A origem dos dados [Portal de Dados Abertos](https://dados.gov.br/dados/conjuntos-dados/cadastro-nacional-da-pessoa-juridica-cnpj).
    "
      ),
      br(),
      DT::DTOutput(ns("layout_id"))
    )
  )
}

#' layout Server Functions
#'
#' @noRd
mod_layout_server <- function(id, res_auth){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$layout_id <-
      DT::renderDT(
        layout, options = list(
          pageLength = 15,
          language = list(url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Portuguese-Brasil.json')
        )
      )

  })
}

