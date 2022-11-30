#' overview UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_overview_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      bs4Dash::bs4ValueBox(
        value = tags$p(tot$count |> prettyNum(big.mark = "."), style = "font-size: 250%;"),
        tags$p("Total de Empresas Ativas", style = "font-size: 110%;"),
        color = "info",
        elevation = NULL,
        width = 3,
        footer = "Matriz + Filial",
        href = NULL
      ),
      bs4Dash::bs4ValueBox(
        value = tags$p(nrow(df_cnae) |> prettyNum(big.mark = "."), style = "font-size: 250%;"),
        tags$p("Subclasses da CNAE", style = "font-size: 110%;"),
        color = "info",
        elevation = NULL,
        width = 3,
        footer = "Atividade Econômica",
        href = NULL
      ),
      bs4Dash::bs4ValueBox(
        value = tags$p("27", style = "font-size: 250%;"),
        tags$p("Estados + DF", style = "font-size: 110%;"),
        color = "info",
        elevation = NULL,
        width = 3,
        footer = "Abrangência Nacional",
        href = NULL
      ),
      bs4Dash::bs4ValueBox(
        value = tags$p(nrow(uf_cities) |> prettyNum(big.mark = "."), style = "font-size: 250%;"),
        tags$p("Municípios", style = "font-size: 110%;"),
        color = "info",
        elevation = NULL,
        width = 3,
        footer = "Nivel Municipal",
        href = NULL
      )
    ),
    bs4Dash::bs4Card(
      title = "TOP 10: CNAE X UF",
      label = "OS DEZ ESTADOS MAIS REPRESENTATIVOS POR ATIVIDADE ECONÔMICA.",
      status = 'gray-dark',
      background = 'white',
      solidHeader = TRUE,
      width = 12,
      icon = icon("fa-solid fa-magnifying-glass-chart"),

      # FILTRO CNAE
      selectizeInput(
        inputId = ns("cnaeID"),
        "CNAE:",
        choices = NULL,
        multiple = F
      ),

      # CHART
      echarts4r::echarts4rOutput(
        ns("plot_ativa_uf_id"),
        width = "100%",
        height = "400px"
      )
    ),
    bs4Dash::bs4Card(
      title = "CNAE X CIDADES",
      label = "OS MUNCÍPIOS MAIS REPRESENTATIVOS POR ATIVIDADE ECONÔMICA.",
      status = 'gray-dark',
      background = 'white',
      solidHeader = TRUE,
      width = 12,
      icon = icon("fa-solid fa-magnifying-glass-chart"),

      # FILTRO CNAE
      selectizeInput(
        inputId = ns("ufID"),
        "UF:",
        choices = NULL,
        multiple = F
      ),

      # CHART
      # echarts4r::echarts4rOutput(
      #   ns("plot_cnae_mun_id"),
      #   width = "100%",
      #   height = "400px"
      # )
      # TABLE
      reactable::reactableOutput(ns("table_cnae_mun_id"))
    )
  )
}

#' overview Server Functions
#'
#' @noRd
mod_overview_server <- function(id, res_auth){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    updateSelectizeInput(
      session,
      "cnaeID",
      "Atividade Econômica",
      choices = sort(unique(count1$cnae_descr)),
      selected = "4679699 - Comércio atacadista de materiais de construção em geral",
      server = TRUE
    )

    df_filtrado <- reactive(
      count1 |> dplyr::filter(cnae_descr==input$cnaeID)
    )

    output$plot_ativa_uf_id <- echarts4r::renderEcharts4r({
      df_filtrado() |>
        dplyr::arrange(count) |>
        dplyr::top_n(count, n = 10) |>
        echarts4r::e_chart(uf) |>
        echarts4r::e_bar(count, name = "Nº Empresas Ativas") |>
        echarts4r::e_legend(show = FALSE) |>
        echarts4r::e_flip_coords() |>
        echarts4r::e_tooltip(trigger = "axis") |>
        echarts4r::e_x_axis(axisLabel = list(interval = 0, rotate = 45)) |> # rotate
        echarts4r::e_theme_custom('{"color":["#17a2b8","#343a40"]}')
    })

    updateSelectizeInput(
      session,
      "ufID",
      "UF",
      choices = sort(unique(count2$uf)),
      selected = "RJ",
      server = TRUE
    )

    df_filtr <- reactive(
      count2 |> dplyr::filter(cnae_descr==input$cnaeID & uf==input$ufID) |>
        dplyr::arrange(count)
    )

    # output$plot_cnae_mun_id <-
    #   echarts4r::renderEcharts4r({
    #   df_filtr() |>
    #     dplyr::arrange(count) |>
    #     dplyr::top_n(count, n = 15) |>
    #     echarts4r::e_chart(municipio) |>
    #     echarts4r::e_bar(count, name = "Nº Empresas Ativas") |>
    #     echarts4r::e_legend(show = FALSE) |>
    #     echarts4r::e_flip_coords() |>
    #     echarts4r::e_tooltip(trigger = "axis") |>
    #     echarts4r::e_x_axis(axisLabel = list(interval = 0, rotate = 45)) |>
    #     echarts4r::e_y_axis(axisLabel = list(interval = 0, rotate = 25, margin='max')) |>
    #     echarts4r::e_theme_custom('{"color":["#17a2b8","#343a40"]}')
    # })

    # output$table_cnae_mun_id <-
    #   formattable::renderFormattable({
    #     formattable::formattable(df_filtr(),
    #                              list(count = formattable::color_bar("green")))
    #     })

    output$table_cnae_mun_id <- reactable::renderReactable({
      reactable::reactable(df_filtr(),
                           defaultSorted = list(count = "desc"),
                           defaultColDef = reactable::colDef(
                             cell = reactablefmtr::data_bars(
                               df_filtr(),
                               box_shadow = TRUE,
                               round_edges = TRUE,
                               text_position = "outside-base",
                               fill_color = c("lightblue","royalblue","navy"),
                               background = "#e5e5e5",
                               fill_gradient = TRUE
                             )
                           ))
    })

  })
}

