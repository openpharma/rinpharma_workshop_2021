m_filter_ui <- function(id, data) {
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
          ADSL = data$ADSL,
          ADAE = data$ADAE,
          ADVS = data$ADVS
        )
      })
    }
  )
}
