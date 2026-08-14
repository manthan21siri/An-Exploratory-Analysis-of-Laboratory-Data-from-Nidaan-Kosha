# An Exploratory Analysis of Laboratory Data from Nidaan Kosha
### Diabetes and Pre-Diabetes Risk Among Young Indian Adults (Age 17–25)

**B.Sc. (Hons.) Statistics Dissertation | Ramanujan College, University of Delhi | Grade: A+**
**Presented at ICET-AICS 2026** — International Conference on Emerging Trends in AI & Computational Sciences

## Overview
This study examines the prevalence of diabetes and pre-diabetes among young Indian adults (17–25 years) — an age group largely absent from existing Indian diabetes research, which typically focuses on adults 30+. Using the **NidaanKosha-100k-V1.0** dataset (real clinical lab records from Indian healthcare institutions, published by Eka.Care via Hugging Face), this project moves beyond self-reported survey data to analyze actual laboratory measurements, avoiding the recall and detection bias inherent in questionnaire-based studies.

A key contribution of this work is the application of **LOINC (Logical Observation Identifiers Names and Codes) standardisation** to resolve severe test-naming heterogeneity across Indian labs — where the same test (e.g. Fasting Blood Glucose) appeared under dozens of different raw names across source institutions.

## Research Questions
1. What percentage of individuals aged 17–25 fall into Normal, Pre-diabetic, and Diabetic categories per ADA/WHO clinical thresholds?
2. Does LOINC standardisation meaningfully reduce naming heterogeneity in raw Indian lab data?
3. Is there a statistically and clinically significant difference in glycaemic markers between males and females in this age group?

## Methodology
- **Data source:** NidaanKosha-100k-V1.0 (Eka.Care, via Hugging Face), filtered to ages 17–25
- **Standardisation:** Raw test names mapped to LOINC codes (2345-7 for Fasting Glucose, 4548-4 for HbA1c), collapsing dozens of inconsistent raw labels into two standardised categories
- **Classification:** Individuals categorized as Normal / Pre-diabetic / Diabetic using ADA/WHO clinical cut-offs (Fasting Glucose and HbA1c thresholds)
- **Statistical testing:** Wilcoxon rank-sum test with effect size (via `rstatix`) to compare male vs. female glycaemic distributions
- **Predictive modelling:** XGBoost classifier (Python) built on 7 raw + 4 engineered features (including TG/HDL ratio and a Glucose × Age interaction term) to flag at-risk individuals using only routine lab data
- **Tools:** R (`dplyr`, `ggplot2`, `rstatix`, `arrow`) for data cleaning, standardisation, and statistical analysis; Python (XGBoost) for predictive modelling

## Key Findings
- **19% of young adults (17–25)** in the sample showed some form of glycaemic abnormality — 14.4% pre-diabetic, 4.78% diabetic — despite this age group rarely being screened
- **LOINC standardisation** collapsed heterogeneous raw test names down to clean, comparable categories per standardised test, demonstrating a replicable approach for Indian clinical datasets
- **Gender comparison:** Males showed statistically significant higher mean values for both Fasting Glucose and HbA1c (Wilcoxon rank-sum test), but the effect size was small — not large enough to justify different clinical screening strategies by gender
- **Predictive model:** XGBoost achieved **AUC-ROC of 0.94**, 90% accuracy, and 83.2% recall at an optimised classification threshold of 0.37 (lowered from the default 0.5 to minimize missed at-risk cases, appropriate for a screening context)
- **Feature importance:** Glucose (27.8%), Gender (12.4%), and a Glucose × Age interaction term (10.1%) were the top predictors — validating that routine, low-cost lab tests (Fasting Glucose + HbA1c) are sufficient for meaningful risk screening, without needing expensive specialized panels

## Visualizations
- Reduction in test name heterogeneity after LOINC standardisation
- Distribution of glycaemic categories (Normal / Pre-diabetic / Diabetic)
- Gender-wise distribution of diabetes categories

## Repository Contents
- `Final_Thesis.pdf` — full dissertation report
- `Research_final_code.R` — complete R analysis pipeline (data cleaning, LOINC standardisation, classification, statistical testing, visualization)
- `visualizations/` — chart exports referenced in the report

## Authors
Manthan, Kartik T, Piyush Arya — B.Sc. (Hons.) Statistics, Ramanujan College, University of Delhi
Under the guidance of Assistant Prof. Killa Anil Kumar, Department of Statistics

[LinkedIn](https://www.linkedin.com/in/manthan-b2088736a)

## Citation Note
This dissertation uses the publicly available NidaanKosha-100k-V1.0 dataset (Eka.Care, 2024), accessed via Hugging Face. Full references are available in the dissertation PDF.
