# Terraform Installation Guide (Windows, Linux, macOS)

This guide provides step-by-step instructions to install **Terraform** on Windows, Linux, and macOS systems.

---

## 1. Windows Installation

### Step 1: Download Terraform

* Go to [Terraform Downloads](https://developer.hashicorp.com/terraform/downloads).
* Choose **Windows (64-bit)**.
* Download the `.zip` archive.

### Step 2: Extract Terraform

* Extract the `.zip` file.
* Move `terraform.exe` to a directory of your choice, for example: `C:\terraform`.

### Step 3: Update PATH

* Search for **Environment Variables** in Windows.
* Edit the `Path` variable and add the Terraform directory (`C:\terraform`).

### Step 4: Verify Installation

Open **PowerShell** or **Command Prompt** and run:

```powershell
terraform -version
```

---

## 2. Linux Installation (Debian/Ubuntu-based)

### Step 1: Remove old Terraform (if exists)

```bash
sudo rm -rf /usr/local/bin/terraform
```

### Step 2: Add HashiCorp GPG Key

```bash
wget -O - https://apt.releases.hashicorp.com/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

### Step 3: Add HashiCorp Repository

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

### Step 4: Install Terraform

```bash
sudo apt update && sudo apt install terraform -y
```

### Step 5: Verify Installation

```bash
terraform -version
```

---

## 3. macOS Installation

### Option A: Install via Homebrew (Recommended)

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### Option B: Manual Install

* Go to [Terraform Downloads](https://developer.hashicorp.com/terraform/downloads).
* Download the macOS binary.
* Extract and move the `terraform` binary to `/usr/local/bin/`:

  ```bash
  sudo mv terraform /usr/local/bin/
  sudo chmod +x /usr/local/bin/terraform
  ```

### Step 3: Verify Installation

```bash
terraform -version
```

---

## Uninstall Terraform

### Windows

* Remove `terraform.exe` from the installation folder.
* Remove the PATH entry if needed.

### Linux

```bash
sudo apt remove terraform -y
sudo rm -rf /usr/local/bin/terraform
```

### macOS (if installed with brew)

```bash
brew uninstall hashicorp/tap/terraform
```

---

