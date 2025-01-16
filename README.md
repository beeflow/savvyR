# savvyR

**savvyR** is an R package designed to assist users in managing and analysing personal finances. It includes tools for visualising expenses, analysing savings, and identifying financial trends over time.

Created as a final project of the CS50R Course: <https://cs50.harvard.edu/r/2024/project/>

## Features

-   **Visualise Expenses**: Create pie charts showing the proportion of fixed and variable expenses for a specific month.
-   **Analyse Savings**: Calculate and visualise monthly savings based on provided income, expenses, and budget data.
-   **Analyse Trends**: Examine expense and saving trends across multiple months using bar charts.

## Installation

To install the development version of **savvyR** from GitHub, run the following commands:

``` r
# Install the 'remotes' package if it's not already installed
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}

# Install savvyR from GitHub
remotes::install_github("beeflow/savvyR")
```

## Usage

### Example 1: Visualising Expenses for a Specific Month

``` r
library(savvyR)

# File paths
fixed_expenses_path <- "path/to/fixed_expenses.csv"
purchases_path <- "path/to/purchases_2024-12.csv"

# Selected month
selected_month <- "2024-12"

# Generate expense visualisation
expense_chart <- visualise_expenses(fixed_expenses_path, purchases_path, selected_month)
print(expense_chart)
```

### Example 2: Analysing Savings for a Specific Month

``` r
# File paths
fixed_expenses_path <- "path/to/fixed_expenses.csv"
purchases_path <- "path/to/purchases_2024-12.csv"
financial_data_path <- "path/to/financial_data.csv"

# Generate savings analysis
savings_chart <- analyse_savings(financial_data_path, fixed_expenses_path, purchases_path, selected_month)
print(savings_chart)
```

### Example 3: Analysing Trends Over a Date Range

``` r
# Folder containing monthly purchases files in the format "purchases_YYYY-MM.csv"
purchases_folder <- "path/to/purchases_folder"
fixed_expenses_path <- "path/to/fixed_expenses.csv"
financial_data_path <- "path/to/financial_data.csv"

# Date range
start_month <- "2024-01"
end_month <- "2024-12"

# Generate trends analysis
trends_chart <- analyse_trends(fixed_expenses_path, purchases_folder, financial_data_path, start_month, end_month)
print(trends_chart)
```

### Notes on File Requirements

1.  **Fixed Expenses File** (`fixed_expenses.csv`):
    -   Contains information about fixed monthly expenses.
2.  **Purchases Files** (`purchases_YYYY-MM.csv`):
    -   Each file corresponds to a specific month, named in the format `purchases_YYYY-MM.csv`.
3.  **Financial Data File** (`financial_data.csv`):
    -   Includes income and budget details for the analysis.

## File Formats

The **savvyR** package requires the following CSV files as input. Ensure the files follow the specified formats to enable accurate analysis and visualisation.

### `financial_data.csv`

This file contains monthly income and budget data. It must include the following columns:

| Column Name | Description                    |
|-------------|--------------------------------|
| `month`     | Month in the format `YYYY-MM`. |
| `income`    | Total income for the month.    |
| `budget`    | Budgeted amount for the month. |

### `monthly_fixed_expenses.csv`

This file lists fixed monthly expenses. It must include the following columns:

| Column Name | Description                         |
|-------------|-------------------------------------|
| `title`     | Description or name of the expense. |
| `amount`    | Fixed monthly cost of the expense.  |

### `purchases_YYYY-MM.csv`

Each file corresponds to a specific month's purchases. The file name must follow the format `purchases_YYYY-MM.csv`. It must include the following columns:

| Column Name | Description                           |
|-------------|---------------------------------------|
| `date`      | Date of the purchase in `YYYY-MM-DD`. |
| `place`     | Place where the purchase was made.    |
| `item`      | Description of the purchased item.    |
| `amount`    | Cost of the item.                     |

## Documentation

For function-specific details, refer to the help files:

``` r
# View function documentation
?visualise_expenses
?analyse_savings
?analyse_trends
```

## Contributing

Contributions to **savvyR** are welcome. To contribute:

1.  Fork the repository on GitHub.
2.  Create a new branch for your feature or bug fix.
3.  Implement your changes, including documentation and tests.
4.  Submit a pull request with a detailed description of your changes.

## License

This project is licensed under the MIT License.
