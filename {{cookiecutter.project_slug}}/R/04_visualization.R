# 04_visualization.R
# Purpose: Create visualizations for the analysis
# Author: {{ cookiecutter.author_name }}
# Date: {{ cookiecutter.year }}

# Load required packages
library(tidyverse)
library(ggplot2)
library(scales)
library(patchwork)
library(viridis)

# Set theme for all plots
theme_set(theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", hjust = 0.5),
    legend.position = "bottom"
  ))

# Color palette
color_palette <- c(
  "#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd",
  "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf"
)

# Function to create histogram with density overlay
create_histogram <- function(data, x_var, fill_var = NULL, bins = 30) {
  p <- ggplot(data, aes(x = .data[[x_var]])) +
    geom_histogram(aes(y = after_stat(density), fill = if(!is.null(fill_var)) .data[[fill_var]] else NULL), 
                   bins = bins, alpha = 0.7, color = "white") +
    geom_density(aes(color = if(!is.null(fill_var)) .data[[fill_var]] else NULL), size = 1) +
    scale_fill_manual(values = color_palette) +
    scale_color_manual(values = color_palette) +
    labs(
      x = str_to_title(str_replace_all(x_var, "_", " ")),
      y = "Density",
      fill = if(!is.null(fill_var)) str_to_title(str_replace_all(fill_var, "_", " ")) else NULL,
      color = if(!is.null(fill_var)) str_to_title(str_replace_all(fill_var, "_", " ")) else NULL
    )
  
  return(p)
}

# Function to create boxplot
create_boxplot <- function(data, x_var, y_var, fill_var = NULL) {
  p <- ggplot(data, aes(x = .data[[x_var]], y = .data[[y_var]], 
                        fill = if(!is.null(fill_var)) .data[[fill_var]] else NULL)) +
    geom_boxplot(alpha = 0.7, outlier.shape = 21, outlier.size = 2) +
    geom_jitter(width = 0.2, alpha = 0.3, size = 1) +
    scale_fill_manual(values = color_palette) +
    labs(
      x = str_to_title(str_replace_all(x_var, "_", " ")),
      y = str_to_title(str_replace_all(y_var, "_", " ")),
      fill = if(!is.null(fill_var)) str_to_title(str_replace_all(fill_var, "_", " ")) else NULL
    )
  
  return(p)
}

# Function to create scatter plot with regression line
create_scatter <- function(data, x_var, y_var, color_var = NULL, add_smooth = TRUE) {
  p <- ggplot(data, aes(x = .data[[x_var]], y = .data[[y_var]], 
                        color = if(!is.null(color_var)) .data[[color_var]] else NULL)) +
    geom_point(alpha = 0.6, size = 2)
  
  if (add_smooth) {
    p <- p + geom_smooth(method = "lm", se = TRUE, alpha = 0.2)
  }
  
  p <- p +
    scale_color_manual(values = color_palette) +
    labs(
      x = str_to_title(str_replace_all(x_var, "_", " ")),
      y = str_to_title(str_replace_all(y_var, "_", " ")),
      color = if(!is.null(color_var)) str_to_title(str_replace_all(color_var, "_", " ")) else NULL
    )
  
  return(p)
}

# Function to create bar plot with error bars
create_barplot <- function(data, x_var, y_var, error_var = NULL, fill_var = NULL) {
  p <- ggplot(data, aes(x = .data[[x_var]], y = .data[[y_var]], 
                        fill = if(!is.null(fill_var)) .data[[fill_var]] else NULL)) +
    geom_bar(stat = "identity", position = position_dodge(width = 0.9), alpha = 0.8)
  
  if (!is.null(error_var)) {
    p <- p + geom_errorbar(
      aes(ymin = .data[[y_var]] - .data[[error_var]], 
          ymax = .data[[y_var]] + .data[[error_var]]),
      position = position_dodge(width = 0.9),
      width = 0.2
    )
  }
  
  p <- p +
    scale_fill_manual(values = color_palette) +
    labs(
      x = str_to_title(str_replace_all(x_var, "_", " ")),
      y = str_to_title(str_replace_all(y_var, "_", " ")),
      fill = if(!is.null(fill_var)) str_to_title(str_replace_all(fill_var, "_", " ")) else NULL
    )
  
  return(p)
}

# Function to create correlation heatmap
create_correlation_heatmap <- function(cor_matrix, show_values = TRUE) {
  # Convert to long format
  cor_long <- cor_matrix %>%
    as.data.frame() %>%
    rownames_to_column("var1") %>%
    pivot_longer(-var1, names_to = "var2", values_to = "correlation")
  
  p <- ggplot(cor_long, aes(x = var1, y = var2, fill = correlation)) +
    geom_tile(color = "white") +
    scale_fill_gradient2(
      low = "#313695", mid = "white", high = "#a50026",
      midpoint = 0, limits = c(-1, 1),
      name = "Correlation"
    ) +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      axis.title = element_blank()
    ) +
    coord_fixed()
  
  if (show_values) {
    p <- p + geom_text(
      aes(label = sprintf("%.2f", correlation)),
      size = 3
    )
  }
  
  return(p)
}

# Function to save plots
save_plot <- function(plot, filename, width = 8, height = 6, dpi = 300) {
  output_path <- here::here("output", "figures", filename)
  
  ggsave(
    filename = output_path,
    plot = plot,
    width = width,
    height = height,
    dpi = dpi
  )
  
  message(paste("Plot saved to:", output_path))
}

# Function to create a publication-ready figure with multiple panels
create_multipanel_figure <- function(plots, ncol = 2, labels = "AUTO") {
  combined <- wrap_plots(plots, ncol = ncol) +
    plot_annotation(tag_levels = labels)
  
  return(combined)
}

# Example usage:
# # Create individual plots
# hist_plot <- create_histogram(data, age, fill_var = treatment)
# box_plot <- create_boxplot(data, treatment, score)
# scatter_plot <- create_scatter(data, age, score, color_var = treatment)
# 
# # Combine plots
# combined_figure <- create_multipanel_figure(
#   list(hist_plot, box_plot, scatter_plot),
#   ncol = 2
# )
# 
# # Save plots
# save_plot(combined_figure, "figure1_combined_analysis.png", width = 12, height = 8)