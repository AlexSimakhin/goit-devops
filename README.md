# AWS Infrastructure Setup (Terraform)

This project contains Terraform configurations for the automated deployment of basic cloud infrastructure in AWS.

## Architecture

The infrastructure includes the following components:
- **S3 Bucket**: Used for secure remote Terraform state storage.
- **DynamoDB Table**: Provides a state locking mechanism to prevent concurrent modification conflicts.
- **VPC (Virtual Private Cloud)**: An isolated network environment featuring public and private subnets.
- **ECR (Elastic Container Registry)**: A private repository for storing Docker images.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) (v1.5.0+ recommended).
- AWS Account.
- IAM User with the `AdministratorAccess` policy attached.
- Generated AWS Access Key ID and Secret Access Key.

## Deployment Steps

### 1. Configure AWS Credentials

Export your AWS access keys as environment variables in your terminal:

```bash
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY"
export AWS_DEFAULT_REGION="us-west-2"
```

### 2. Initial Setup (Create Backend)

Since the S3 bucket for the remote state does not exist yet, you must temporarily disable the remote backend and create the bucket using a local state.

```bash
# 1. Temporarily disable the remote backend
mv backend.tf backend.txt

# 2. Initialize the working directory
./terraform init

# 3. Deploy only the S3 and DynamoDB modules
./terraform apply -target=module.s3_backend
```
*Type `yes` when prompted to confirm the action.*

### 3. State Migration (Move to S3)

Once the S3 bucket is created, switch Terraform to use the remote state.

```bash
# 1. Restore the backend configuration file
mv backend.txt backend.tf

# 2. Initialize Terraform and migrate the state
./terraform init -migrate-state
```
*Type `yes` when asked if you want to copy the existing state to the new backend.*

### 4. Deploy VPC and ECR

Now you can create the remaining infrastructure (network and container registry).

```bash
./terraform apply
```
*Review the execution plan and type `yes` to confirm.*

## Cleanup

**Important:** To prevent unexpected AWS charges, ensure you destroy the infrastructure when you are finished.

```bash
./terraform destroy
```
*Type `yes` to permanently remove all created resources.*