# Specify the file paths
fixed_expenses_path <- testthat::test_path("fixtures/monthly_fixed_expenses.csv")
purchases_folder <- here::here("tests", "testthat", "fixtures")
financial_data_path <- testthat::test_path("fixtures/financial_data.csv")

test_that("analyse_trends produces correct output structure", {
  # Call the function
  result <- analyse_trends(
    fixed_expenses_path = fixed_expenses_path,
    purchases_folder = purchases_folder,
    financial_data_path = financial_data_path,
    start_month = "2024-10",
    end_month = "2024-12"
  )
  
  # Check if the result is a list
  expect_type(result, "list")
  
  # Check if the list contains "plot" and "data"
  expect_named(result, c("plot", "data"))
  
  # Check if the plot is of the correct class
  expect_s3_class(result$plot, "ggplot")
  
  # Check if the data is a data frame
  expect_s3_class(result$data, "data.frame")
})

test_that("analyse_trends returns the correct number of rows", {
  # Call the function
  result <- analyse_trends(
    fixed_expenses_path = fixed_expenses_path,
    purchases_folder = purchases_folder,
    financial_data_path = financial_data_path,
    start_month = "2024-10",
    end_month = "2024-12"
  )
  
  # Check if the number of rows matches the number of months in the range
  expected_rows <- length(seq.Date(
    from = lubridate::ymd("2024-10-01"),
    to = lubridate::ymd("2024-12-01"),
    by = "month"
  ))
  expect_equal(nrow(result$data), expected_rows)
})

test_that("analyse_trends calculates correct percentages", {
  # Call the function
  result <- analyse_trends(
    fixed_expenses_path = fixed_expenses_path,
    purchases_folder = purchases_folder,
    financial_data_path = financial_data_path,
    start_month = "2024-10",
    end_month = "2024-12"
  )
  
  # Extract data
  data <- result$data
  
  # Check if percentages sum up to 100% for each month
  for (i in seq_len(nrow(data))) {
    total_percentage <- sum(data$Fixed_Expenses[i], data$Variable_Expenses[i], data$Savings[i], na.rm = TRUE)
    expect_equal(total_percentage, 100, tolerance = 1e-6)
  }
})

test_that("analyse_trends handles empty purchases gracefully", {
  # Create a temporary empty folder
  empty_folder <- tempfile()
  dir.create(empty_folder)
  
  # Call the function
  result <- analyse_trends(
    fixed_expenses_path = fixed_expenses_path,
    purchases_folder = empty_folder,
    financial_data_path = financial_data_path,
    start_month = "2024-10",
    end_month = "2024-12"
  )
  
  # Check if variable expenses are all zero
  expect_true(all(result$data$Variable_Expenses == 0))
  
  # Clean up the temporary folder
  unlink(empty_folder, recursive = TRUE)
})

test_that("analyse_trends handles mismatched date ranges", {
  # Call the function with a mismatched date range
  result <- analyse_trends(
    fixed_expenses_path = fixed_expenses_path,
    purchases_folder = purchases_folder,
    financial_data_path = financial_data_path,
    start_month = "2024-01",
    end_month = "2024-03"
  )
  
  # Check if the data frame is empty (no matching months)
  expect_equal(nrow(result$data), 0)
})
