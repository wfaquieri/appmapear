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

      # BOTÃO PESQUISAR
      actionButton(inputId = ns("goButton1"), "Pesquisar"),
      br(),
      br(),
      bs4Dash::progressBar(
        id = ns("pb4"),
        value = 0,
        display_pct = T
      )
    ),

    # TABELA
    DT::DTOutput(ns("dtable"))
  )
}

#' cons_cnae_uf Server Functions
#'
#' @noRd
mod_cons_cnae_uf_server <- function(id){
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

    observeEvent(input$goButton1, {



        data <-  reactive({
          query_sql <-
            glue::glue_sql(
              "SELECT * FROM mvp_cons WHERE cnae_descr IN ({cnaes*}) AND uf IN ({states*})",
              cnaes = input$cnaeID,
              states = input$stateID,
              .con = con
            )

          res <- DBI::dbGetQuery(con, query_sql)

          return(res)

        })

        output$dtable <- create_table({
          data()
        })

        maxi <- 50
        for (i in 1:maxi) {
          shinyWidgets::updateProgressBar(session = session,
                                          id = "pb4",
                                          value = (i / maxi) * 100)

        Sys.sleep(0.5)
      }

    })
  })
}

