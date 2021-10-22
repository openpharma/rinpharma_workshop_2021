# Set up environment ----
library(rtables)            # https://roche.github.io/rtables/

# Load data ----
# adsl <- readRDS("data_demo/ADSL.rds")
# advs <- readRDS("data_demo/ADVS.rds")

# Resources ----
# Vignette: https://roche.github.io/rtables/articles/clinical_trials.html
# Specifications for tables: https://docs.google.com/presentation/d/1bmAtJO7auQHGdnZj2Pw7mgJu-x0oZtpgRGe66uupF-U/edit#slide=id.gfa0fc69b34_0_333

# Vital Signs Table ----

s_summary_vs <- function(x) {

  # Calculate the number of non-missing records in x
  n <-

  # Calculate mean and standard deviation of x
  mean_sd <-

  # Calculate 95% confidence interval for mean of x
  conf_int95 <-

  in_rows(
    "n" = rcell(n, format = "xx"),

    # Add the remaining labels and formats for n, mean_sd, and conf_int95

  )

}

# Try it out:
# s_summary_vs(1:100)

t_vs <- function(advs, adsl, title = "", subtitle = "", main_footer = "") {

  lyt <- basic_table(

    # Create the table layout.

  ) %>%
    # Add details here about the column variables.
    split_cols_by(var = , split_fun = ) %>%

    # Look up function used to add the column population counts to the header (N=xx) and add it to pipeline here.

    # Split the rows by the parameter variable.
    split_rows_by(
      var = ,
      labels_var = ,
      split_fun = , # Select only the blood pressure parameters (DIABP, SYSBP)
      split_label = ,
      label_pos = ) %>%

    # Split the rows by visit.
    split_rows_by(
      var = ,
      label_pos = ,
      split_label =
    ) %>%

    # Select the analysis variable to use:
    analyze(var = , afun = s_summary_vs)

  # Specify the datasets used to build the layout.
  build_table(lyt, df = , alt_counts_df = )

}

# Try it out:
# t_vs(advs, adsl)
