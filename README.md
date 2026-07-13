# Lesson 5 Terraform Infrastructure

This project defines the AWS infrastructure for lesson 5 using Terraform modules and a remote S3 backend with DynamoDB locking.

## Structure

- `main.tf` connects the root inputs to the `s3-backend`, `vpc`, and `ecr` modules.
- `backend.tf` configures the remote S3 backend and DynamoDB lock table.
- `variables.tf` contains the root inputs and defaults used by the whole stack.
- `outputs.tf` exposes shared values from the modules.
- `modules/s3-backend` creates the state bucket and lock table.
- `modules/vpc` creates the VPC, public/private subnets, IGW, NAT gateways, and routes.
- `modules/ecr` creates the ECR repository, policy, and lifecycle policy.

## Commands

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

## Notes

- Copy `terraform.tfvars.example` to `terraform.tfvars` and replace the placeholder values before applying.
- The backend bucket and lock table must exist before running `terraform init` against the remote backend.
- The VPC module is configured for 3 public subnets and 3 private subnets across 3 availability zones.