{{ config(materialized='table', cluster_by=['department']) }}

SELECT
    *,
    -- New Transformation: Income Brackets
    CASE 
        WHEN monthly_income < 5000 THEN 'Entry Level'
        WHEN monthly_income BETWEEN 5000 AND 10000 THEN 'Mid Level'
        ELSE 'Senior Level'
    END AS income_bracket
FROM {{ ref('stg_hr_data') }}
