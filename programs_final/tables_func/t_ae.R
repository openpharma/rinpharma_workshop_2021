# Set up environment ----
library(rtables)            # https://roche.github.io/rtables/

# Load data ----
# adsl <- readRDS("data_demo/ADSL.rds")
# adae <- readRDS("data_demo/ADAE.rds")

# Resources ----
# Vignette: https://roche.github.io/rtables/articles/clinical_trials.html

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
    split_cols_by("ARM", split_fun = add_overall_level("All Patients", first = FALSE)) %>%
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
