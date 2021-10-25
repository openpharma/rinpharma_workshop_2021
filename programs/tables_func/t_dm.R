# Set up environment ----
library(rtables)            # https://roche.github.io/rtables/

# Load data ----
# adsl <- readRDS("data_demo/ADSL.rds")

# Resources ----
# Specifications for tables: https://docs.google.com/document/d/1-2q14d4_CFvyG0EAhAqec3DMkRUmHPSe3BWugUSFBCM/edit?usp=sharing
# Vignette: https://roche.github.io/rtables/articles/clinical_trials.html

# Demographics Table ----

# Analysis function
s_summary_dm <- function(x) {

  if (is.numeric(x)) {

    # Calculate the number of non-missing records in x
    n <-

    # Calculate mean and standard deviation of x
    mean_sd <-

    # Calculate median, 1st quartile, 3rd quartile of x
    median_q1_q3 <-

    # Calculate minimum and maximum of x
    min_max <-

    in_rows(
      "n" = rcell(n, format = "xx"),

      # Add the remaining labels and formats for n, mean_sd, median_q1_q3 and min_max

    )
  } else if (is.factor(x)) {

    # Calculate the number of non-missing records in x as a named list
    n <- list(n = )

    # Calculate the counts of each level in x as a named list
    x_counts <-

    vs <- c(n, x_counts)

    do.call(in_rows, lapply(vs, rcell, format = "xx"))

  } else (
    stop("type not supported")
  )
}

# Try it out:
# s_summary_dm(1:100)
# s_summary_dm(factor(letters[1:3]))

t_dm <- function(adsl, title = "", subtitle = "", main_footer = "") {

  # Create the table layout.
  lyt <- basic_table(

    # Add title, subtitle and main_footer details here.

  ) %>%
    # Add details here about the column variables.
    split_cols_by(var = , split_fun = ) %>%

    # Look up function used to add the column population counts to the header (N=xx) and add it to pipeline here.

    # Add details here about analysis variables.
    analyze(
      vars = ,
      var_labels = ,
      afun = s_summary_dm
    )

  build_table(lyt, adsl)
}

# Try it out:
# t_dm(adsl)
