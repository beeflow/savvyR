\name{analyse_savings}
\alias{analyse_savings}
\title{Analyse Monthly Savings}
\description{
  This function analyses financial data for a selected month to calculate fixed expenses, variable expenses, total expenses, remaining budget, and savings.
}
\usage{
analyse_savings(
  fixed_expenses_path, 
  financial_data_path, 
  purchases_path, 
  selected_month
)
}
\arguments{
  \item{fixed_expenses_path}{A string specifying the path to the CSV file containing monthly fixed expenses. The file should have columns \code{title} and \code{amount}.}
  \item{financial_data_path}{A string specifying the path to the CSV file containing financial data, including income and budget for each month. The file should have columns \code{month}, \code{income}, and \code{budget}.}
  \item{purchases_path}{A string specifying the path to the CSV file containing purchase data for the selected month. The file should have columns \code{date}, \code{place}, \code{item}, and \code{amount}.}
  \item{selected_month}{A string specifying the month to analyse in the format \code{YYYY-MM}.}
}
\value{
  A named list with the following elements:
  \describe{
    \item{\code{fixed_expenses}}{Total fixed expenses for the selected month.}
    \item{\code{variable_expenses}}{Total variable expenses (purchases) for the selected month.}
    \item{\code{total_expenses}}{Total expenses (fixed + variable) for the selected month.}
    \item{\code{remaining_budget}}{Remaining budget after accounting for variable expenses.}
    \item{\code{savings}}{Savings calculated as \code{income - total_expenses}.}
  }
}
\details{
  This function reads financial data from three CSV files: fixed expenses, monthly financial data, and monthly purchases. It performs calculations based on the selected month and returns a detailed summary of expenses and savings.
}
\examples{
# Example usage of analyse_savings
results <- analyse_savings(
  fixed_expenses_path = "path/to/fixed_expenses.csv",
  financial_data_path = "path/to/financial_data.csv",
  purchases_path = "path/to/purchases.csv",
  selected_month = "2024-12"
)

# Access results
print(results$fixed_expenses)
print(results$savings)
}
\seealso{
\code{readr::read_csv}, \code{dplyr::filter}
}
