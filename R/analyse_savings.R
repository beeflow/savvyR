analyse_savings <- function(
  fixed_expenses_path,
  financial_data_path,
  purchases_path,
  selected_month
) {
  # Load data
  fixed_expenses <- readr::read_csv(fixed_expenses_path, show_col_types = FALSE)
  financial_data <- readr::read_csv(financial_data_path, show_col_types = FALSE)
  purchases <- readr::read_csv(purchases_path, show_col_types = FALSE)

  # Validate selected month in financial data
  financial_month <- financial_data |> dplyr::filter(month == selected_month)
  if (nrow(financial_month) == 0) {
    stop("Selected month not found in financial data.")
  }

  # Calculate fixed expenses without rounding
  total_fixed_expenses <- sum(fixed_expenses$amount, na.rm = TRUE)

  # Calculate variable expenses directly from the monthly purchases file
  total_variable_expenses <- sum(purchases$amount, na.rm = TRUE)

  # Calculate total expenses, remaining budget, and savings
  total_expenses <- total_fixed_expenses + total_variable_expenses
  remaining_budget <- financial_month$budget - total_variable_expenses
  savings <- financial_month$income - total_expenses

  # Return results with final rounding
  list(
    fixed_expenses = round(total_fixed_expenses, 2),
    variable_expenses = round(total_variable_expenses, 2),
    total_expenses = round(total_expenses, 2),
    remaining_budget = round(remaining_budget, 2),
    savings = round(savings, 2)
  )
}
