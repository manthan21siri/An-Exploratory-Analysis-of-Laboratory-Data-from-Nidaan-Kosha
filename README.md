# An Exploratory Analysis of Laboratory Data from Nidaan Kosha
### Diabetes and Pre-Diabetes Risk Among Young Indian Adults (Age 17–25)

**B.Sc. (Hons.) Statistics Research Project | Ramanujan College, University of Delhi | Grade: A+**
**Presented at ICET-AICS 2026** — International Conference on Emerging Trends in AI & Computational Sciences, 7–8 April 2026

## Overview
Type 2 diabetes was once considered a disease of middle and older age in India. This study examines a largely under-researched question: how common is undetected blood sugar abnormality among young adults aged 17–25, a group almost entirely absent from India's major diabetes studies (which typically fold this cohort into broader 20–79 or 20–40 age brackets).

Rather than relying on self-reported surveys — which cannot detect diabetes in people who have never been tested, and where India's undiagnosed-to-diagnosed diabetes ratio is estimated at roughly 10:1 — this study uses the **NidaanKosha-100k-V1.0** dataset: real, anonymised clinical laboratory records compiled from digitised Indian hospital reports and released publicly by Eka.Care via Hugging Face.

## Research Questions
1. **RQ1:** What percentage of individuals aged 17–25 fall into Normal, Pre-diabetic, and Diabetic categories per standard ADA/WHO medical thresholds?
2. **RQ2:** How does LOINC (Logical Observation Identifiers Names and Codes) standardisation resolve the problem of different laboratories using different names for the same test, and how much does it reduce this naming confusion?
3. **RQ3:** Is there a statistically and clinically significant difference in blood sugar levels and diabetes/pre-diabetes risk between young males and females?

## Methodology
Carried out in four phases:
- **Phase 1 — Cleaning & Standardisation (R):** Removed missing/irrelevant records; mapped raw, inconsistent lab test names (e.g. "FBS", "Blood Glucose", "Fasting Plasma Glucose") to standardised **LOINC codes** (2345-7 for Fasting Glucose, 4548-4 for HbA1c), resolving naming heterogeneity across source hospitals.
- **Phase 2 — Descriptive Statistics & Classification (R):** Computed mean, median, SD, and IQR for each test; classified individuals into Normal / Pre-diabetic / Diabetic using ADA/WHO clinical cut-offs.
- **Phase 3 — Gender Comparison (R):** Since the data did not follow a simple statistical pattern, used the **Wilcoxon rank-sum test** with effect size (via `rstatix`) to compare fasting glucose and HbA1c distributions between males and females.
- **Phase 4 — Predictive Modelling (Python):** Built an **XGBoost** classifier to flag diabetes risk using only routine lab markers, engineering 4 composite features (including a TG/HDL ratio and a Glucose × Age interaction term) on top of 7 raw lab values.

**Tools:** R (`dplyr`, `ggplot2`, `rstatix`, `arrow`), Python (XGBoost)

## Key Findings
- **RQ1 — Prevalence:** 80.8% of the sample (5,379 individuals) fell in the Normal range, 14.4% (958) were Pre-diabetic, and 4.78% (318) were Diabetic. Combined, **roughly 1 in 5 young adults (≈19%)** showed some glycaemic abnormality — a population where routine screening essentially does not happen.
- **RQ2 — LOINC Standardisation:** Before standardisation, Fasting Glucose alone appeared under far more unique raw test names than after mapping to a single LOINC code — the same pattern held for HbA1c. This confirms LOINC mapping as a practical, replicable way to make heterogeneous Indian lab data analytically usable.
- **RQ3 — Gender Comparison:** The Wilcoxon rank-sum test found a statistically significant difference, with males showing marginally higher mean Fasting Glucose and HbA1c than females. However, the **effect size was small** — meaning the difference, while statistically real, is not large enough to justify different clinical screening strategies by gender. A single, universal screening approach for this age group is supported by the data.
- **Predictive Model:** The XGBoost classifier achieved **AUC-ROC of 0.94**, 90% overall accuracy, and 83.2% recall at an optimised decision threshold of 0.37 (lowered from the default 0.5, since in a screening context a missed at-risk patient is more costly than a false alarm). The top predictive features were Glucose (27.8% importance), Gender (12.4%), and a Glucose × Age interaction term (10.1%) — independently validating what the EDA had already found.
- **Practical implication:** Because Glucose and HbA1c alone drive most of the model's predictive power, the findings support a low-cost, two-test screening approach (Fasting Glucose + HbA1c) as sufficient for flagging at-risk young adults — without needing expensive specialised panels.

## Visualisations
- Reduction in test-name heterogeneity after LOINC standardisation (Fasting Glucose vs. HbA1c)
- Distribution of glycaemic categories, ages 17–25 (Normal / Pre-diabetic / Diabetic)
- Gender-wise distribution of diabetes categories

## Repository Contents
- `Research_final_code.R` — full R pipeline: data cleaning, LOINC standardisation, descriptive statistics, clinical classification, Wilcoxon testing, and visualisation
- `visualizations/` — chart exports referenced above

## Authors
Manthan, Kartik T, Piyush Arya — B.Sc. (Hons.) Statistics, Ramanujan College, University of Delhi
Under the guidance of Assistant Prof. Killa Anil Kumar, Department of Statistics

[LinkedIn](https://www.linkedin.com/in/manthan-b2088736a)

## Data Source
NidaanKosha-100k-V1.0 (Eka.Care, 2024), accessed via [Hugging Face](https://huggingface.co/datasets/ekacare/NidaanKosha-100k-V1.0). Full literature review and references available on request.
