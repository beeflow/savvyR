fixed_expenses_path = testthat::test_path("fixtures/monthly_fixed_expenses.csv")
financial_data_path = testthat::test_path("fixtures/financial_data.csv")
purchases_path = testthat::test_path("fixtures/purchases_2024-12.csv")
selected_month = "2024-12"

test_that("analyse_savings calculates fixed expenses correctly", {
  calculated_total <- analyse_savings(
    fixed_expenses_path = fixed_expenses_path,
    financial_data_path = financial_data_path,
    purchases_path = purchases_path,
    selected_month = selected_month
  )$fixed_expenses
  
  expect_equal(as.numeric(calculated_total), 1545.15)
})

test_that("analyse_savings calculates variable expenses correctly", {
  calculated_total <- analyse_savings(
    fixed_expenses_path = fixed_expenses_path,
    financial_data_path = financial_data_path,
    purchases_path = purchases_path,
    selected_month = selected_month
  )$variable_expenses
  
  expect_equal(as.numeric(calculated_total), 332.39)
})

test_that("analyse_savings calculates total expenses correctly", {
  calculated_total <- analyse_savings(
    fixed_expenses_path = fixed_expenses_path,
    financial_data_path = financial_data_path,
    purchases_path = purchases_path,
    selected_month = selected_month
  )$total_expenses
  
  expect_equal(as.numeric(calculated_total), 1877.54)
})

test_that("analyse_savings calculates savings correctly", {
  calculated_savings <- analyse_savings(
    fixed_expenses_path = fixed_expenses_path,
    financial_data_path = financial_data_path,
    purchases_path = purchases_path,
    selected_month = selected_month
  )$savings
  
  expect_equal(as.numeric(calculated_savings), 622.46)
})
