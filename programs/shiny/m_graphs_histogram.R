m_graphs_histogram_ui <- function(id) {
    ns <- NS(id)
    "Histogram"
}
m_graphs_histogram_srv <- function(id, data_rv = reacrive({})) {
  moduleServer(
    id,
    function(input, output, session) {

    }
  )
}