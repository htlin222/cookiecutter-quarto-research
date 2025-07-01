# 03_analysis.R
# Purpose: Perform statistical analyses
# Author: {{ cookiecutter.author_name }}
# Date: {{ cookiecutter.year }}

# Load required packages
library(tidyverse)
library(broom)
library(rstatix)
library(effectsize)

# Function to create summary statistics table
create_summary_table <- function(data, group_var = NULL, vars_to_summarize) {
  if (is.null(group_var)) {
    # Overall summary
    data %>%
      select(all_of(vars_to_summarize)) %>%
      summary_stats() %>%
      mutate(across(where(is.numeric), ~round(., 2)))
  } else {
    # Grouped summary
    data %>%
      group_by(!!!syms(group_var)) %>%
      select(all_of(vars_to_summarize)) %>%
      summary_stats() %>%
      mutate(across(where(is.numeric), ~round(., 2)))
  }
}

# Function for t-test with effect size
perform_t_test <- function(data, formula, paired = FALSE) {
  # Perform t-test
  t_result <- t.test(formula, data = data, paired = paired)
  
  # Calculate effect size (Cohen's d)
  es_result <- cohens_d(formula, data = data, paired = paired)
  
  # Combine results
  results <- list(
    test = t_result,
    effect_size = es_result,
    summary = data.frame(
      mean_diff = t_result$estimate[1] - ifelse(paired, 0, t_result$estimate[2]),
      ci_lower = t_result$conf.int[1],
      ci_upper = t_result$conf.int[2],
      t_statistic = t_result$statistic,
      df = t_result$parameter,
      p_value = t_result$p.value,
      cohens_d = es_result$effsize,
      d_ci_lower = es_result$conf.int[1],
      d_ci_upper = es_result$conf.int[2]
    )
  )
  
  return(results)
}

# Function for ANOVA
perform_anova <- function(data, formula) {
  # Perform ANOVA
  aov_result <- aov(formula, data = data)
  
  # Get tidy results
  aov_tidy <- tidy(aov_result)
  
  # Calculate effect size (eta squared)
  es_result <- eta_squared(aov_result)
  
  # Post-hoc tests if significant
  if (any(aov_tidy$p.value < 0.05)) {
    posthoc <- TukeyHSD(aov_result)
    posthoc_tidy <- tidy(posthoc)
  } else {
    posthoc_tidy <- NULL
  }
  
  results <- list(
    anova = aov_result,
    summary = aov_tidy,
    effect_size = es_result,
    posthoc = posthoc_tidy
  )
  
  return(results)
}

# Function for chi-square test
perform_chi_square <- function(data, var1, var2) {
  # Create contingency table
  cont_table <- table(data[[var1]], data[[var2]])
  
  # Perform chi-square test
  chi_result <- chisq.test(cont_table)
  
  # Calculate effect size (Cramér's V)
  es_result <- cramers_v(cont_table)
  
  results <- list(
    test = chi_result,
    table = cont_table,
    effect_size = es_result,
    summary = data.frame(
      chi_square = chi_result$statistic,
      df = chi_result$parameter,
      p_value = chi_result$p.value,
      cramers_v = es_result
    )
  )
  
  return(results)
}

# Function for correlation analysis
perform_correlation <- function(data, vars, method = "pearson") {
  # Calculate correlation matrix
  cor_matrix <- cor(data[vars], use = "complete.obs", method = method)
  
  # Get p-values
  cor_test <- cor_pmat(data[vars], method = method)
  
  results <- list(
    correlation = cor_matrix,
    p_values = cor_test,
    summary = data.frame(
      variable_1 = rep(colnames(cor_matrix), each = ncol(cor_matrix)),
      variable_2 = rep(colnames(cor_matrix), ncol(cor_matrix)),
      correlation = as.vector(cor_matrix),
      p_value = as.vector(cor_test)
    ) %>%
      filter(variable_1 != variable_2)
  )
  
  return(results)
}

# Function for linear regression
perform_regression <- function(data, formula) {
  # Fit model
  model <- lm(formula, data = data)
  
  # Get tidy results
  model_summary <- tidy(model, conf.int = TRUE)
  model_glance <- glance(model)
  
  # Check assumptions
  assumptions <- list(
    residuals = residuals(model),
    fitted = fitted(model),
    qq = qqnorm(residuals(model), plot.it = FALSE)
  )
  
  results <- list(
    model = model,
    coefficients = model_summary,
    model_fit = model_glance,
    assumptions = assumptions
  )
  
  return(results)
}

# Example usage:
# # Summary statistics
# summary_overall <- create_summary_table(data, vars_to_summarize = c("age", "bmi", "score"))
# summary_by_group <- create_summary_table(data, group_var = treatment, vars_to_summarize = c("age", "bmi"))
# 
# # T-test
# t_test_results <- perform_t_test(data, score ~ treatment)
# 
# # ANOVA
# anova_results <- perform_anova(data, score ~ group)
# 
# # Chi-square
# chi_results <- perform_chi_square(data, "treatment", "outcome")
# 
# # Correlation
# cor_results <- perform_correlation(data, c("age", "bmi", "score"))
# 
# # Regression
# reg_results <- perform_regression(data, score ~ age + bmi + treatment)