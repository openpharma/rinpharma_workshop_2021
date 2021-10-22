# Set up environment ----
library(rtables)            # https://roche.github.io/rtables/

# Load data ----
# adsl <- readRDS("data_demo/ADSL.rds")

# Resources ----
# Vignette: https://roche.github.io/rtables/articles/clinical_trials.html

# Demographics Table ----

# Analysis function
s_summary_dm <- function(x) {
  if (is.numeric(x)) {
    in_rows(
      "n" = rcell(sum(!is.na(x)), format = "xx"),
      "Mean (SD)" = rcell(c(mean(x, na.rm = TRUE), sd(x, na.rm = TRUE)), format = "xx.xx (xx.xx)"),
      "Median (Q1 - Q3)" = rcell(c(
        median(x, na.rm = TRUE),
        quantile(x, na.rm = TRUE, probs = c(0.25, 0.75))
      ), format = "xx.xx (xx.xx - xx.xx)"),
      "Min - Max" = rcell(range(x, na.rm = TRUE), format = "xx.xx - xx.xx")
    )
  } else if (is.factor(x)) {

    vs <- c(
      list("n" = sum(!is.na(x))),
      as.list(table(x))
    )

    do.call(in_rows, lapply(vs, rcell, format = "xx"))

  } else (
    stop("type not supported")
  )
}

# Try it out:
# s_summary_dm(1:100)
# s_summary_dm(factor(letters[1:3]))

t_dm <- function(adsl, title = "", subtitle = "", main_footer = "") {

  lyt <- basic_table(
    title = title,
    subtitle = subtitle,
    main_footer = main_footer
  ) %>%
    split_cols_by("ARM", split_fun = add_overall_level("All Patients", first = FALSE)) %>%
    add_colcounts() %>%
    analyze(
      vars = c("AGE", "SEX"),
      var_labels = c("Age (years)", "Sex"),
      afun = s_summary_dm
    )

  build_table(lyt, adsl)
}

# Try it out:
# t_dm(adsl)
