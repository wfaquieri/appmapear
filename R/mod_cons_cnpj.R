#' cons_cnpj UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_cons_cnpj_ui <- function(id){
  ns <- NS(id)
  tagList(
    bs4Dash::bs4Card(
      title = "Filtros",
      status = 'info',
      background = 'gray-dark',
      solidHeader = TRUE,
      width = 4,
      icon = icon("fa-solid fa-filter"),

      # FILTRO UF
      helpText("Digite o CNPJ de interesse: (Exemplo: 29593377000183)"),
      textInput(
        inputId = ns("cnpjID"),
        "CNPJ:",
        value = "",
        width = NULL,
        placeholder = NULL
      ),

      # BOTÃO PESQUISAR
      actionButton(inputId = ns("goButton1"), "Pesquisar")
    ),

    # TABELA
    bs4Dash::box(width = 12,
                 title = "TABELA - DADOS CADASTRAIS DE EMPRESAS",
                 DT::DTOutput(ns("dtable"))
    )
  )
}

#' cons_cnpj Server Functions
#'
#' @noRd
mod_cons_cnpj_server <- function(id, res_auth){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observeEvent(input$goButton1, {

      data <-  reactive({

        query_sql <-
          glue::glue_sql(
            "SELECT * FROM mvp_cons WHERE cnpj IN ({cnpjs*})",
            cnpjs = input$cnpjID,
            .con = conn
          )

        id <- showNotification("Executando a query...",
                               duration = NULL,
                               type = "message",
                               closeButton = FALSE)

        on.exit(removeNotification(id), add = TRUE)

        res <- DBI::dbGetQuery(con, query_sql)

        return(res)

      })

      output$dtable <-  create_table({ data() })

    })
  })
}
