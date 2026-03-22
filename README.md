# 📊 HR Analytics Data Pipeline: Employee Attrition Deep-Dive
**Data Engineering Zoomcamp Final Project**

![Dashboard Screenshot](zoomcamp_project_visualizations.png)

## 🎯 1. Problem Statement & Dataset
Employee attrition is a massive hidden cost for modern organizations. This project builds an automated batch data pipeline to process HR data, allowing executives to track global attrition rates and pinpoint high-risk departments instantly.

* **Dataset Used:** IBM HR Analytics Employee Attrition & Performance (via Kaggle)
* **Goal:** Automate ingestion into a Data Lake, transform the data in a Data Warehouse, and serve it to an interactive BI dashboard.

---

## 🛠️ 2. Technologies & Architecture Flow
This project utilizes a modern data stack deployed in the Google Cloud Platform (GCP).

* **Infrastructure as Code:** Terraform
* **Orchestration:** Kestra
* **Data Lake:** Google Cloud Storage (GCS)
* **Data Warehouse:** Google BigQuery
* **Transformation:** dbt (Data Build Tool)
* **BI Tool:** Tableau

### Pipeline Flow
1. **Data Lake (GCS):** Kestra orchestrates the upload of the raw HR `.csv` file into a GCS bucket.
2. **Data Warehouse (BigQuery):** Data is loaded into a raw table in BigQuery.
3. **Transformations (dbt):** dbt executes SQL transformations directly inside BigQuery to clean and aggregate the data.
4. **Dashboard (Tableau):** Data was extracted from BigQuery to build the interactive dashboard offline.

---

## 🗄️ 3. Data Warehouse & dbt Transformations
To ensure cost-efficiency and performance, the BigQuery tables were optimized and transformed using **dbt**.

### The dbt Models:
* **`stg_hr_data`:** Cleans raw data, standardizes column names to `snake_case`, and casts correct data types (e.g., casting age to `INT64`).
* **`dim_employees`:** Creates an employee dimension table and introduces feature-engineered columns using dbt conditional logic.
* **`fct_attrition_stats`:** The core fact table containing the binary `attrition_flag` used for dashboard metrics.

### Optimization (Partitioning & Clustering):
* **Partitioned by `snapshot_date` (Daily):** Ensures that when querying specific historical days, BigQuery only scans that day's partition, reducing compute costs.
* **Clustered by `department`:** Since the BI dashboard heavily filters by department, clustering organizes this data physically to speed up query execution.

---

## 📈 4. The Dashboard
The dashboard was built using **Tableau** and satisfies all project requirements:
* **Categorical Distribution:** A bar chart displaying attrition rates across the three company departments, identifying Sales as the highest-risk area.
* **Temporal Distribution:** A line chart showing "Attrition by Years at Company." This trend analysis visualizes turnover risk across the employee lifecycle.
* **KPI Tiles:** High-level scorecards for Total Headcount and Global Attrition Rate.
* **Interactivity:** Every chart acts as a filter, allowing users to drill down into specific data points.

---

## 🚀 5. Reproducibility: Step-by-Step Instructions
*Note: Because this project provisions real cloud resources, you must provide your own GCP project and credentials.*

### Prerequisites
1. **GCP Account:** You need an active Google Cloud Platform account and a new Project.
2. **Service Account:** Create a Service Account in your GCP Project with the `BigQuery Admin` and `Storage Admin` roles. 
3. **Credentials:** Generate a JSON key for this Service Account. Download it, rename it exactly to `google_credentials.json`, and keep it handy.
4. **Local Tools:** Ensure you have [Git](https://git-scm.com/), [Terraform](https://www.terraform.io/downloads), and [Docker](https://www.docker.com/) installed on your machine.

---

### Step 1: Provision Infrastructure (Terraform)
First, we will build the Google Cloud Storage bucket and BigQuery dataset.

1. Open your terminal and clone this repository:
   ```bash
   git clone [https://github.com/Amoulas55/hr-analytics-pipeline.git](https://github.com/Amoulas55/hr-analytics-pipeline.git)
   cd hr-analytics-pipeline
   ```
2. Move your `google_credentials.json` file directly into this main `hr-analytics-pipeline` folder. Make sure it's name is `google_credentials.json`.
3. Navigate into the Terraform folder:
   ```bash
   cd terraform
   ```
4. Open the `variables.tf` file in a text editor. Find the `project_id` variable and replace the default value with your actual GCP Project ID.
5. Initialize and apply the Terraform configuration:
   ```bash
   terraform init
   terraform apply
   ```
### Step 2: Orchestration (Kestra)
Next, we will start Kestra to move the data into the cloud.
**🚨 IMPORTANT:** Make sure **Docker Desktop** is open and the engine is fully running (green status) before proceeding with the commands below.
1. Navigate back to the main project folder:
   ```bash
   cd ..
2. Download the Kestra Docker Compose file and start the container:
   ```bash
   curl -o docker-compose.yml https://raw.githubusercontent.com/kestra-io/kestra/develop/docker-compose.yml
   docker compose up -d
   ```
3. Wait about 30 seconds, then open your web browser and go to: `http://localhost:8080`
4. On the left sidebar, click Flows, then click the Create button at the top right.
5. Open the **orchestration/ folder** in this GitHub repository, copy all the text inside the YAML file, and paste it into the Kestra editor.
6. **CRITICAL**: Look at the variables: section at the top of the YAML code. Update `gcp_project_id` and `gcp_bucket_name` to match the ones Terraform just created for you.
7. Click **Save** and then **Execute**. 


### Step 3: Automated dbt Transformations
* You do **not** need to run dbt commands manually! 
1. Once you click Execute in Kestra, watch the Gantt chart in the UI.
2. The Kestra pipeline is fully automated: it will upload the raw data to GCS, load it into BigQuery, and then automatically pull the dbt/ folder from this GitHub repository.
3. It will install the dbt-bigquery adapter and run dbt build directly inside your BigQuery warehouse, creating the partitioned and clustered stg_hr_data, dim_employees, and fct_attrition_stats tables.
  

### Step 4: Visualizing (Tableau)
To view the interactive dashboard, reviewers have two options:
1. **View the Packaged Workbook (Recommended):** Download the `hr_attrition_dashboard.twbx` file included in this repository. You can open this file using Tableau Desktop or the free Tableau Reader (https://www.tableau.com/products/reader)  to interact with the visualizations.
2. **Recreate from Scratch (Optional):** If you wish to connect it to your own BigQuery instance:
   * Open Tableau and connect to your Google BigQuery.
   * Import the `fct_attrition_stats` table from your dataset.
   * Use the `attrition_flag` (set to Average) to calculate the attrition rate, and use the `department` and `Years At Company` fields to recreate the breakdown visuals.
---

## 🎥 Demo Video
