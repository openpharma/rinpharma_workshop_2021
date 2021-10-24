library(shiny)

# source functions to create static outputs
# we are expecting following functions to be defined there:
# - t_dm - Demographics Table
# - t_ae - Adverse Events Table
# - t_vs - Vital Signs Table
source("tables_func.R")

# source ADAM datasets
adsl <- source("adam/adsl.R")
adae <- source("adam/adae.R")
advs <- source("adam/advs.R")
# uncomment below once we have a data ready
# data <- list(adsl = adsl, adae = adae, advs = advs)
data <- list(adsl = iris, adae = mtcars, advs = ToothGrowth)

# source modules
source("shiny/m_filter.R")
source("shiny/m_home.R")
source("shiny/m_tables.R")
source("shiny/m_graphs.R")


# TASKS:
# data preview of all the datasets coming to the app
# filter panel
# modules
#  tables
#   DM
#   AE
#   VS
#  visualizations
#   histogram of x
#   scatterplot x vs y

ui <- fluidPage(
    titlePanel("R in Pharma 2021 Workshop"),
    {
        tabs_ui <- tabsetPanel(
            tabPanel(
                "Home",
                m_home_ui("home")
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
        filter_ui <- m_filter_ui("filter")
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

server <- function(input, output, data) {
    data_rv <- m_filter_srv("filter", data)
    m_home_srv("home", data_rv = data_rv)
    m_tables_srv("tables", data_rv = data_rv)
    m_graphs_srv("graphs", data_rv = data_rv)
}

shinyApp(ui, server)
