\name{analyse_trends}
\alias{analyse_trends}
\title{Analyse Trends in Expenses and Savings}
\description{
This function analyses trends in fixed expenses, variable expenses, and savings for a given date range and visualises the results using a bar chart.
}
\usage{
analyse_trends(fixed_expenses_path, purchases_folder, financial_data_path, start_month, end_month)
}
\arguments{
  \item{fixed_expenses_path}{\code{character}. The file path to the CSV file containing fixed expenses data. Each row should represent an expense with an \code{amount}.}
  \item{purchases_folder}{\code{character}. The folder path containing CSV files with purchase data. Each file should represent purchases for a specific month with \code{date} and \code{amount} columns.}
  \item{financial_data_path}{\code{character}. The file path to the CSV file containing financial data. The file must include \code{month}, \code{income}, and \code{budget} columns.}
  \item{start_month}{\code{character}. The starting month of the analysis in \code{"YYYY-MM"} format.}
  \item{end_month}{\code{character}. The ending month of the analysis in \code{"YYYY-MM"} format.}
}
\value{
A \code{list} with the following components:
\item{plot}{A \code{ggplot} object visualising trends in fixed expenses, variable expenses, and savings as percentages of income for each month.}
\item{data}{A \code{data.frame} containing calculated trends and budget values for each month in the specified range. The columns include:
  \itemize{
    \item \code{Month}: The month in \code{"YYYY-MM"} format.
    \item \code{Fixed_Expenses}: Fixed expenses as a percentage of income.
    \item \code{Variable_Expenses}: Variable expenses as a percentage of income.
    \item \code{Savings}: Savings as a percentage of income.
    \item \code{Budget}: Budget as a percentage of income.
  }
}}
\details{
This function calculates fixed expenses, variable expenses, and savings as percentages of income for each month in the specified range. It assumes that fixed expenses remain constant across months. Variable expenses are computed from purchase data, and savings are calculated as the remainder of income after deducting expenses.
}
\examples{
# Example file paths
fixed_expenses_path <- "path/to/monthly_fixed_expenses.csv"
purchases_folder <- "path/to/csv_files"
financial_data_path <- "path/to/financial_data.csv"

# Run the function
result <- analyse_trends(
  fixed_expenses_path = fixed_expenses_path,
  purchases_folder = purchases_folder,
  financial_data_path = financial_data_path,
  start_month = "2024-10",
  end_month = "2024-12"
)

# View the results
print(result$plot)
head(result$data)
}
\seealso{
\code{\link[ggplot2]{ggplot}}, \code{\link[dplyr]{filter}}, \code{\link[readr]{read_csv}}
}
