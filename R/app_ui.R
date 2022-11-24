#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    bs4Dash::bs4DashPage(

      tags$link(rel = "stylesheet", href = "inst/app/www/custom.css"),

      # BARRA DE NAVEGAÇÃO
      header = bs4Dash::bs4DashNavbar(
        title = bs4Dash::dashboardBrand(
          title = "APP_MAPEAR",
          color = "gray-dark",
          href = "https://portalibre.fgv.br/quem-somos",
          image = "www/company_22169.png",
          opacity = 1.0
        ),
        titleWidth = NULL,
        disable = FALSE,
        skin = "light",
        status = "gray-dark",
        compact = FALSE,
        sidebarIcon = shiny::icon("bars"),
        controlbarIcon = shiny::icon("bars"),
        fixed = FALSE
      ),

      # BARRA LATERAL
      sidebar = bs4Dash::bs4DashSidebar(
        disable = FALSE,
        skin = "light",
        status = "info",
        bs4Dash::bs4SidebarMenu(
          id = "sidebarMenu",
          bs4Dash::bs4SidebarMenuItem(
            text = "Home",
            startExpanded = TRUE,
            icon = icon("fa-solid fa-house-user"),
            bs4Dash::bs4SidebarMenuSubItem(
              text = "Sobre",
              tabName = "about_id",
              href = NULL,
              newTab = NULL,
              icon = shiny::icon("angle-double-right"),
              selected = NULL
            )
          ),
          bs4Dash::bs4SidebarMenuItem(
            text = "Consulta",
            startExpanded = TRUE,
            icon = icon("fa-solid fa-magnifying-glass"),
            bs4Dash::bs4SidebarMenuSubItem(
              text = "CNPJ",
              tabName = "cons_1_id",
              href = NULL,
              newTab = NULL,
              icon = shiny::icon("angle-double-right"),
              selected = NULL
            ),
            bs4Dash::bs4SidebarMenuSubItem(
              text = "CNAE & UF",
              tabName = "cons_2_id",
              href = NULL,
              newTab = NULL,
              icon = shiny::icon("angle-double-right"),
              selected = NULL
            ),
            bs4Dash::bs4SidebarMenuSubItem(
              text = "CNAE & Cidades",
              tabName = "cons_3_id",
              href = NULL,
              newTab = NULL,
              icon = shiny::icon("angle-double-right"),
              selected = NULL
            )
          ),
          bs4Dash::bs4SidebarMenuItem(
            text = "Overview",
            startExpanded = TRUE,
            icon = icon("fa-solid fa-magnifying-glass-chart"),
            bs4Dash::bs4SidebarMenuSubItem(
              text = "Quantitativos",
              tabName = "quant_id",
              href = NULL,
              newTab = NULL,
              icon = shiny::icon("angle-double-right"),
              selected = NULL
            )
          ),
          bs4Dash::bs4SidebarMenuItem(
            text = "Códigos CNAE",
            startExpanded = TRUE,
            icon = icon("fa-solid fa-table-list"),
            bs4Dash::bs4SidebarMenuSubItem(
              text = "Tabela Completa",
              tabName = "tabcnae_id",
              href = NULL,
              newTab = NULL,
              icon = shiny::icon("angle-double-right"),
              selected = NULL
            )
          ),
          bs4Dash::bs4SidebarMenuItem(
            text = "Layout",
            startExpanded = TRUE,
            icon = icon("fa-solid fa-spell-check"),
            bs4Dash::bs4SidebarMenuSubItem(
              text = "Dicionário de Dados",
              tabName = "layout_id",
              href = NULL,
              newTab = NULL,
              icon = shiny::icon("angle-double-right"),
              selected = NULL
            )
          )
        )),

      # CORPO DO DASH
      body = bs4Dash::bs4DashBody(
        bs4Dash::bs4TabItems(
          bs4Dash::bs4TabItem(
            tabName = "about_id",
            mod_sobre_ui("sobre_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "cons_1_id",
            # mod_consulta_ui("consulta_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "cons_2_id",
            mod_cons_cnae_uf_ui("cons_cnae_uf_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "cons_3_id",
            mod_cons_cnae_cidades_ui("cons_cnae_cidades_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "quant_id",
            # mod_cons_cnae_mun_ui("cons_cnae_mun_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "tabcnae_id",
            mod_tabela_cnae_ui("tabela_cnae_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "layout",
            # mod_cons_cnae_mun_ui("cons_cnae_mun_1")
          )
        ),
        fresh::use_theme(
          fresh::create_theme(
            fresh::bs4dash_font(size_base = "0.9rem",
                                weight_bold = 700)
          )
        )
      ),

      # FOOTER
      controlbar = NULL,
      footer = bs4Dash::bs4DashFooter(
        left = a(
          href = "https://portalibre.fgv.br/quem-somos",
          target = "_blank", # open in a new tab
          "Termos de uso © Copyright 2020 IBRE. Todos os direitos reservados."
        )
      ),
      freshTheme = NULL,
      dark = NULL,
      fullscreen = TRUE
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "FGV/IBRE: MAPEAMENTO"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
