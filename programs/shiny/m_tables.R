source("shiny/m_tables_dm.R")
source("shiny/m_tables_ae.R")
source("shiny/m_tables_vs.R")

m_tables_ui <- function(id) {
    ns <- NS(id)
    tabsetPanel(
        id = ns(id),
        tabPanel(
            "DM",
            m_tables_dm_ui("dm")
        ),
        tabPanel(
            "AE",
            m_tables_ae_ui("ae")
        ),
        tabPanel(
            "VS",
            m_tables_vs_ui("vs")
        )
    )
}
m_tables_srv <- function(id, data_rv = reacrive({})) {
  moduleServer(
    id,
    function(input, output, session) {
        m_tables_dm_srv("dm", data_rv = data_rv)
        m_tables_ae_srv("ae", data_rv = data_rv)
        m_tables_vs_srv("vs", data_rv = data_rv)
    }
  )
}