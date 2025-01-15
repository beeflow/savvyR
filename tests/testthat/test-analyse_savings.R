test_that("analyse_savings calculates fixed expenses correctly", {
  calculated_total <- analyse_savings(
    fixed_expenses_path = here::here("tests", "testthat", "fixtures", "monthly_fixed_expenses.csv"),
    financial_data_path = here::here("tests", "testthat", "fixtures", "financial_data.csv"),
    purchases_path = here::here("tests", "testthat", "fixtures", "purchases_2024-12.csv"),
    selected_month = "2024-12"
  )$fixed_expenses
  
  expect_equal(as.numeric(calculated_total), 1545.15)
})

test_that("analyse_savings calculates variable expenses correctly", {
  calculated_total <- analyse_savings(
    fixed_expenses_path = here::here("tests", "testthat", "fixtures", "monthly_fixed_expenses.csv"),
    financial_data_path = here::here("tests", "testthat", "fixtures", "financial_data.csv"),
    purchases_path = here::here("tests", "testthat", "fixtures", "purchases_2024-12.csv"),
    selected_month = "2024-12"
  )$variable_expenses
  
  expect_equal(as.numeric(calculated_total), 332.39)
})

test_that("analyse_savings calculates total expenses correctly", {
  calculated_total <- analyse_savings(
    fixed_expenses_path = here::here("tests", "testthat", "fixtures", "monthly_fixed_expenses.csv"),
    financial_data_path = here::here("tests", "testthat", "fixtures", "financial_data.csv"),
    purchases_path = here::here("tests", "testthat", "fixtures", "purchases_2024-12.csv"),
    selected_month = "2024-12"
  )$total_expenses
  
  expect_equal(as.numeric(calculated_total), 1877.54)
})

test_that("analyse_savings calculates savings correctly", {
  calculated_savings <- analyse_savings(
    fixed_expenses_path = here::here("tests", "testthat", "fixtures", "monthly_fixed_expenses.csv"),
    financial_data_path = here::here("tests", "testthat", "fixtures", "financial_data.csv"),
    purchases_path = here::here("tests", "testthat", "fixtures", "purchases_2024-12.csv"),
    selected_month = "2024-12"
  )$savings
  
  expect_equal(as.numeric(calculated_savings), 622.46)
})
