source("shiny/m_graphs_histogram.R")
source("shiny/m_graphs_scatterplot.R")

m_graphs_ui <- function(id) {
    ns <- NS(id)
    tabsetPanel(
        id = ns(id),
        tabPanel(
            "Histogram",
            m_graphs_histogram_ui("histogram")
        ),
        tabPanel(
            "Scatterplot",
            m_graphs_scatterplot_ui("scatterplot")
        )
    )
}
m_graphs_srv <- function(id, data_rv = reacrive({})) {
  moduleServer(
    id,
    function(input, output, session) {
        m_graphs_histogram_srv("histogram", data_rv = data_rv)
        m_graphs_scatterplot_srv("scatterplot", data_rv = data_rv)
    }
  )
}