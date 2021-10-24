m_filter_ui <- function(id) {
  ns <- NS(id)
  tags$form(
    class = "well",
    role = "complementary",
    "Filter Panel"
  )
}
m_filter_srv <- function(id, data) {
  moduleServer(
    id,
    function(input, output, session) {
      res <- reactive({
        list(
          adsl = data$adsl,
          adae = data$adae,
          advs = data$advs
        )
      })
    }
  )
}