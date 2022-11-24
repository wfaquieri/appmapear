#' create_table
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd

create_table <- function(df, pageLength=5) {
  DT::renderDT(
    df,
    server = FALSE,
    rownames = FALSE,
    extensions = c('Buttons', 'Responsive'),
    options = list(
      initComplete = DT::JS('function(setting, json) { alert("Consulta executada com sucesso!"); }'),
      title = NULL,
      pageLength = pageLength,
      scrollX = TRUE,
      autoWidth = TRUE,
      dom = 'Bfrtip',
      class = "display compact nowrap",
      searchHighlight = TRUE,
      language = list(url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Portuguese-Brasil.json'),
      buttons = list(
        list(
          extend = 'excel',
          title = NULL,
          footer = FALSE
        )
      )
    )
  )
}
