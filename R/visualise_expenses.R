library(ggplot2)
library(dplyr)
library(readr)
library(lubridate)

visualise_expenses <- function(fixed_expenses_path, purchases_path, selected_month) {
  # Load data
  fixed_expenses <- read_csv(fixed_expenses_path, show_col_types = FALSE)
  purchases <- read_csv(purchases_path, show_col_types = FALSE)
  
  # Summarise fixed expenses
  total_fixed_expenses <- fixed_expenses |>
    summarise(total = sum(amount, na.rm = TRUE)) |>
    pull(total)
  
  # Summarise variable expenses for the selected month
  total_variable_expenses <- purchases %>% 
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
