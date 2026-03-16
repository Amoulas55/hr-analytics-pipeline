terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6.0"
    }
  }
}

# Tell Terraform how to authenticate and where to build
provider "google" {
  credentials = file("../google_credentials.json")
  project     = var.project
  region      = var.region
}

# 1. Create the Data Lake (Google Cloud Storage Bucket)
resource "google_storage_bucket" "data-lake-bucket" {
  name          = var.gcs_bucket_name
  location      = var.location
  force_destroy = true 

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

# 2. Create the Data Warehouse (Google BigQuery Dataset)
resource "google_bigquery_dataset" "dataset" {
  dataset_id                 = var.bq_dataset_name
  location                   = var.location
  delete_contents_on_destroy = true
}