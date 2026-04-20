# ==============================================================================
# Introduction to Data Wrangling and Visualization in R
# Using the Tidyverse with the 'iris' Dataset
# ==============================================================================

# 1. LOAD LIBRARIES
# The tidyverse includes dplyr (wrangling), ggplot2 (viz), and others.
# install.packages("tidyverse") # Run this once if not installed
library(tidyverse)

# ==============================================================================
# STEP 1: LOAD AND EXPLORE DATA
# ==============================================================================

# Load the built-in dataset
data(iris)

# Convert to a 'tibble' (a modern version of a data frame)
# This makes it print more nicely in the console.
iris_tbl <- as_tibble(iris)

# Explore the structure
names(iris_tbl)      # View column names
dim(iris_tbl)        # See number of rows (150) and columns (5)
str(iris_tbl)        # Look at data types (numeric vs factor)
glimpse(iris_tbl)    # A Tidyverse-specific way to see a data summary

# ==============================================================================
# STEP 2: GET SUMMARY STATISTICS
# ==============================================================================

# Quick base R summary of all columns
summary(iris_tbl)

# ==============================================================================
# STEP 3: DATA WRANGLING WITH DPLYR
# ==============================================================================

# The Pipe Operator ( %>% ) means "and then..."
# It passes the result of one line to the next.
# Shortcut to get the 

# --- Example 3a: Create new variables, filter, and select ---
iris_modified <- iris_tbl %>%
  # Create a new column 'Sepal.Area'
  mutate(Sepal.Area = Sepal.Length * Sepal.Width) %>%
  # Keep only rows where Sepal.Length is greater than 5
  filter(Sepal.Length > 5) %>%
  # Select only specific columns to keep
  select(Species, Sepal.Length, Sepal.Area) %>%
  # Sort by Area in descending order
  arrange(desc(Sepal.Area))

print(iris_modified)

# --- Example 3b: Summarise data by groups ---
# This is the "Split-Apply-Combine" workflow
iris_stats <- iris_tbl %>%
  group_by(Species) %>%
  summarise(
    sample_size = n(),                       # Count number of rows
    mean_petal_len = mean(Petal.Length),     # Calculate average
    sd_petal_len = sd(Petal.Length),         # Standard Deviation
    median_petal_len = median(Petal.Length)  # Median
  )

print(iris_stats)

# ==============================================================================
# STEP 4: VISUALIZATION WITH GGPLOT2
# ==============================================================================

# Logic of ggplot: Data + Aesthetics (aes) + Geometry (geom)

# --- 4a: Bar Chart ---
# Showing the average petal length per species (using our summary table)
bar_chart <- ggplot(data = iris_stats, aes(x = Species, y = mean_petal_len, fill = Species)) +
  geom_col() + 
  theme_minimal() +
  labs(title = "Average Petal Length by Species", y = "Mean Length (cm)")

print(bar_chart)

# --- 4b: Histogram ---
# Showing the distribution of Sepal Width
histogram_plot <- ggplot(data = iris_tbl, aes(x = Sepal.Width)) +
  geom_histogram(binwidth = 0.2, fill = "steelblue", color = "white") +
  theme_light() +
  labs(title = "Distribution of Sepal Width", x = "Width (cm)", y = "Frequency")

print(histogram_plot)

# --- 4c: Scatter Plot with Linear Regression ---
# Mapping Color to Species creates 3 distinct groups/lines
scatter_plot <- ggplot(data = iris_tbl, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point(size = 2, alpha = 0.7) +                  # Add the points
  geom_smooth(method = "lm", se = FALSE) +            # Add linear regression lines
  theme_bw() +                                         # A cleaner theme
  labs(
    title = "Sepal Length vs. Width",
    subtitle = "Grouped by Species with Linear Regression Lines",
    x = "Sepal Length (cm)",
    y = "Sepal Width (cm)"
  )

print(scatter_plot)

# ==============================================================================
# STEP 5: EXPORTING FIGURES
# ==============================================================================

# ggsave saves the last plot displayed (or a specific plot object)
ggsave("iris_scatter_plot.png", plot = scatter_plot, width = 8, height = 6, dpi = 300)
