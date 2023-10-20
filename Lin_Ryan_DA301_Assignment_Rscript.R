## LSE Data Analytics Online Career Accelerator 

# DA301:  Advanced Analytics for Organisational Impact

###############################################################################

## In particular, from this analysis in R,Turtle Games wants to understand (order of analysis):
## - what is the impact on sales per product and by platform
## - the reliability of the data (e.g. normal distribution, Skewness, Kurtosis)
## - if there is any possible relationship(s) in sales between North America,
##     Europe, and global sales.

################################################################################

# 4: EDA using R

## It is recommended to restart R before installing the requested packages below

###############################################################################

# 1. Load and explore the data

# Install and load necessary packages
packages_to_install <- c("tidyverse", "dplyr", "gridExtra", "ggplot2", "car", "moments", "nortest")

# Install packages if not already installed
install_if_missing <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(new_packages)) install.packages(new_packages)
}

install_if_missing(packages_to_install)

# Load required libraries
library(tidyverse)
library(dplyr)
library(ggplot2)
library(gridExtra)
library(car)
library(moments)
library(nortest)

# Get the current working directory
# current_directory <- getwd()

# Print the current working directory
# print(current_directory)

# Set the working directory to a specific folder if required
# setwd("/Users/RyanLin/Google Drive/My Drive/LSE Data Analytics/Course 3 - Advanced Analytics for Organisational Impact /DA301_final_assignment")

# Import the data set.
turtle_sales <- read.csv("turtle_sales.csv")

# View the imported data 
View(turtle_sales)

# Create a new data frame from a subset of the sales data frame.
subset_turtle_sales <- subset(turtle_sales, select = -c(Ranking, Year, Genre, Publisher))

# Print the subset of the data frame
print(subset_turtle_sales)

# View the data frame.
View(subset_turtle_sales)

# View the descriptive statistics.
summary(subset_turtle_sales)

# List columns names
colnames(subset_turtle_sales)

################################################################################

# 2. Sales by Platform

# Create a boxplot of Global_Sales by Platform
boxplot(Global_Sales ~ Platform, data = subset_turtle_sales,
        xlab = "Platform", ylab = "Global Sales (M)",
        main = "Boxplot of Global Sales by Platform")

# Create a bar chart of Global Sales by Platform
barplot(tapply(subset_turtle_sales$Global_Sales, subset_turtle_sales$Platform, sum),
        main = "Global Sales by Platform",
        xlab = "Platform",
        ylab = "Global Sales (M)")

# Create a grouped bar chart by Platform
ggplot(subset_turtle_sales, aes(x = Platform, y = Global_Sales, fill = Platform)) +
  geom_bar(stat = "identity") +
  labs(title = "Global Sales by Platform", x = "Platform", y = "Global Sales (M)") +
  theme_minimal() +
  theme(legend.position = "bottom") # Adjust legend position (other options available)

# Descending order of Global Sales by Platform 

# Sum the Global_Sales by Platform and arrange in descending order
platform_sales <- subset_turtle_sales %>%
  group_by(Platform) %>%
  summarize(Sum_Sales = sum(Global_Sales))

# Arrange the platforms in descending order of total sales
platform_sales <- platform_sales[order(-platform_sales$Sum_Sales), ]

# Create a descending order histogram with percentage labels
ggplot(platform_sales, aes(x = factor(Platform, levels = Platform), y = Sum_Sales, fill = Platform)) +
  geom_bar(stat = "identity") +
  labs(title = "Sum of Global Sales by Platform",
       x = "Platform",
       y = "Sum of Global Sales (M)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  
  # Add percentage labels on top of the bars
  geom_text(aes(label = paste0(round((Sum_Sales / sum(Sum_Sales)) * 100, 2), "%")),
            vjust = -0.5, size = 3)

# Descending order of NA and EU Sales by Platform 
# Sum NA_Sales by Platform
na_sales_by_platform <- subset_turtle_sales %>%
  group_by(Platform) %>%
  summarize(Sum_NA_Sales = sum(NA_Sales))

# Arrange the platforms in descending order of total NA_Sales
na_sales_by_platform <- na_sales_by_platform[order(-na_sales_by_platform$Sum_NA_Sales), ]

# Create a descending order histogram for NA_Sales
ggplot(na_sales_by_platform, aes(x = factor(Platform, levels = Platform), y = Sum_NA_Sales, fill = Platform)) +
  geom_bar(stat = "identity") +
  labs(title = "Sum of NA_Sales by Platform",
       x = "Platform",
       y = "Sum of NA_Sales (M)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for better readability

# Sum EU_Sales by Platform
eu_sales_by_platform <- subset_turtle_sales %>%
  group_by(Platform) %>%
  summarize(Sum_EU_Sales = sum(EU_Sales))

# Arrange the platforms in descending order of total EU_Sales
eu_sales_by_platform <- eu_sales_by_platform[order(-eu_sales_by_platform$Sum_EU_Sales), ]

# Create a descending order histogram for EU_Sales
ggplot(eu_sales_by_platform, aes(x = factor(Platform, levels = Platform), y = Sum_EU_Sales, fill = Platform)) +
  geom_bar(stat = "identity") +
  labs(title = "Sum of EU_Sales by Platform",
       x = "Platform",
       y = "Sum of EU_Sales (M)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for better readability

# Create a histogram of Global_Sales
hist(subset_turtle_sales$Global_Sales, 
     xlab = "Global Sales (M)", ylab = "Frequency",
     main = "Histogram of Global Sales")
  
# 3. Determine the impact on sales per product_id.

# Group data based on Product and determine the sum per Product.
product_summaries <- subset_turtle_sales %>%
  group_by(Product) %>%
  summarize(Total_NA_Sales = sum(NA_Sales),
            Total_EU_Sales = sum(EU_Sales),
            Total_Global_Sales = sum(Global_Sales))

# View the data frame.
View(product_summaries)

# Explore the data frame.
# Create a summary of the new data frame
summary(product_summaries)

## 3a) Bar plot of Total Global Sales by Product

# Create a bar plot of Total Global Sales by Product
barplot(product_summaries$Total_Global_Sales, names.arg = product_summaries$Product,
        xlab = "Product", ylab = "Total Global Sales",
        main = "Total Global Sales by Product")

## 3b) Highest and Lowest product sales

# Sort the product_summaries dataframe by Total_Global_Sales in descending order
sorted_product_summaries <- product_summaries %>%
  arrange(desc(Total_Global_Sales))

# Extract the top 10 highest and lowest global sales products
top_10_highest <- head(sorted_product_summaries, 10)
top_10_lowest <- tail(sorted_product_summaries, 10)

# Combine the two subsets for plotting
combined_data <- rbind(
  data.frame(Product = top_10_highest$Product, Sales = "Top 10 Highest", Total_Global_Sales = top_10_highest$Total_Global_Sales),
  data.frame(Product = top_10_lowest$Product, Sales = "Top 10 Lowest", Total_Global_Sales = top_10_lowest$Total_Global_Sales)
)

# Create a bar plot
ggplot(combined_data, aes(x = reorder(Product, Total_Global_Sales), y = Total_Global_Sales, fill = Sales)) +
  geom_bar(stat = "identity") +
  labs(title = "Top 10 Highest and Lowest Global Sales Products",
       x = "Product",
       y = "Total Global Sales",
       fill = "Sales Category") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

## 4) Priliminary Exploration of the Relationship between NA, EU and Global Sales

# Create a boxplot for all three sales data columns
ggplot(subset_turtle_sales, aes(x = factor(1), y = NA_Sales)) +
  geom_boxplot(fill = "lightblue") +
  geom_boxplot(aes(x = factor(2), y = EU_Sales), fill = "lightgreen") +
  geom_boxplot(aes(x = factor(3), y = Global_Sales), fill = "lightcoral") +
  labs(title = "Boxplot of Sales Data", x = NULL, y = "Sales (£M)") +
  scale_x_discrete(labels = c("NA Sales", "EU Sales", "Global Sales")) +
  theme_minimal()


## 4a) Scatterplots for different combinations of sales columns

# Create scatterplots for different combinations of sales columns
scatterplot1 <- ggplot(subset_turtle_sales, aes(x = NA_Sales, y = Global_Sales)) +
  geom_point() +
  labs(title = "Scatterplot: NA Sales vs. Global Sales")

scatterplot2 <- ggplot(subset_turtle_sales, aes(x = EU_Sales, y = Global_Sales)) +
  geom_point() +
  labs(title = "Scatterplot: EU Sales vs. Global Sales")

scatterplot3 <- ggplot(subset_turtle_sales, aes(x = NA_Sales, y = EU_Sales)) +
  geom_point() +
  labs(title = "Scatterplot: NA Sales vs. EU Sales")

# Create a single figure with the three scatterplots side by side
combined_figure <- grid.arrange(scatterplot1, scatterplot2, scatterplot3, ncol = 3)

# Display the combined figure
print(combined_figure)

## As there are extreme outlines present, the outliers were removed using 
## the IQR Method to have a better visualisation of the relationship between sales data

# Function to remove outliers using the IQR method
remove_outliers <- function(data, column) {
  Q1 <- quantile(data[[column]], 0.25)
  Q3 <- quantile(data[[column]], 0.75)
  IQR <- Q3 - Q1
  lower_bound <- Q1 - 1.5 * IQR
  upper_bound <- Q3 + 1.5 * IQR
  data <- data[data[[column]] >= lower_bound & data[[column]] <= upper_bound, ]
  return(data)
}

# Remove outliers and create a new dataset for all three sales columns
subset_turtle_sales_cleaned <- subset_turtle_sales
subset_turtle_sales_cleaned <- remove_outliers(subset_turtle_sales_cleaned, "Global_Sales")
subset_turtle_sales_cleaned <- remove_outliers(subset_turtle_sales_cleaned, "NA_Sales")
subset_turtle_sales_cleaned <- remove_outliers(subset_turtle_sales_cleaned, "EU_Sales")


# Create a boxplot for all three sales data columns with outliers removed
ggplot(subset_turtle_sales_cleaned, aes(x = factor(1), y = NA_Sales)) +
  geom_boxplot(fill = "lightblue") +
  geom_boxplot(aes(x = factor(2), y = EU_Sales), fill = "lightgreen") +
  geom_boxplot(aes(x = factor(3), y = Global_Sales), fill = "lightcoral") +
  labs(title = "Boxplot of Sales Data (Outliers Removed)", x = NULL, y = "Sales (£M)") +
  scale_x_discrete(labels = c("NA Sales", "EU Sales", "Global Sales")) +
  theme_minimal()


# Create scatterplots after removing outliers
scatterplot1 <-ggplot(subset_turtle_sales_cleaned, aes(x = NA_Sales, y = Global_Sales)) +
  geom_point() +
  labs(title = "Scatterplot: NA Sales vs. Global Sales")

scatterplot2 <-ggplot(subset_turtle_sales_cleaned, aes(x = EU_Sales, y = Global_Sales)) +
  geom_point() +
  labs(title = "Scatterplot: EU Sales vs. Global Sales")

scatterplot3 <-ggplot(subset_turtle_sales_cleaned, aes(x = NA_Sales, y = EU_Sales)) +
  geom_point() +
  labs(title = "Scatterplot: NA Sales vs. EU Sales")

# Create a single figure with the three scatterplots side by side
combined_figure <- grid.arrange(scatterplot1, scatterplot2, scatterplot3, ncol = 3)

# Display the combined figure
print(combined_figure)


###############################################################################

# 3. Observations and insights

## Your observations and insights here ......




###############################################################################
###############################################################################


# 5: Cleaning and maniulating data using R

################################################################################

# 1. Load and explore the data

# View data frame created in Week 4.
View(subset_turtle_sales)

# Check output: Determine the min, max, and mean values.
# View the descriptive statistics.
summary(subset_turtle_sales)

###############################################################################

## 2. Exploring the Relationship between NA, EU and Global Sales

# 2a). Determine the normality of the data set.

# Create histograms and Q-Q Plots of sales data

par(mfrow = c(3, 2))  # Set the layout to 3 rows and 2 columns

# Plot and arrange histograms
hist(subset_turtle_sales$NA_Sales, 
     xlab = "NA Sales", ylab = "Frequency",
     main = "Histogram of NA Sales",
     col = "lightblue")

# Plot and arrange QQ plots
qqnorm(subset_turtle_sales$NA_Sales, main = "QQ Plot of NA Sales")
qqline(subset_turtle_sales$NA_Sales)

hist(subset_turtle_sales$EU_Sales, 
     xlab = "EU Sales", ylab = "Frequency",
     main = "Histogram of EU Sales",
     col = "lightgreen")

qqnorm(subset_turtle_sales$EU_Sales, main = "QQ Plot of EU Sales")
qqline(subset_turtle_sales$EU_Sales)

hist(subset_turtle_sales$Global_Sales, 
     xlab = "Global Sales", ylab = "Frequency",
     main = "Histogram of Global Sales",
     col = "lightcoral")

qqnorm(subset_turtle_sales$Global_Sales, main = "QQ Plot of Global Sales")
qqline(subset_turtle_sales$Global_Sales)

## 2b) Perform Shapiro-Wilk test

# Perform the Shapiro-Wilk test on NA_Sales
shapiro.test(subset_turtle_sales$NA_Sales)

# Perform the test for EU_Sales and Global_Sales as well
shapiro.test(subset_turtle_sales$EU_Sales)
shapiro.test(subset_turtle_sales$Global_Sales)

# Perform the Anderson-Darling test on NA_Sales

ad.test(subset_turtle_sales$NA_Sales)

# Perform the test for EU_Sales and Global_Sales as well
ad.test(subset_turtle_sales$EU_Sales)
ad.test(subset_turtle_sales$Global_Sales)

## 2c) Determine Skewness and Kurtosis

# Select only the numeric columns
numeric_subset <- select_if(subset_turtle_sales, is.numeric)

# Calculate skewness for each numeric column
skew_values <- sapply(numeric_subset, skewness)

# Calculate kurtosis for each numeric column
kurtosis_values <- sapply(numeric_subset, kurtosis)

# Display skewness values
print("Skewness:")
print(skew_values)

# Display kurtosis values
print("Kurtosis:")
print(kurtosis_values)

## 2d) Determine correlation
# Determine correlation.
# Calculate the correlation matrix for the sales data columns
correlation_matrix <- cor(subset_turtle_sales[c("NA_Sales", "EU_Sales", "Global_Sales")])

# Print the correlation matrix
print(correlation_matrix)

## In all three tests (NA_Sales, EU_Sales, and Global_Sales), the p-values 
## are far less than 0.05 (p-value < 2.2e-16), indicating that the sales data 
##is not normally distributed. This is expected in sales data, 
## which often has a skewed distribution.

## These positive skewness values confirm that the data is right-skewed, 
## which is typical in sales data.

## The Kurtosis values confirm that your sales data has heavy tails 
## and more extreme values than a normal distribution.

## The strong positive correlations between these columns (close to 1) indicate
## that they are positively related. An increase in one type of sales is associated 
## with an increase in the others, which is expected. 

###############################################################################

# 3. Ploting the relationship betweem sales

# library(ggplot2)
# library(gridExtra)

# Create scatterplots with trend lines
plot1 <- ggplot(subset_turtle_sales, aes(x = NA_Sales, y = EU_Sales)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(title = "Correlation: NA Sales vs. EU Sales",
       x = "NA Sales",
       y = "EU Sales") +
  theme_minimal()

plot2 <- ggplot(subset_turtle_sales, aes(x = NA_Sales, y = Global_Sales)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "green") +
  labs(title = "Correlation: NA Sales vs. Global Sales",
       x = "NA Sales",
       y = "Global Sales") +
  theme_minimal()

plot3 <- ggplot(subset_turtle_sales, aes(x = EU_Sales, y = Global_Sales)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Correlation: EU Sales vs. Global Sales",
       x = "EU Sales",
       y = "Global Sales") +
  theme_minimal()

# Arrange the plots side-by-side
grid.arrange(plot1, plot2, plot3, ncol = 3)


###############################################################################

# 4. Multiple Linear Regression of Sales Data

## From the findings above which indicated that the sales 
## data does not follow a normal distribution, exhibits high 
## positive skewness and kurtosis. This implies that a transformation
## is required to properly conduct any regression models. A log 
## transformation was done on the sales columns and linearity was then 
## checked through scatter plots, normality through QQ plots, Shapiro-Wilk test, 
## skewness, and kurtosis. 

## First, try removing outliers, then run the regression model
# install.packages("Metrics")

# Load required libraries
# library(dplyr)
# library(ggplot2)
# library(Metrics)
# library(car)
# library(tidyr)

# Reset layout
par(mfrow = c(1, 1))  # Reset layout to a single panel (1x1)

# Create boxplots for each sales column of original (as seen above)
boxplot1 <- subset_turtle_sales %>%
  gather(key = "SalesType", value = "SalesValue", NA_Sales, EU_Sales, Global_Sales) %>%
  ggplot(aes(x = SalesType, y = SalesValue)) +
  geom_boxplot() +
  labs(title = "Boxplots of Sales Data", x = "Sales Type", y = "Sales Value")

# Create boxplots for each sales column of outlier removed sales
boxplot2 <- subset_turtle_sales_cleaned %>%
  gather(key = "SalesType", value = "SalesValue", NA_Sales, EU_Sales, Global_Sales) %>%
  ggplot(aes(x = SalesType, y = SalesValue)) +
  geom_boxplot() +
  labs(title = "Boxplots of Sales Data (outliers removed)", x = "Sales Type", y = "Sales Value")

# Arrange the two boxplots vertically (first above the second)
combined_boxplots <- grid.arrange(boxplot1, boxplot2, ncol = 1)

# Display the combined figure
print(combined_boxplots)

# Define a function to remove outliers using IQR method (completed above)
# Remove outliers for each sales column (completed above)

# Fit your linear regression model
lm_model <- lm(Global_Sales ~ NA_Sales, data = subset_turtle_sales_cleaned)

# Check for normality of residuals
residuals_cleaned <- resid(lm_model)

# Reset layout
par(mfrow = c(1, 2))

# Create a histogram of residuals
hist(residuals_cleaned, main = "Histogram of Residuals", xlab = "Residuals")

# Create a Q-Q plot of residuals
qqPlot(residuals_cleaned, main = "Q-Q Plot of Residuals")

# Check the normality of residuals using a Shapiro-Wilk test
shapiro.test(residuals_cleaned)

## Small p-value indicated residual do not follow a normal distribution.

###############################################################################

# Log-transform the sales columns in the original data frame
subset_turtle_sales$log_NA_Sales <- log(subset_turtle_sales$NA_Sales)
subset_turtle_sales$log_EU_Sales <- log(subset_turtle_sales$EU_Sales)
subset_turtle_sales$log_Global_Sales <- log(subset_turtle_sales$Global_Sales)

# Set up a layout for multiple plots (1 row, 3 columns)
par(mfrow = c(1, 3))

# Create scatterplot for log(North American Sales) vs. log(EU Sales)
plot(subset_turtle_sales$log_NA_Sales, subset_turtle_sales$log_EU_Sales, 
     main = "Scatterplot: log(North American Sales) vs. log(EU Sales)",
     xlab = "log(North American Sales)",
     ylab = "log(EU Sales")

# Create scatterplot for log(NA Sales) vs. log(Global Sales)
plot(subset_turtle_sales$log_NA_Sales, subset_turtle_sales$log_Global_Sales, 
     main = "Scatterplot: log(North American Sales) vs. log(Global Sales)",
     xlab = "log(North American Sales)",
     ylab = "log(Global Sales)")

# Create scatterplot for log(EU Sales) vs. log(Global Sales)
plot(subset_turtle_sales$log_EU_Sales, subset_turtle_sales$log_Global_Sales, 
     main = "Scatterplot: log(EU Sales) vs. log(Global Sales)",
     xlab = "log(EU Sales)",
     ylab = "log(Global Sales)")

# Reset the layout to the default (1 plot per figure)
par(mfrow = c(1, 1))

## QQ Plots

## Check for Non-finite Values

any(!is.finite(subset_turtle_sales$log_NA_Sales))
any(!is.finite(subset_turtle_sales$log_EU_Sales))
any(!is.finite(subset_turtle_sales$log_Global_Sales))

## Filter out rows containing no-finite values
# Create a new dataframe with non-finite rows removed
cleaned_df <- subset_turtle_sales[!is.infinite(subset_turtle_sales$log_NA_Sales) & !is.infinite(subset_turtle_sales$log_EU_Sales) & !is.infinite(subset_turtle_sales$log_Global_Sales), c("Product", "Platform", "log_NA_Sales", "log_EU_Sales", "log_Global_Sales")]

# Create histograms and QQ plots for log-transformed sales columns
ggplot(cleaned_df, aes(x = log_NA_Sales)) +
  geom_histogram(binwidth = 0.2, fill = "lightblue") +
  labs(title = "Histogram of log(North American Sales)", x = "log(North American Sales)") +
  theme_minimal()

qqPlot(cleaned_df$log_NA_Sales, main = "QQ Plot of log(North American Sales)")

ggplot(cleaned_df, aes(x = log_EU_Sales)) +
  geom_histogram(binwidth = 0.2, fill = "lightgreen") +
  labs(title = "Histogram of log(EU Sales)", x = "log(EU Sales)") +
  theme_minimal()

qqPlot(cleaned_df$log_EU_Sales, main = "QQ Plot of log(EU Sales)")

ggplot(cleaned_df, aes(x = log_Global_Sales)) +
  geom_histogram(binwidth = 0.2, fill = "lightcoral") +
  labs(title = "Histogram of log(Global Sales)", x = "log(Global Sales)") +
  theme_minimal()

qqPlot(cleaned_df$log_Global_Sales, main = "QQ Plot of log(Global Sales)")

# Create a layout for the plots
layout(matrix(1:6, ncol = 3))

# Create histograms and QQ plots for log-transformed sales columns
par(mar = c(4, 4, 2, 2))  # Adjust margins for better appearance

# Plot 1 (Histogram on the left, QQ Plot on the right)
hist(cleaned_df$log_NA_Sales, main = "Histogram of log(North American Sales)", xlab = "log(North American Sales)", col = "lightblue")
par(mar = c(4, 2, 2, 2))  # Adjust margin for the right plot
qqnorm(cleaned_df$log_NA_Sales)
qqline(cleaned_df$log_NA_Sales)

# Plot 2 (Histogram on the left, QQ Plot on the right)
hist(cleaned_df$log_EU_Sales, main = "Histogram of log(EU Sales)", xlab = "log(EU Sales)", col = "lightgreen")
par(mar = c(4, 2, 2, 2))  # Adjust margin for the right plot
qqnorm(cleaned_df$log_EU_Sales)
qqline(cleaned_df$log_EU_Sales)

# Plot 3 (Histogram on the left, QQ Plot on the right)
hist(cleaned_df$log_Global_Sales, main = "Histogram of log(Global Sales)", xlab = "log(Global Sales)", col = "lightcoral")
par(mar = c(4, 2, 2, 2))  # Adjust margin for the right plot
qqnorm(cleaned_df$log_Global_Sales)
qqline(cleaned_df$log_Global_Sales)

## Perform Shapiro-Wilk test

# Perform the Shapiro-Wilk test on log-transformed NA_Sales, EU_Sales, Global_Sales 
shapiro.test(cleaned_df$log_NA_Sales)
shapiro.test(cleaned_df$log_EU_Sales)
shapiro.test(cleaned_df$log_Global_Sales)

# Determine Skewness and Kurtosis

# Calculate skewness for log-transformed sales data
skewness_values <- sapply(cleaned_df[, c("log_NA_Sales", "log_EU_Sales", "log_Global_Sales")], skewness)

# Calculate kurtosis for log-transformed sales data
kurtosis_values <- sapply(cleaned_df[, c("log_NA_Sales", "log_EU_Sales", "log_Global_Sales")], kurtosis)

# Display skewness values
print("Skewness:")
print(skewness_values)

# Display kurtosis values
print("Kurtosis:")
print(kurtosis_values)

# The Log-transformed sales data still produces non-normal distribution of data. Another option is to try a square root transformation

###############################################################################

# Square root transform the sales columns
subset_turtle_sales$sqrt_NA_Sales <- sqrt(subset_turtle_sales$NA_Sales)
subset_turtle_sales$sqrt_EU_Sales <- sqrt(subset_turtle_sales$EU_Sales)
subset_turtle_sales$sqrt_Global_Sales <- sqrt(subset_turtle_sales$Global_Sales)

# Set up a layout for multiple plots (1 row, 3 columns)
par(mfrow = c(1, 3))

# Create scatterplot for sqrt(North American Sales) vs. sqrt(EU Sales)
plot(subset_turtle_sales$sqrt_NA_Sales, subset_turtle_sales$sqrt_EU_Sales, 
     main = "Scatterplot: sqrt(North American Sales) vs. sqrt(EU Sales)",
     xlab = "sqrt(North American Sales)",
     ylab = "sqrt(EU Sales)")

# Create scatterplot for sqrt(NA Sales) vs. sqrt(Global Sales)
plot(subset_turtle_sales$sqrt_NA_Sales, subset_turtle_sales$sqrt_Global_Sales, 
     main = "Scatterplot: sqrt(North American Sales) vs. sqrt(Global Sales)",
     xlab = "sqrt(North American Sales)",
     ylab = "sqrt(Global Sales)")

# Create scatterplot for sqrt(EU Sales) vs. sqrt(Global Sales)
plot(subset_turtle_sales$sqrt_EU_Sales, subset_turtle_sales$sqrt_Global_Sales, 
     main = "Scatterplot: sqrt(EU Sales) vs. sqrt(Global Sales)",
     xlab = "sqrt(EU Sales)",
     ylab = "sqrt(Global Sales)")

# Reset the layout to the default (1 plot per figure)
par(mfrow = c(1, 1))

## QQ Plots

## Check for Non-finite Values

any(!is.finite(subset_turtle_sales$sqrt_NA_Sales))
any(!is.finite(subset_turtle_sales$sqrt_EU_Sales))
any(!is.finite(subset_turtle_sales$sqrt_Global_Sales))

## Filter out rows containing non-finite values
# Create a new dataframe with non-finite rows removed
cleaned_df_sqrt <- subset_turtle_sales[!is.infinite(subset_turtle_sales$sqrt_NA_Sales) & !is.infinite(subset_turtle_sales$sqrt_EU_Sales) & !is.infinite(subset_turtle_sales$sqrt_Global_Sales), c("Product", "Platform", "sqrt_NA_Sales", "sqrt_EU_Sales", "sqrt_Global_Sales")]

# Create a layout for the plots
layout(matrix(1:6, ncol = 3))

# Create histograms and QQ plots for square root-transformed sales columns
par(mar = c(4, 4, 2, 2))  # Adjust margins for better appearance

# Plot 1 (Histogram on the left, QQ Plot on the right)
hist(cleaned_df_sqrt$sqrt_NA_Sales, main = "Histogram of sqrt(North American Sales)", xlab = "sqrt(North American Sales)", col = "lightblue")
par(mar = c(4, 2, 2, 2))  # Adjust margin for the right plot
qqnorm(cleaned_df_sqrt$sqrt_NA_Sales)
qqline(cleaned_df_sqrt$sqrt_NA_Sales)

# Plot 2 (Histogram on the left, QQ Plot on the right)
hist(cleaned_df_sqrt$sqrt_EU_Sales, main = "Histogram of sqrt(EU Sales)", xlab = "sqrt(EU Sales)", col = "lightgreen")
par(mar = c(4, 2, 2, 2))  # Adjust margin for the right plot
qqnorm(cleaned_df_sqrt$sqrt_EU_Sales)
qqline(cleaned_df_sqrt$sqrt_EU_Sales)

# Plot 3 (Histogram on the left, QQ Plot on the right)
hist(cleaned_df_sqrt$sqrt_Global_Sales, main = "Histogram of sqrt(Global Sales)", xlab = "sqrt(Global Sales)", col = "lightcoral")
par(mar = c(4, 2, 2, 2))  # Adjust margin for the right plot
qqnorm(cleaned_df_sqrt$sqrt_Global_Sales)
qqline(cleaned_df_sqrt$sqrt_Global_Sales)

## Perform Shapiro-Wilk test

# Perform the Shapiro-Wilk test on square root-transformed NA_Sales, EU_Sales, Global_Sales
shapiro.test(cleaned_df_sqrt$sqrt_NA_Sales)
shapiro.test(cleaned_df_sqrt$sqrt_EU_Sales)
shapiro.test(cleaned_df_sqrt$sqrt_Global_Sales)

# Determine Skewness and Kurtosis for square root-transformed data
skewness_values_sqrt <- sapply(cleaned_df_sqrt[, c("sqrt_NA_Sales", "sqrt_EU_Sales", "sqrt_Global_Sales")], skewness)
kurtosis_values_sqrt <- sapply(cleaned_df_sqrt[, c("sqrt_NA_Sales", "sqrt_EU_Sales", "sqrt_Global_Sales")], kurtosis)

# Display skewness and kurtosis values for square root-transformed data
print("Skewness (Square Root-Transformed Data):")
print(skewness_values_sqrt)
print("Kurtosis (Square Root-Transformed Data):")
print(kurtosis_values_sqrt)


# The most important assumption in linear regression is the normality of the residuals, 
# not the predictor variables (sales data). You should check the normality of the residuals 
# by examining a histogram or a Q-Q plot of the residuals. 
# If the residuals are approximately normally distributed, this assumption may not be violated.

###############################################################################

# Fitting the linear Regression Models

## Original Sales Data

# Fit your linear regression model on the original dataset (replace with your actual model)
model <- lm(Global_Sales ~ NA_Sales + EU_Sales, data = subset_turtle_sales)

summary(model)

# Extract the residuals
residuals <- residuals(model)

# Set up a layout for multiple plots
par(mfrow = c(1, 2))

# Create a histogram of residuals
hist(residuals, main = "Histogram of Residuals (Original Dataset)", xlab = "Residuals")

# Create a Q-Q plot of residuals
qqnorm(residuals)
qqline(residuals)

# Check the normality of residuals using a Shapiro-Wilk test
shapiro.test(residuals)

###############################################################################

## Outlier Removed Sales Data

# Fit your linear regression model on the outlier-removed dataset
model_cleaned <- lm(Global_Sales ~ NA_Sales + EU_Sales, data = subset_turtle_sales_cleaned)

# Summary of the model
summary(model_cleaned)

# Extract the residuals
residuals_cleaned <- residuals(model_cleaned)

# Set up a layout for multiple plots
par(mfrow = c(1, 2))

# Create a histogram of residuals
hist(residuals_cleaned, main = "Histogram of Residuals (Outlier Removed)", xlab = "Residuals")

# Create a Q-Q plot of residuals
qqnorm(residuals_cleaned)
qqline(residuals_cleaned)

# Check the normality of residuals using a Shapiro-Wilk test
shapiro.test(residuals_cleaned)

###############################################################################
## Log tranformed Sales Data

# Log-transform the sales columns
subset_turtle_sales_cleaned$log_NA_Sales <- log(subset_turtle_sales_cleaned$NA_Sales)
subset_turtle_sales_cleaned$log_EU_Sales <- log(subset_turtle_sales_cleaned$EU_Sales)
subset_turtle_sales_cleaned$log_Global_Sales <- log(subset_turtle_sales_cleaned$Global_Sales)

# Remove rows with problematic values in the log-transformed data
subset_turtle_sales_removed <- subset_turtle_sales_cleaned[is.finite(subset_turtle_sales_cleaned$log_NA_Sales) &
                                                             is.finite(subset_turtle_sales_cleaned$log_EU_Sales) &
                                                             is.finite(subset_turtle_sales_cleaned$log_Global_Sales), ]

# Fit your linear regression model on the log-transformed dataset using subset_turtle_sales_removed
model_log <- lm(log(Global_Sales) ~ log(NA_Sales) + log(EU_Sales), data = subset_turtle_sales_removed)

# Summary of the model
summary(model_log)

# Extract the residuals
residuals_log <- residuals(model_log)

# Set up a layout for multiple plots
par(mfrow = c(1, 2))

# Create a histogram of residuals
hist(residuals_log, main = "Histogram of Residuals (Log-Transformed)", xlab = "Residuals")

# Create a Q-Q plot of residuals
qqnorm(residuals_log)
qqline(residuals_log)

# Check the normality of residuals using a Shapiro-Wilk test
shapiro.test(residuals_log)


###############################################################################
## Square-root tranformed Sales Data

# Fit your linear regression model on the square root-transformed dataset
model_sqrt <- lm(sqrt(Global_Sales) ~ sqrt(NA_Sales) + sqrt(EU_Sales), data = subset_turtle_sales)

# Summary of the model
summary(model_sqrt)

# Extract the residuals
residuals_sqrt <- residuals(model_sqrt)

# Set up a layout for multiple plots
par(mfrow = c(1, 2))

# Create a histogram of residuals
hist(residuals_sqrt, main = "Histogram of Residuals (Square Root-Transformed)", xlab = "Residuals")

# Create a Q-Q plot of residuals
qqnorm(residuals_sqrt)
qqline(residuals_sqrt)

# Check the normality of residuals using a Shapiro-Wilk test
shapiro.test(residuals_sqrt)

###############################################################################

# Compare linear regression models for the original sales data, 
# the outlier-removed data, log-transformed sales data, and square root-transformed sales data

# Create a list of models and their descriptions
model_list <- list(
  Original_Data = model,
  Outlier_Removed = model_cleaned,
  Log_Transformed = model_log,
  Sqrt_Transformed = model_sqrt
)

# Initialize a data frame to store model metrics
model_metrics <- data.frame(Model = character(0), R2 = numeric(0), Adj_R2 = numeric(0), RMSE = numeric(0), SW_p_value = numeric(0))

# Loop through the models
for (model_name in names(model_list)) {
  model <- model_list[[model_name]]
  
  # Calculate R-squared
  r2 <- summary(model)$r.squared
  
  # Calculate Adjusted R-squared
  adj_r2 <- summary(model)$adj.r.squared
  
  # Calculate RMSE
  residuals <- residuals(model)
  rmse <- sqrt(mean(residuals^2))
  
  # Check the normality of residuals
  sw_p_value <- shapiro.test(residuals)$p.value
  
  # Append model metrics to the data frame
  model_metrics <- rbind(model_metrics, data.frame(Model = model_name, R2 = r2, Adj_R2 = adj_r2, RMSE = rmse, SW_p_value = sw_p_value))
}

# Display the model metrics
print(model_metrics)

## The square root model had the strongest relationship (R-squared)
## with normally distributed residuals and lowest RMSE.

# 4. Predictions based on given values (using the Sqrt_Transformed model)
# Compare with observed values for a number of records.

# Coefficients of the square root-transformed model
intercept <- coef(model_sqrt)[1]
coeff_na_sales <- coef(model_sqrt)[2]
coeff_eu_sales <- coef(model_sqrt)[3]

# Provided values
values <- data.frame(
  NA_Sales_sum = c(34.02, 3.93, 2.73, 2.26, 22.08),
  EU_Sales_sum = c(23.80, 1.56, 0.65, 0.97, 0.52)
)

# Square root transformation
values$sqrt_NA_Sales_sum <- sqrt(values$NA_Sales_sum)
values$sqrt_EU_Sales_sum <- sqrt(values$EU_Sales_sum)

# Predict global sales using the coefficients from the square root-transformed model
predicted_sales <- exp(intercept + coeff_na_sales * values$sqrt_NA_Sales_sum + coeff_eu_sales * values$sqrt_EU_Sales_sum)

# Display the predictions
predicted_sales


###############################################################################

# 5. Observations and insights of predicted values

## 1.	For the first set of values with 'NA_Sales_sum' of 34.02 and 'EU_Sales_sum' of 23.80, 
## the predicted global sales are approximately 5053.26. This suggests that with high 'NA_Sales'  
## and 'EU_Sales' values, the predicted global sales are relatively high.
## 2.	For the second set of values with 'NA_Sales_sum' of 3.93 and 'EU_Sales_sum' of 1.56, 
## the predicted global sales are approximately 14.34. These lower values for 'NA_Sales' and 
## 'EU_Sales' result in a much lower predicted global sales.
## 3.	Similarly, for the third and fourth sets of values with lower 'NA_Sales_sum' and 'EU_Sales_sum', 
#  the predicted global sales are also relatively low.
## 4.	For the fifth set of values with 'NA_Sales_sum' of 22.08 and 'EU_Sales_sum' of 0.52, 
## the predicted global sales are approximately 98.26. This indicates that even with high 'NA_Sales'
#  and relatively lower 'EU_Sales', the global sales are predicted to be relatively high.



###############################################################################
###############################################################################




