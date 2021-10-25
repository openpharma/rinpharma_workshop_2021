m_tables_dm_ui <- function(id) {
  ns <- NS(id)
  sidebarLayout(
    sidebarPanel(
      textInput(
        ns("title"),
        "Title"
      ),
      textInput(
        ns("subtitle"),
        "Subtitle"
      ),
      textInput(
        ns("main_footer"),
        "Main Footer"
      )
    ),
    mainPanel(
      uiOutput(ns("table"))
    )
  )
}
m_tables_dm_srv <- function(id, list_reactive_datasets) {
  moduleServer(
    id,
    function(input, output, session) {
      output$table <- renderUI({
        rtables::as_html(
          t_dm(list_reactive_datasets$ADSL(), title = input$title, subtitle = input$subtitle, main_footer = input$main_footer)
        )
      })
    }
  )
}
