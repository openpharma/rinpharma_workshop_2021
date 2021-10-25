m_filter_single_var_ui <- function(id, dataset, dataname, colname) {
  ns <- NS(id)
  id <- ns("filter")
  if (is.numeric(dataset[[colname]])) {
    # slider
    v_range <- range(dataset[[colname]])
    sliderInput(
      inputId = id,
      label = colname,
      min = v_range[1],
      max = v_range[2],
      value = v_range
    )
  } else {
    # radio-button
    v_choices <- sort(unique(dataset[[colname]]))
    checkboxGroupInput(
      inputId = id,
      label = colname,
      choices = v_choices,
      selected = v_choices
    )
  }
}

m_filter_single_var_srv <- function(id, dataset, dataname, colname) {
  moduleServer(
    id,
    function(input, output, session) {
      if (is.numeric(dataset[[colname]])) {
        # condition: x >= min & x <= max
        reactive({
          call("&", call(">=", as.name(colname), input$filter[1]), call("<=", as.name(colname), input$filter[2]))
        })
      } else {
        # condition: x %in% choices
        reactive({
          call("%in%", as.name(colname), input$filter)
        })
      }
    }
  )
}

m_filter_single_dataset_ui <- function(id, dataset, dataname, colnames) {
  ns <- NS(id)
  tagList(
    tags$b(dataname),
    lapply(
      colnames,
      function(colname) {
        m_filter_single_var_ui(ns(colname), dataset, dataname, colname)
      }
    )
  )
}

m_filter_single_dataset_srv <- function(id, dataset, dataname, colnames) {
  moduleServer(
    id,
    function(input, output, session) {
      # list of reactive objects with calls
      condition_calls <- lapply(
        colnames,
        function(colname) {
          m_filter_single_var_srv(colname, dataset, dataname, colname)
        }
      )

      reactive({
        do.call(
          dplyr::filter,
          args = c(list(dataset), lapply(condition_calls, function(x) x()))
        )
      })
    }
  )
}


m_filter_ui <- function(id, data) {
  ns <- NS(id)
  tags$form(
    class = "well",
    role = "complementary",
    tagList(
      m_filter_single_dataset_ui(ns("ADSL"), data[["ADSL"]], "ADSL", c("SEX", "RACE", "AGE")),
      m_filter_single_dataset_ui(ns("ADAE"), data[["ADAE"]], "ADAE", c("AETERM", "AETERM")),
      m_filter_single_dataset_ui(ns("ADVS"), data[["ADVS"]], "ADVS", c("PARAMCD", "AVISIT"))
    )
  )
}
m_filter_srv <- function(id, data) {
  moduleServer(
    id,
    function(input, output, session) {
      ADSL_FILTERED <- m_filter_single_dataset_srv("ADSL", data[["ADSL"]], "ADSL", c("SEX", "RACE", "AGE"))
      ADAE_FILTERED <- m_filter_single_dataset_srv("ADAE", data[["ADAE"]], "ADAE", c("AETERM", "AETERM"))
      ADVS_FILTERED <- m_filter_single_dataset_srv("ADVS", data[["ADVS"]], "ADVS", c("PARAMCD", "AVISIT"))

      ADSL_FINAL <- reactive({
        ADSL_FILTERED()
      })

      ADAE_FINAL <- reactive({
        dplyr::inner_join(ADAE_FILTERED(), ADSL_FILTERED(), by = c("STUDYID", "USUBJID"))
      })

      ADVS_FINAL <- reactive({
        dplyr::inner_join(ADVS_FILTERED(), ADSL_FILTERED(), by = c("STUDYID", "USUBJID"))
      })

      return(list(
        ADSL = ADSL_FINAL,
        ADAE = ADAE_FINAL,
        ADVS = ADVS_FINAL
      ))
    }
  )
}
