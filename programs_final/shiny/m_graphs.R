source("shiny/m_graphs_histogram.R")
source("shiny/m_graphs_scatterplot.R")

m_graphs_ui <- function(id) {
  ns <- NS(id)
  tabsetPanel(
    id = ns(id),
    tabPanel(
      "Histogram",
      m_graphs_histogram_ui(ns("histogram"))
    ),
    tabPanel(
      "Scatterplot",
      m_graphs_scatterplot_ui(ns("scatterplot"))
    )
  )
}
m_graphs_srv <- function(id, list_reactive_datasets) {
  moduleServer(
    id,
    function(input, output, session) {
      m_graphs_histogram_srv("histogram", list_reactive_datasets = list_reactive_datasets)
      m_graphs_scatterplot_srv("scatterplot", list_reactive_datasets = list_reactive_datasets)
    }
  )
}
