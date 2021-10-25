library(shiny)
library(magrittr)

# source functions to create static outputs
# we are expecting following functions to be defined there:
# - t_dm - Demographics Table
# - t_ae - Adverse Events Table
# - t_vs - Vital Signs Table
source("tables_func.R")

# source ADAM datasets
# uncomment below once we have a data ready
# adsl <- source("adam/adsl.R")
# adae <- source("adam/adae.R")
# advs <- source("adam/advs.R")
# data <- list(ADSL = adsl, ADAE = adae, ADVS = advs)
data <- list(
  ADSL = readRDS("../data_demo/ADSL.rds"),
  ADAE = readRDS("../data_demo/ADAE.rds"),
  ADVS = readRDS("../data_demo/ADVS.rds")
)

# source modules
source("shiny/m_filter.R")
source("shiny/m_home.R")
source("shiny/m_preview.R")
source("shiny/m_tables.R")
source("shiny/m_graphs.R")

ui <- fluidPage(
  titlePanel("R in Pharma 2021 Workshop"),
  {
    tabs_ui <- tabsetPanel(
      tabPanel(
        "Home",
        m_home_ui("home")
      ),
      tabPanel(
        "Data Preview",
        m_preview_ui("preview")
      ),
      tabPanel(
        "Tables",
        m_tables_ui("tables")
      ),
      tabPanel(
        "Graphs",
        m_graphs_ui("graphs")
      )
    )
    # just a little bit of magic to have a filter panel shared across the modules
    filter_ui <- m_filter_ui("filter", data)
    tabs_ui$children <- list(
      tabs_ui$children[[1]],
      fluidRow(
        column(width = 9, tabs_ui$children[[2]]),
        column(width = 3, filter_ui)
      )
    )
    tabs_ui
  }
)

server <- function(input, output) {
  list_reactive_datasets <- m_filter_srv("filter", data)
  m_home_srv("home", list_reactive_datasets = list_reactive_datasets)
  m_preview_srv("preview", list_reactive_datasets = list_reactive_datasets)
  m_tables_srv("tables", list_reactive_datasets = list_reactive_datasets)
  m_graphs_srv("graphs", list_reactive_datasets = list_reactive_datasets)
}

shinyApp(ui, server)
