#' Visualise Monthly Expenses
#'
#' This function generates a pie chart visualising the distribution of expenses for a selected month, 
#' including fixed expenses, variable expenses, and the remaining budget.
#'
#' @param fixed_expenses_path A string specifying the path to the CSV file containing fixed expenses data.
#' The file should include at least two columns: "title" and "amount".
#' @param purchases_path A string specifying the path to the CSV file containing purchases data for the selected month.
#' The file should include columns "date", "place", "item", and "amount", with dates formatted as "YYYY-MM-DD".
#' @param selected_month A string specifying the month to visualise, formatted as "YYYY-MM".
#' 
#' @return A `ggplot2` pie chart object visualising the distribution of fixed expenses, 
#' variable expenses, and the remaining budget as proportions of total income.
#'
#' @import ggplot2
#' @importFrom dplyr summarise pull
#' @importFrom lubridate ymd
#'
#' @examples
#' # Example usage:
#' # Create temporary file paths
#' fixed_expenses_path <- tempfile(fileext = ".csv")
#' purchases_path <- tempfile(fileext = ".csv")
#'
#' # Write sample data to files
#' write.csv(data.frame(title = c("Rent", "Utilities"), amount = c(1000, 200)), 
#'           fixed_expenses_path, row.names = FALSE)
#' write.csv(data.frame(
#'   date = c("2025-01-01", "2025-01-02"), 
#'   place = c("Supermarket", "Online Store"), 
#'   item = c("Groceries", "Electronics"), 
#'   amount = c(150, 300)
#' ), purchases_path, row.names = FALSE)
#'
#' # Or use your own CSV files
#' 
#' # Specify the selected month
#' selected_month <- "2025-01"
#'
#' # Generate the pie chart
#' pie_chart <- visualise_expenses(fixed_expenses_path, purchases_path, selected_month)
#'
#' # Display the chart
#' print(pie_chart)
visualise_expenses <- function(fixed_expenses_path, purchases_path, selected_month) {
  # Load data
  fixed_expenses <- read.csv(fixed_expenses_path)
  purchases <- read.csv(purchases_path)
  
  # Summarise fixed expenses
  total_fixed_expenses <- fixed_expenses |>
    summarise(total = sum(amount, na.rm = TRUE)) |>
    pull(total)
  
  # Summarise variable expenses for the selected month
  total_variable_expenses <- purchases |>
    summarise(total = sum(amount, na.rm = TRUE)) |>
    pull(total)
  
  # Calculate total expenses
  total_expenses <- total_fixed_expenses + total_variable_expenses
  
  # Create a data frame for visualization
  expense_data <- data.frame(
    Category = c("Fixed Expenses", "Variable Expenses", "Remaining Budget"),
    Amount = c(total_fixed_expenses, total_variable_expenses, -total_expenses)
  )
  
  # Create a pie chart
  pie_chart <- ggplot(expense_data, aes(x = "", y = Amount, fill = Category)) +
    geom_bar(stat = "identity", width = 1) +
    coord_polar(theta = "y") +
    labs(
      title = paste("Expense Distribution for", selected_month),
      fill = "Category",
      y = "Amount",
      x = ""
    ) +
    theme_minimal()
  
  # Return the pie chart
  return(pie_chart)
}
