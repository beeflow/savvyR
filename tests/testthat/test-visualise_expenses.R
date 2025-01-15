library(testthat)
library(ggplot2)

test_that("visualise_expenses generates a valid pie chart", {
  fixed_expenses_path <- here::here("tests", "testthat", "fixtures", "monthly_fixed_expenses.csv")
  purchases_path <- here::here("tests", "testthat", "fixtures", "purchases_2024-12.csv")
  selected_month <- "2024-12"
  
  chart <- visualise_expenses(fixed_expenses_path, purchases_path, selected_month)
  
  # Check the class of the returned object
  expect_s3_class(chart, "ggplot")
  
  # Check the title of the chart
  expect_equal(chart$labels$title, paste("Expense Distribution for", selected_month))
  
  # Check that the data contains the correct categories
  expect_true(all(c("Fixed Expenses", "Variable Expenses", "Remaining Budget") %in% chart$data$Category))
})
