{{
  config(
    materialized='table',
    partition_by={
      "field": "snapshot_date",
      "data_type": "date",
      "granularity": "day"
    },
    cluster_by=["department", "job_role"]
  )
}}

WITH raw_data AS (
    -- Read from the raw staging table that Kestra just created
    SELECT * FROM `hr-analytics-pipeline-490212.hr_analytics_dataset.raw_hr_data`
)

SELECT
    -- 1. Standardize column names into snake_case
    Age AS employee_age,
    Department AS department,
    JobRole AS job_role,
    Gender AS gender,
    MonthlyIncome AS monthly_income,
    YearsAtCompany AS years_at_company,
    
    -- 2. Feature Engineering: FIX - Cast to STRING before comparing
    Attrition AS attrition_status,
    CASE 
        WHEN CAST(Attrition AS STRING) IN ('Yes', 'true', 'TRUE') THEN 1 
        ELSE 0 
    END AS attrition_flag,
    
    -- 3. Data Type Casting: Make sure BigQuery knows this is a real Date
    CAST(snapshot_date AS DATE) AS snapshot_date

FROM raw_data
