{{ config(materialized='view') }}

WITH raw_data AS (
    SELECT * FROM `{{ env_var('GCP_PROJECT_ID') }}.hr_analytics_dataset.raw_hr_data`
)

SELECT
    -- Clean naming and type casting
    CAST(Age AS INT64) AS employee_age,
    Department AS department,
    JobRole AS job_role,
    Gender AS gender,
    CAST(MonthlyIncome AS FLOAT64) AS monthly_income,
    CAST(YearsAtCompany AS INT64) AS years_at_company,
    CAST(Attrition AS STRING) AS attrition_raw,
    CAST(snapshot_date AS DATE) AS snapshot_date
FROM raw_data
