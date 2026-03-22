# 📊 HR Analytics Data Pipeline: Employee Attrition Deep-Dive
**Data Engineering Zoomcamp Final Project**

![Dashboard Screenshot](zoomcamp_project_visualizations.png)

## 🎯 1. Problem Statement
Employee attrition is a massive hidden cost for modern organizations. Human Resources teams often struggle to proactively identify which departments are at risk of high turnover because their data is siloed, messy, and requires manual Excel updates. 

**The Goal:** Develop an end-to-end, fully automated batch data pipeline that simulates daily HR data ingestion, archives it in a Data Lake, transforms it in a Data Warehouse, and serves it to an interactive BI dashboard. This allows HR executives to track global attrition rates and pinpoint high-risk departments instantly.

---

## 🛠️ 2. Technologies & Architecture
This project utilizes a modern data stack, entirely deployed in the cloud.

* **Cloud Provider:** Google Cloud Platform (GCP)
* **Infrastructure as Code (IaC):** Terraform
* **Workflow Orchestration:** Kestra
* **Data Lake:** Google Cloud Storage (GCS)
* **Data Warehouse:** Google BigQuery
* **Data Transformation:** dbt (Data Build Tool)
* **Business Intelligence:** Tableau

### Architecture Diagram / Pipeline Flow
1. **Extraction:** A Python script simulates daily batch drops of employee data.
2. **Data Lake (GCS):** Kestra orchestrates the upload of raw `.csv` files into a GCS bucket.
3. **Data Warehouse (BigQuery):** Data is loaded into a raw Bronze table in BigQuery.
4. **Transformations (dbt):** dbt executes a Medallion Architecture (Bronze -> Silver -> Gold) directly inside BigQuery.
5. **Dashboard (Tableau):** A live connection to the final Gold table serves the interactive dashboard.

---

## 🗄️ 3. Data Warehouse & dbt Transformations
To ensure cost-efficiency and performance, the BigQuery tables were heavily optimized and transformed using **dbt**.

### Medallion Architecture:
* **`stg_hr_data` (Silver View):** Cleans raw data, standardizes column names to `snake_case`, and casts correct data types (e.g., casting age to `INT64`).
* **`dim_employees` (Gold Table):** Creates an employee dimension table. Introduces a feature-engineered column (`income_bracket`) using dbt conditional logic.
* **`fct_attrition_stats` (Gold Table):** The core fact table containing the binary `attrition_flag` used for dashboard metrics.

### Optimization (Partitioning & Clustering):
* **Partitioned by `snapshot_date` (Daily):** Ensures that when HR queries specific historical days, BigQuery only scans that day's partition, drastically reducing compute costs.
* **Clustered by `department`:** Since the BI dashboard heavily filters and categorizes by department, clustering organizes this data together physically to speed up query execution.

---

## 📈 4. The Dashboard
The dashboard was built using **Tableau** and contains multiple analytical tiles to satisfy business needs:
1. **Categorical Distribution:** A bar chart displaying the attrition rate distributed across the three main company departments. 
2. **Key Performance Indicators (KPIs):** High-level scorecards tracking total company headcount and the global attrition rate.
3. **Interactivity:** A functional filter allows the user to slice the entire dashboard by specific Job Roles.

---

## 🚀 5. Reproducibility: How to Run This Project
Follow these detailed steps to replicate the entire pipeline from scratch.

### Prerequisites
* A Google Cloud Platform (GCP) account.
* A GCP Service Account with `BigQuery Admin` and `Storage Admin` roles. Download the JSON key.
* Terraform installed locally.
* Docker installed locally (to run Kestra).

### Step 1: Infrastructure as Code (Terraform)
1. Clone this repository to your local machine.
2. Navigate to the `/terraform` directory.
3. Update the `variables.tf` file with your specific `project_id` and GCP region.
4. Initialize and apply the infrastructure:
   ```bash
   terraform init
   terraform plan
   terraform apply
