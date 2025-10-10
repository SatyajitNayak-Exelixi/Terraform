# Setup Terraform for AWS

Follow these steps to configure AWS credentials and set up Terraform to work with AWS.

---

## 1. Install AWS CLI (Linux example)

### Step 1: Install unzip (required for AWS CLI installer)

```bash
sudo apt update && sudo apt install unzip -y
```

### Step 2: Download and install AWS CLI v2

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

### Step 3: Verify AWS CLI installation

```bash
aws --version
```

---

## 2. Create an AWS IAM User

1. Log in to the **AWS Management Console** with an account that has admin privileges.
2. Go to **IAM** → **Users** → **Add user**.
3. Enter a username, select **Programmatic access**.
4. Attach policies (e.g., `AmazonEC2FullAccess`, or others as needed).
5. Complete creation and save the **Access Key ID** and **Secret Access Key**.

---

## 3. Configure AWS CLI Credentials

Run the following command and provide the credentials:

```bash
aws configure
```

You’ll be prompted to enter:

* AWS Access Key ID
* AWS Secret Access Key
* Default region (e.g., `us-east-1`)
* Default output format (e.g., `json`)

---

## 4. Verify AWS Connectivity

Run:

```bash
aws sts get-caller-identity
```

If it returns account/user details, AWS CLI is correctly configured.

---

## 5. Next Steps with Terraform

With AWS CLI configured, Terraform can now use the credentials stored in `~/.aws/credentials` automatically.

Example check:

```bash
terraform init
```

✅ At this point, your environment is ready to use Terraform with AWS.
