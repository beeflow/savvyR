library(ggplot2)

analyse_trends <- function(fixed_expenses_path, purchases_folder, financial_data_path, start_month, end_month) {
  # Load fixed expenses data
  fixed_expenses <- readr::read_csv(fixed_expenses_path, show_col_types = FALSE)

  # Load financial data
  financial_data <- readr::read_csv(financial_data_path, show_col_types = FALSE)

  # Load purchase data from all files in the specified folder
  all_files <- list.files(purchases_folder, pattern = "*.csv", full.names = TRUE)
  all_purchases <- lapply(all_files, readr::read_csv, show_col_types = FALSE)
  purchases <- dplyr::bind_rows(all_purchases)

  # Ensure purchases has the correct structure even if the folder is empty
  if (nrow(purchases) == 0) {
    purchases <- data.frame(date = character(), amount = numeric())
  }

  # Format purchase dates to match the "YYYY-MM" format
  purchases$date <- format(lubridate::ymd(purchases$date), "%Y-%m")

  # Filter financial data for the specified range of months
  financial_data <- financial_data |>
    dplyr::filter(month >= start_month & month <= end_month)

  # Calculate fixed expenses as a percentage of average income
  total_fixed_expenses <- sum(fixed_expenses$amount, na.rm = TRUE)
  fixed_expenses_trend <- (total_fixed_expenses / financial_data$income) * 100

  # Initialise trends
  months <- financial_data$month
  variable_expenses_trend <- numeric(length(months))
  savings_trend <- numeric(length(months))
  budget_trend <- (financial_data$budget / financial_data$income) * 100

  # Calculate values for each month
  for (i in seq_along(months)) {
    # Filter purchases for the current month
    current_month_purchases <- purchases |>
      dplyr::filter(date == months[i])
    total_variable_expenses <- sum(current_month_purchases$amount, na.rm = TRUE)

    # Retrieve income for the current month
    current_income <- financial_data$income[financial_data$month == months[i]]

    # Calculate variable expenses as a percentage of income
    variable_expenses_percentage <- (total_variable_expenses / current_income) * 100

    # Calculate savings as the remaining percentage
    total_expenses_percentage <- fixed_expenses_trend[i] + variable_expenses_percentage
    savings_percentage <- max(0, 100 - total_expenses_percentage)

    # Store calculated values
    variable_expenses_trend[i] <- variable_expenses_percentage
    savings_trend[i] <- savings_percentage
  }

  # Combine data into a data frame
  combined_data <- data.frame(
    Month = months,
    Fixed_Expenses = fixed_expenses_trend,
    Variable_Expenses = variable_expenses_trend,
    Savings = savings_trend,
    Budget = budget_trend
  )

  # Reshape data for plotting (gather columns into long format for side-by-side bars)
  long_data <- tidyr::pivot_longer(
    combined_data,
    cols = c("Fixed_Expenses", "Variable_Expenses", "Savings"),
    names_to = "Category",
    values_to = "Percentage"
  )

  # Create a side-by-side bar chart with ggplot2
  trend_plot <- ggplot(long_data, aes(x = Month, y = Percentage, fill = Category)) +
    geom_bar(stat = "identity", position = "dodge", width = 0.7) +
    geom_hline(yintercept = 100, linetype = "dashed", colour = "black", linewidth = 1) +
    geom_line(
      data = combined_data,
      aes(x = Month, y = Budget, group = 1, colour = "Budget"),
      linewidth = 1, inherit.aes = FALSE
    ) +
    scale_fill_manual(
      values = c("Variable_Expenses" = "lightgreen", "Fixed_Expenses" = "salmon", "Savings" = "darkgreen")
    ) +
    scale_colour_manual(
      values = c("Budget" = "blue")
    ) +
    labs(
      title = "Trends in Expenses, Savings, and Budget",
      x = "Month",
      y = "Percentage of Income (%)",
      fill = "Category",
      colour = "Category"
    ) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      legend.position = "top"
    )

  # Return the plot and combined data
  return(list(plot = trend_plot, data = combined_data))
}
