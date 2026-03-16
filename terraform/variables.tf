variable "project" {
  description = "GCP Project ID"
  default     = "hr-analytics-pipeline-490212"
}

variable "region" {
  description = "GCP Region"
  default     = "europe-west4"
}

variable "location" {
  description = "Project Location"
  default     = "EU"
}

variable "bq_dataset_name" {
  description = "BigQuery Dataset Name"
  default     = "hr_analytics_dataset"
}

variable "gcs_bucket_name" {
  description = "Google Cloud Storage Bucket Name"
  default     = "hr-analytics-data-lake-490212" 
}