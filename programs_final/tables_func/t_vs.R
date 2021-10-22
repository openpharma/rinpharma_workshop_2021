# Set up environment ----
library(rtables)            # https://roche.github.io/rtables/

# Load data ----
# adsl <- readRDS("data_demo/ADSL.rds")
# advs <- readRDS("data_demo/ADVS.rds")

# Resources ----
# Vignette: https://roche.github.io/rtables/articles/clinical_trials.html

# Vital Signs Table ----

s_summary_vs <- function(x) {
  in_rows(
    "n" = rcell(sum(!is.na(x)), format = "xx"),
    "Mean (SD)" = rcell(c(mean(x, na.rm = TRUE), sd(x, na.rm = TRUE)), format = "xx.x (xx.x)"),
    "95% CI" = rcell(t.test(x)$conf.int, format = "(xx.x, xx.x)")
  )
}

# Try it out:
# s_summary_vs(1:100)

t_vs <- function(advs, adsl, title = "", subtitle = "", main_footer = "") {

  lyt <- basic_table(
    title = title,
    subtitle = subtitle,
    main_footer = main_footer
  ) %>%
    split_cols_by("ARM", split_fun = add_overall_level("All Patients", first = FALSE)) %>%
    add_colcounts() %>%
    split_rows_by(
      "PARAMCD",
      labels_var = "PARAM",
      split_fun = keep_split_levels(c("DIABP", "SYSBP")),
      split_label = "Parameter",
      label_pos = "topleft") %>%
    split_rows_by("AVISIT", label_pos = "topleft", split_label = "Analysis Visit") %>%
    analyze("AVAL", afun = s_summary_vs)

  build_table(lyt, df = advs, alt_counts_df = adsl)

}

# Try it out:
# t_vs(advs, adsl)
