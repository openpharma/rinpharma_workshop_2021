m_home_ui <- function(id) {
  ns <- NS(id)
  sidebarLayout(
    sidebarPanel(
      "Encoding panel",
      br(),
      "All the module specific inputs go here"
    ),
    mainPanel(
      "Main output goes here"
    )
  )
}
m_home_srv <- function(id, list_reactive_datasets) {
  moduleServer(
    id,
    function(input, output, session) {

    }
  )
}
