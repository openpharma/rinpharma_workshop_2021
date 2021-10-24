m_tables_vs_ui <- function(id) {
    ns <- NS(id)
    "VSVS"
}
m_tables_vs_srv <- function(id, data_rv = reacrive({})) {
  moduleServer(
    id,
    function(input, output, session) {

    }
  )
}