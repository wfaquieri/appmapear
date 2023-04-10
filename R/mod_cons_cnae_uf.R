#' cons_cnae_uf UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_cons_cnae_uf_ui <- function(id){
  ns <- NS(id)
  tagList(
    bs4Dash::bs4Card(
      title = "Filtros",
      status = 'info',
      background = 'gray-dark',
      solidHeader = TRUE,
      width = 4,
      icon = icon("filter"),

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

#' cons_cnae_uf Server Functions
#'
#' @noRd
mod_cons_cnae_uf_server <- function(id, res_auth){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

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

    # Create a connection to a DBMS
    con <- DBI::dbConnect(
      RPostgres::Postgres(),
      dbname = conn$db,
      host = conn$db_host,
      port = conn$db_port,
      user = conn$db_user,
      password = conn$db_pass
    )

    observeEvent(input$goButton1, {

      data <-  reactive({

        query_sql <-
          glue::glue_sql(
            "SELECT * FROM mvp_cons WHERE cnae_descr IN ({cnaes*}) AND uf IN ({states*})",
            cnaes = input$cnaeID,
            states = input$stateID,
            .con = con
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

