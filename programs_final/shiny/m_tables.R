source("m_tables_dm.R")
source("m_tables_ae.R")
source("m_tables_vs.R")

m_tables_ui <- function(id) {
  ns <- NS(id)
  tabsetPanel(
    id = ns(id),
    tabPanel(
      "DM",
      m_tables_dm_ui(ns("dm"))
    ),
    tabPanel(
      "AE",
      m_tables_ae_ui(ns("ae"))
    ),
    tabPanel(
      "VS",
      m_tables_vs_ui(ns("vs"))
    )
  )
}
m_tables_srv <- function(id, list_reactive_datasets) {
  moduleServer(
    id,
    function(input, output, session) {
      m_tables_dm_srv("dm", list_reactive_datasets = list_reactive_datasets)
      m_tables_ae_srv("ae", list_reactive_datasets = list_reactive_datasets)
      m_tables_vs_srv("vs", list_reactive_datasets = list_reactive_datasets)
    }
  )
}
