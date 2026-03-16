{{
  config(
    materialized='table',
    partition_by={
      "field": "snapshot_date",
      "data_type": "date",
      "granularity": "day"
    }
  )
}}

SELECT
    *,
    -- Transformation: Logic for attrition flag
    CASE 
        WHEN attrition_raw IN ('Yes', 'true', 'TRUE') THEN 1 
        ELSE 0 
    END AS attrition_flag
FROM {{ ref('stg_hr_data') }}
