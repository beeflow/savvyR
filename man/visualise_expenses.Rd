\name{visualise_expenses}
\alias{visualise_expenses}
\title{Visualise Monthly Expenses}
\description{
  This function generates a pie chart showing the distribution of fixed expenses, variable expenses, and remaining budget for a selected month.
}
\usage{
visualise_expenses(fixed_expenses_path, purchases_path, selected_month)
}
\arguments{
  \item{fixed_expenses_path}{A string specifying the path to the CSV file containing monthly fixed expenses.}
  \item{purchases_path}{A string specifying the path to the CSV file containing purchase data for the selected month.}
  \item{selected_month}{A string specifying the month to visualise in the format \code{YYYY-MM}.}
}
\value{
  A ggplot2 object representing a pie chart of expense distribution.
}
\examples{
fixed_expenses_path <- "path/to/fixed_expenses.csv"
purchases_path <- "path/to/purchases_2024-12.csv"
selected_month <- "2024-12"

chart <- visualise_expenses(fixed_expenses_path, purchases_path, selected_month)
print(chart)
}
