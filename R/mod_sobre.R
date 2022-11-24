#' sobre UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_sobre_ui <- function(id){
  ns <- NS(id)
  tagList(

    bs4Dash::bs4Card(
      title = "Sobre",
      status = 'gray',
      background = 'gray-dark',
      solidHeader = TRUE,
      width = 10,
      icon = icon("fa-solid fa-house-user"),
      markdown(
        "
    ## app_MapeaR

    <!-- badges: start -->
    [![Lifecycle:
    experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
    <!-- badges: end -->

    Essa ferramenta tem por objetivo democratizar o acesso a base de dados da Receita Federal no âmbito da SPDO, atendendo as demandas de mapeamento e cadastro, bem como estimativas de amostras com empresas válidas e outros tipos de prospeções comerciais.

    Através de uma interface amigável e de fácil acesso o `<app>` permite a consulta de dados cadastrais de milhões de empresas ativas.

    Até a presente versão, a consulta ao banco de dados pode ser realizada a partir:

    * do cnpj >> Módulo: CNPJ - Empresa
    * da atividade econômica e da unidade fedrativa >> Módulo: CNAE & UF
    * da atividade econômica e a nível municipal >> Módulo: CNAE & Cidades

    Os dados foram obtidos em [Dados Públicos CNPJ - Receita Federal](https://www.gov.br/receitafederal/pt-br/assuntos/orientacao-tributaria/cadastros/consultas/dados-publicos-cnpj) e atualizados em 20/07/2022 .
    "),
      hr()
    )
  )
}

#' sobre Server Functions
#'
#' @noRd
mod_sobre_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}


