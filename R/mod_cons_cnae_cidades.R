#' cons_cnae_cidades UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_cons_cnae_cidades_ui <- function(id){
  ns <- NS(id)
  tagList(
    # fluidRow(
      bs4Dash::bs4Card(
        title = "Filtros",
        status = 'info',
        background = 'gray-dark',
        solidHeader = TRUE,
        width = 4,
        icon = icon("fa-solid fa-filter"),

        # FILTRO CNAE
        selectizeInput(
          inputId = ns("cnaeID"),
          "CNAE:",
          choices = NULL,
          multiple = T
        ),

        # FILTRO UF
        helpText("Digite a UF de interesse. (Exemplo: SP)"),
        selectizeInput(
          inputId = ns("stateID"),
          "UF:",
          choices = NULL,
          multiple = F
        ),

        # FILTRO MUNICIPIO
        helpText(
          "A seguir, selecione quantos munícipios desejar ou apenas digite. Não incluir acento ou caracter especial. (Exemplo: SAO PAULO)"
        ),
        selectizeInput(
          inputId = ns("select"),
          "Municipio:",
          choices = NULL,
          multiple = T
        ),

        # BOTÃO PESQUISAR
        actionButton(inputId = ns("goButton1"), "Pesquisar"),
        br(),
        br(),
        shinyWidgets::progressBar(
          id = ns("pb4"),
          value = 0,
          display_pct = T

        )
      ),

      # TABELA
      bs4Dash::box(width = 12,
                   title = "TABELA - DADOS CADASTRAIS DE EMPRESAS",
                   DT::DTOutput(ns("dtable"))
                   )
    # )

  )
}


#' cons_cnae_cidades Server Functions
#'
#' @noRd
mod_cons_cnae_cidades_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    con <- DBI::dbConnect(
      RPostgres::Postgres(),
      dbname = db,
      host = db_host,
      port = db_port,
      user = db_user,
      password = db_pass
    )

    updateSelectizeInput(
      session,
      "cnaeID",
      "Atividade Econômica",
      choices = sort(unique(df_cnae$cnae_descr)),
      selected = sort(unique(df_cnae$cnae_descr))[1],
      server = TRUE
    )

    updateSelectizeInput(
      session,
      "stateID",
      "UF",
      choices = sort(unique(uf_cities$uf)),
      selected = sort(unique(uf_cities$uf))[1],
      server = TRUE
    )

    observeEvent(D1(), {
      updateSelectizeInput(
        session,
        "select",
        "Município",
        choices = sort(unique(D1()$descricao)),
        selected = sort(unique(D1()$descricao))[1],
        server = TRUE
      )
    })

    D1  <- reactive({
      uf_cities[uf_cities$uf %in% input$stateID, ]
    })

    D2 <- reactive({
      D1()[D1()$descricao %in% input$select, ]
    })

    observeEvent(input$goButton1, {
      # maxi <- 50
      # for (i in 1:maxi) {
      #   shinyWidgets::updateProgressBar(session = session,
      #                                   id = "pb4",
      #                                   value = (i / maxi) * 100)
      data <-  reactive({
        query_sql <-
          glue::glue_sql(
            "SELECT * FROM mvp_cons WHERE cnae_descr IN ({cnaes*}) AND uf IN ({states*}) AND municipio IN ({names*})",
            cnaes = input$cnaeID,
            states = input$stateID,
            names = input$select,
            .con = con
          )

        res <- DBI::dbGetQuery(con, query_sql)

        return(res)

      })

      output$dtable <- create_table({ data() })

      #   Sys.sleep(0.25)
      # }

    })
  })
}

## To be copied in the UI
#

## To be copied in the server
#
