library(arrow)
library(dplyr)
library(ggplot2)
library(rstatix)

setwd("C:/Users/tkart/OneDrive/Desktop/Final year Research")

# read data sets
d1 <- read_parquet("nidaan1.parquet")
d2 <- read_parquet("nidaan2.parquet")
final_data <- bind_rows(d1, d2)

# Removing NA values
final_data <- final_data %>%
  filter(
    !is.na(age),
    !is.na(gender),
    !is.na(test_name),
    !is.na(value),
    !is.na(loinc),
    age >= 18 & age <= 25
  )

# cleaning the data
final_data <- final_data %>%
  mutate(
    value = tolower(trimws(as.character(value))),
    unit = tolower(trimws(as.character(unit))),
    value_numeric = suppressWarnings(as.numeric(value))
  ) %>%
  filter(!is.na(value_numeric))

# standardizing tests names for easier analysis
final_data <- final_data %>%
  mutate(
    test_group = case_when(
      loinc == "4548-4" ~ "HbA1c",
      loinc == "1558-6" ~ "Fasting Glucose",
      TRUE ~ NA_character_
    )
  ) %>%
  filter(!is.na(test_group))

# fixing hba1c unit issues
final_data <- final_data %>%
  mutate(
    value_numeric = ifelse(
      test_group == "HbA1c" & value_numeric > 20,
      NA,
      value_numeric
    )
  ) %>%
  filter(!is.na(value_numeric))

View(final_data)

# categorizing diabetes data
final_data <- final_data %>%
  mutate(
    diabetes_category = case_when(
      test_group == "Fasting Glucose" & value_numeric < 100 ~ "Normal",
      test_group == "Fasting Glucose" & value_numeric >= 100 & value_numeric < 126 ~ "Pre-diabetic",
      test_group == "Fasting Glucose" & value_numeric >= 126 ~ "Diabetic",
      test_group == "HbA1c" & value_numeric < 5.7 ~ "Normal",
      test_group == "HbA1c" & value_numeric >= 5.7 & value_numeric < 6.5 ~ "Pre-diabetic",
      test_group == "HbA1c" & value_numeric >= 6.5 ~ "Diabetic",
      TRUE ~ NA_character_
    )
  )

# descriptive
desc_stats <- final_data %>%
  group_by(test_group) %>%
  summarise(
    n = n(),
    mean = round(mean(value_numeric, na.rm = TRUE), 2),
    median = round(median(value_numeric, na.rm = TRUE), 2),
    sd = round(sd(value_numeric, na.rm = TRUE), 2),
    min = min(value_numeric, na.rm = TRUE),
    max = max(value_numeric, na.rm = TRUE),
    Q1 = quantile(value_numeric, 0.25, na.rm = TRUE),
    Q3 = quantile(value_numeric, 0.75, na.rm = TRUE),
    IQR = IQR(value_numeric, na.rm = TRUE)
  )
desc_stats

# Sample prevalence
prevalence_table <- final_data %>%
  filter(!is.na(diabetes_category)) %>%
  count(diabetes_category) %>%
  mutate(
    percentage = round((n / sum(n)) * 100, 2)
  )

prevalence_table

ggplot(final_data %>% filter(!is.na(diabetes_category)), aes(x = diabetes_category)) +
  geom_bar(fill = "steelblue") +
  labs(
    x = "Diabetes Category",
    y = "Count",
    title = "Distribution of Glycaemic Categories (Age 17–25)"
  ) +
  theme_minimal()



# Comparing for genders
rq2_data <- final_data %>%
  filter(!is.na(diabetes_category))

gender_distribution <- rq2_data %>%
  count(gender, diabetes_category) %>%
  group_by(gender) %>%
  mutate(
    percentage = round((n / sum(n)) * 100, 2)
  )

gender_distribution

ggplot(gender_distribution,
       aes(x = diabetes_category, y = percentage, fill = gender)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    x = "Diabetes Category",
    y = "Percentage",
    title = "Gender-wise Distribution(Age 17–25)"
  ) +
  theme_minimal()

# Loinc heterogeneity
rq3_summary <- final_data %>%
  group_by(loinc, test_group) %>%
  summarise(
    unique_raw_test_names = n_distinct(test_name),
    .groups = "drop"
  )

rq3_summary

ggplot(rq3_summary,
       aes(x = test_group, y = unique_raw_test_names, fill = test_group)) +
  geom_bar(stat = "identity") +
  labs(
    x = "Standardized Test (LOINC)",
    y = "Number of Unique Raw Test Names",
    title = "Reduction in Test Name Heterogeneity Using LOINC"
  ) +
  theme_minimal()

final_data <- final_data %>%
  select(-specimen, -document_id)

View(final_data)

# Plotting for HbA1c
hba1c_data <- final_data %>%
  filter(test_group == "HbA1c")

ggplot(hba1c_data, aes(x = gender, y = value_numeric)) +
  geom_boxplot(fill = "lightgrey", outlier.colour = "red") +
  labs(
    
    x = "Gender",
    y = "HbA1c (%)",
    title = "Distribution of HbA1c by Gender (Age 17–25)"
  ) +
  theme_minimal()

# create subsets for testing
fasting_data <- final_data %>%
  filter(test_group == "Fasting Glucose")

hba1c_data <- final_data %>%
  filter(test_group == "HbA1c")

# Final results(testing significant difference in the genders)

fasting_test <- wilcox.test(value_numeric ~ gender, data = fasting_data)
hba1c_test <- wilcox.test(value_numeric ~ gender, data = hba1c_data)

fasting_effect <- fasting_data %>%
  wilcox_effsize(value_numeric ~ gender)

hba1c_effect <- hba1c_data %>%
  wilcox_effsize(value_numeric ~ gender)

fasting_test
hba1c_test
fasting_effect
hba1c_effect