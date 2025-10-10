# Azure Terraform Configuration Guide

This guide explains how to configure and connect Microsoft Azure with Terraform from a Terraform server.

---

## **1. Prerequisites**

Before setting up Terraform with Azure, ensure the following:

* You have an **Azure subscription** with active access.
* You have **Terraform** installed on your Terraform server.
* You have the **Azure CLI** installed to authenticate with Azure.
* You have **permissions** to create resources in your Azure subscription.

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

### **Install Azure CLI**

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az version
```

---

## **3. Authenticate with Azure**

### **Option 1: Login Using Azure CLI (Recommended for Personal Accounts)**

```bash
az login
```

A browser window will open prompting you to log in to your Azure account.

Once logged in, note your **Subscription ID**:

```bash
az account show --query id -o tsv
```

### **Option 2: Service Principal Authentication (Recommended for Automation)**

#### **Step 1: Create a Service Principal**

```bash
az ad sp create-for-rbac --name "terraform-sp" --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
```

This command outputs credentials similar to:

```json
{
  "appId": "xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx",
  "displayName": "terraform-sp",
  "password": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx",
  "tenant": "xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx"
}
```

#### **Step 2: Export Environment Variables**

```bash
export ARM_CLIENT_ID="<appId>"
export ARM_CLIENT_SECRET="<password>"
export ARM_SUBSCRIPTION_ID="<subscription_id>"
export ARM_TENANT_ID="<tenant>"
```

> ⚠️ Make sure to store these credentials securely and avoid committing them to version control.

---

## **4. Configure Terraform Azure Provider**

### **Example `main.tf`**

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "terraform-rg"
  location = "East US"
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

## **5. Verify Resources in Azure Portal**

After applying the Terraform plan, verify the created resources:

* Log in to the **Azure Portal** → **Resource Groups**
* You should see a resource group named `terraform-rg`

---

## **6. Storing Terraform State in Azure Storage Account (Optional)**

If you want to store your Terraform state file remotely in an Azure Storage Account, follow these steps:

### **Step 1: Create a Resource Group**

```bash
az group create --name terraform-storage-rg --location eastus
```

### **Step 2: Create a Storage Account**

```bash
az storage account create \
  --name terraformstateacct \
  --resource-group terraform-storage-rg \
  --location eastus \
  --sku Standard_LRS
```

### **Step 3: Create a Storage Container**

```bash
az storage container create \
  --name tfstate \
  --account-name terraformstateacct
```

### **Step 4: Update Terraform Configuration**

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-storage-rg"
    storage_account_name = "terraformstateacct"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
```

### **Step 5: Reinitialize Backend**

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

✅ Install Terraform and Azure CLI
✅ Authenticate using Azure CLI or Service Principal
✅ Configure the Azure provider in Terraform
✅ Optionally store Terraform state in Azure Storage
✅ Manage and destroy resources easily using Terraform

---