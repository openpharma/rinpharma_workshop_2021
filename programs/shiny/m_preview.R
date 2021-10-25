m_preview_single_ui <- function(id) {
  ns <- NS(id)
  DT::dataTableOutput(ns("table"))
}
m_preview_single_srv <- function(id, dataset) {
  moduleServer(
    id,
    function(input, output, session) {
      output$table <- DT::renderDataTable(dataset(), options=list(scrollX=T))
    }
  )
}

m_preview_ui <- function(id) {
  ns <- NS(id)
  tabsetPanel(
    tabPanel("ADSL", m_preview_single_ui(ns("ADSL"))),
    tabPanel("ADAE", m_preview_single_ui(ns("ADAE"))),
    tabPanel("ADVS", m_preview_single_ui(ns("ADVS")))
  )
}
m_preview_srv <- function(id, list_reactive_datasets = list()) {
  moduleServer(
    id,
    function(input, output, session) {
      m_preview_single_srv("ADSL", list_reactive_datasets$ADSL)
      m_preview_single_srv("ADAE", list_reactive_datasets$ADAE)
      m_preview_single_srv("ADVS", list_reactive_datasets$ADVS)
    }
  )
}
