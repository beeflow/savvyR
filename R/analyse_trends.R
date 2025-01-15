#' Analyse Financial Trends
#'
#' This function performs an analysis of financial trends, including fixed expenses, 
#' variable expenses, savings, and budget, over a specified range of months. It produces
#' both a visualisation of the trends and a summary data frame for further analysis.
#'
#' @param fixed_expenses_path A string specifying the path to the CSV file containing fixed expenses data.
#' The file should include at least two columns: "title" and "amount".
#' @param purchases_folder A string specifying the path to the folder containing monthly purchase CSV files.
#' Each file should include columns "date", "place", "item", and "amount", with dates formatted as "YYYY-MM-DD".
#' @param financial_data_path A string specifying the path to the CSV file containing financial data.
#' The file should include columns "month", "income", and "budget".
#' @param start_month A string specifying the start month of the analysis, formatted as "YYYY-MM".
#' @param end_month A string specifying the end month of the analysis, formatted as "YYYY-MM".
#'
#' @return A named list containing:
#' \item{plot}{A `ggplot2` object visualising the trends in expenses, savings, and budget.}
#' \item{data}{A data frame summarising fixed expenses, variable expenses, savings, and budget as percentages of income for each month.}
#'
#' @import ggplot2
#' @importFrom dplyr bind_rows filter
#' @importFrom lubridate ymd
#' @importFrom tidyr pivot_longer
#'
#' @examples
#' # Example usage:
#' # Create temporary file paths and folder
#' fixed_expenses_path <- tempfile(fileext = ".csv")
#' financial_data_path <- tempfile(fileext = ".csv")
#' purchases_folder <- tempfile()
#' dir.create(purchases_folder)
#'
#' # Write sample data to files
#' write.csv(data.frame(title = c("Rent", "Utilities"), amount = c(1000, 200)), 
#'           fixed_expenses_path, row.names = FALSE)
#' write.csv(data.frame(month = c("2025-01", "2025-02", "2025-03"), 
#'                      income = c(3000, 3000, 3000), 
#'                      budget = c(1000, 1000, 1000)), 
#'           financial_data_path, row.names = FALSE)
#' write.csv(data.frame(date = c("2025-01-01", "2025-01-02"), 
#'                      place = c("Supermarket", "Online Store"), 
#'                      item = c("Groceries", "Electronics"), 
#'                      amount = c(150, 300)), 
#'           file.path(purchases_folder, "purchases_2025-01.csv"), 
#'           row.names = FALSE)
#' 
#' write.csv(data.frame(date = c("2025-02-01", "2025-02-02"), 
#'                      place = c("Supermarket", "Online Store"), 
#'                      item = c("Groceries", "Electronics"), 
#'                      amount = c(200, 350)), 
#'           file.path(purchases_folder, "purchases_2025-02.csv"), 
#'           row.names = FALSE)
#'
#' # Or use your own CSV files
#'
#' # Run the function
#' result <- analyse_trends(
#'   fixed_expenses_path = fixed_expenses_path,
#'   purchases_folder = purchases_folder,
#'   financial_data_path = financial_data_path,
#'   start_month = "2025-01",
#'   end_month = "2025-03"
#' )
#'
#' # Display the plot
#' print(result$plot)

utils::globalVariables(c(
  "month", "Month", "Budget", "Category", "Percentage", "amount", "total", "Amount"
))

analyse_trends <- function(fixed_expenses_path, purchases_folder, financial_data_path, start_month, end_month) {
  # Load fixed expenses data
  fixed_expenses <- read.csv(fixed_expenses_path)

  # Load financial data
  financial_data <- read.csv(financial_data_path)

  # Load purchase data from all files in the specified folder
  all_files <- list.files(purchases_folder, pattern = "*.csv", full.names = TRUE)
  all_purchases <- lapply(all_files, read.csv)
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
