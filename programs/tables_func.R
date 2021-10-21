# Set up environment ----
library(rtables)            # https://roche.github.io/rtables/

# Load data ----
adsl <- readRDS("data_demo/ADSL.rds")
adae <- readRDS("data_demo/ADAE.rds")
advs <- readRDS("data_demo/ADVS.rds")

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

    vs <- as.list(table(x))
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

# Adverse Events Table ----

# Analysis function
s_events_patients <- function(x, labelstr, .N_col) {
  in_rows(
    "Total number of patients with at least one event" =
      rcell(length(unique(x)) * c(1, 1/.N_col), format = "xx (xx.x%)"),

    "Total number of events" = rcell(length(x), format = "xx")
  )
}

s_count_once_per_id <- function(df, termvar = "AEDECOD", idvar = "USUBJID") {

  x <- droplevels(df[[termvar]])
  id <- df[[idvar]]

  counts <- table(x[!duplicated(id)])

  in_rows(
    .list = as.vector(counts),
    .labels = names(counts)
  )
}

# Try it out:
# s_events_patients(x = adae$USUBJID, .N_col = nrow(adsl))
# s_count_once_per_id(adae)

t_ae <- function(adae, adsl, title = "", subtitle = "", main_footer = "") {

  lyt <- basic_table(
      title = title,
      subtitle = subtitle,
      main_footer = main_footer
    ) %>%
    split_cols_by("ARM") %>%
    add_colcounts() %>%
    summarize_row_groups("USUBJID", cfun = s_events_patients) %>%
    split_rows_by(
      var = "AEBODSYS",
      split_label = "System Organ Class",
      child_labels = "visible",
      label_pos = "topleft",
      split_fun = drop_split_levels,
      indent_mod = -1L
    ) %>%
    summarize_row_groups("USUBJID", cfun = s_events_patients) %>%
    analyze("AEDECOD", afun = s_count_once_per_id, indent_mod = -1L) %>%
    append_topleft("  Preferred Term")

  build_table(lyt, df = adae, alt_counts_df = adsl)
}

# Try it out:
# t_ae(adae, adsl)

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
