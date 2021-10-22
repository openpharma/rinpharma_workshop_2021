# Set up environment ----
library(rtables)            # https://roche.github.io/rtables/

# Load data ----
# adsl <- readRDS("data_demo/ADSL.rds")
# adae <- readRDS("data_demo/ADAE.rds")

# Resources ----
# Vignette: https://roche.github.io/rtables/articles/clinical_trials.html
# Specifications for tables: https://docs.google.com/presentation/d/1bmAtJO7auQHGdnZj2Pw7mgJu-x0oZtpgRGe66uupF-U/edit#slide=id.gfa0fc69b34_0_333

# Adverse Events Table ----

# Analysis function

# Create a function to calculate the overall summary of subject with events and number of events
s_events_patients <- function(x, labelstr, .N_col) {

  # Calculate total number of patients in x with at least one event as a vector representing the count and percent
  # For example if 3 subjects out of 4 had events the result would be c(3, 0.75)
  n_subj <-

  # Total number of events in x
  n_events <-

  # Fill in the labels and formats
  in_rows(
    "Total number of patients with at least one event" =
      rcell(n_subj, format = ),

      # Add rcell object with labels and formats for `n_events`
      rcell()
  )
}

# Try it out:
# s_events_patients(x = c("ID1", "ID1", "ID2", "ID3", "ID3"), .N_col = 4)
# s_events_patients(x = adae$USUBJID, .N_col = nrow(adsl))

# Create a function to calculate the unique number of subjects and events

s_count_once_per_id <- function(df, termvar = "AEDECOD", idvar = "USUBJID") {

  # Extracts the variable representing AE terms.
  x <- df[[termvar]]

  # Extract the ID variable representing subjects
  id <-

  # Calculate the unique number of subjects for each event category in `x`
  counts <-

  in_rows(
    .list = as.vector(counts),
    # Add the names of the categories in counts to be the labels
    .labels =
  )
}

# Try it out:
# s_count_once_per_id(df = adae)

t_ae <- function(adae, adsl, title = "", subtitle = "", main_footer = "") {

  # Create the table layout.
  lyt <- basic_table(

    # Add title, subtitle and main_footer details here.

  ) %>%
    # Add details here about the column variables.
    split_cols_by(var = , split_fun = ) %>%

    # Look up function used to add the column population counts to the header (N=xx) and add it to pipeline here.

    # Add the overall summary of events.
    summarize_row_groups(var = , cfun = s_events_patients) %>%

    # Split the rows by system organ class (SOC) variable.
    split_rows_by(
      var = ,
      split_label = ,
      child_labels = "visible",
      label_pos = ,
      split_fun = ,
      indent_mod =
    ) %>%

    # Add the summary of events for each SOC.
    summarize_row_groups(var = , cfun = s_events_patients) %>%

    # Add the analysis by preferred term.
    analyze(vars = , afun = s_count_once_per_id, indent_mod = ) %>%

    # Update the label in the top left header.
    append_topleft("--Add a label--")

  # Specify the datasets used to build the layout.
  build_table(lyt, df = , alt_counts_df = )
}

# Try it out:
# t_ae(adae, adsl)
