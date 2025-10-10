# GCP Terraform Configuration Guide

This guide explains how to configure and connect Google Cloud Platform (GCP) with Terraform from a Terraform server.

---

## **1. Prerequisites**

Before setting up Terraform with GCP, ensure the following:

* You have a **GCP Project** created.
* You have **Owner** or **Editor** permissions on that project.
* You have **Terraform** installed on your Terraform server.
* You have **gcloud CLI** installed to manage GCP authentication.

---

## **2. Install Required Packages**

### **Install Terraform**

```bash
sudo apt-get update -y
sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update -y
sudo apt-get install terraform -y
terraform -version
```

### **Install gcloud CLI (Google Cloud SDK)**

```bash
sudo apt-get install apt-transport-https ca-certificates gnupg -y
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
  sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update -y
sudo apt-get install google-cloud-sdk -y
gcloud version
```

---

## **3. Authenticate with GCP**

### **Step 1: Initialize gcloud**

```bash
gcloud init
```

Follow the prompts to authenticate using your Google account and select the desired project.

### **Step 2: Create a Service Account**

```bash
gcloud iam service-accounts create terraform-sa \
  --description="Service Account for Terraform" \
  --display-name="terraform-sa"
```

### **Step 3: Assign Roles to Service Account**

```bash
gcloud projects add-iam-policy-binding <PROJECT_ID> \
  --member="serviceAccount:terraform-sa@<PROJECT_ID>.iam.gserviceaccount.com" \
  --role="roles/editor"
```

### **Step 4: Create and Download Key File**

```bash
gcloud iam service-accounts keys create ~/terraform-key.json \
  --iam-account terraform-sa@<PROJECT_ID>.iam.gserviceaccount.com
```

### **Step 5: Set Environment Variable for Authentication**

```bash
export GOOGLE_APPLICATION_CREDENTIALS="~/terraform-key.json"
```

> ⚠️ Ensure you securely store this key file and avoid committing it to version control.

---

## **4. Terraform GCP Provider Configuration**

### **Example `main.tf`**

```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
  }
}

provider "google" {
  credentials = file("~/terraform-key.json")
  project     = "<PROJECT_ID>"
  region      = "us-central1"
  zone        = "us-central1-a"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}
```

### **Initialize Terraform**

```bash
terraform init
```

### **Validate Configuration**

```bash
terraform validate
```

### **Plan Deployment**

```bash
terraform plan
```

### **Apply Configuration**

```bash
terraform apply -auto-approve
```

---

## **5. Verify Resources in GCP**

After applying the Terraform plan, verify the created resources in the GCP Console:

* Navigate to **VPC Network → VPC Networks**.
* You should see `terraform-network` created by Terraform.

---

## **6. Storing Terraform State in GCS Bucket (Optional)**

If you want to store Terraform state in a GCS (Google Cloud Storage) bucket, follow these steps:

### **Create GCS Bucket**

```bash
gsutil mb -p <PROJECT_ID> gs://<BUCKET_NAME>/
```

### **Update Terraform Configuration**

```hcl
terraform {
  backend "gcs" {
    bucket = "<BUCKET_NAME>"
    prefix = "terraform/state"
  }
}
```

### **Reinitialize Backend**

```bash
terraform init -migrate-state
```

---

## **7. Cleanup Resources**

When done testing, destroy all Terraform-managed resources:

```bash
terraform destroy -auto-approve
```

---

## **8. Summary**

✅ Install Terraform and gcloud CLI
✅ Authenticate using a GCP Service Account
✅ Configure the GCP provider in Terraform
✅ Optionally store Terraform state in a GCS bucket
✅ Manage and destroy resources easily using Terraform

---

**Author:** DevOps Setup Guide
**Last Updated:** October 2025
