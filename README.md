# AWS EKS Infrastructure & Django Application Deployment

This project provisions a complete cloud infrastructure on **AWS** using **Terraform** and deploys a containerized **Django** application with a **PostgreSQL** database to an **Amazon EKS (Elastic Kubernetes Service)** cluster using **Helm**.

---

# 🏗 Architecture Overview

The infrastructure consists of the following components:

1. **Terraform Remote Backend**
   - Amazon S3 Bucket for Terraform state storage
   - Amazon DynamoDB table for state locking

2. **Infrastructure Provisioning (Terraform)**
   - AWS VPC
   - Public and Private Subnets
   - Internet Gateway
   - NAT Gateway
   - Amazon ECR
   - Amazon EKS

3. **Application**
   - Dockerized Django application

4. **Database**
   - PostgreSQL running inside the Kubernetes cluster

5. **Kubernetes & Helm**
   - Deployments
   - Services
   - ConfigMaps
   - Secrets
   - AWS LoadBalancer Service

6. **DNS**
   - Custom domain pointing to the AWS LoadBalancer

---

# 📂 Infrastructure Components

## Terraform Backend (`backend.tf`)

Terraform uses a **remote backend** to safely store infrastructure state.

The backend consists of:

- Amazon S3 Bucket
- Amazon DynamoDB table

Since Terraform cannot create the backend while simultaneously using it, the backend must be bootstrapped during the first deployment (see **Usage** section).

---

## Terraform Modules

The infrastructure is organized into reusable modules.

### `modules/vpc`

Creates:

- VPC
- 3 Public Subnets
- 3 Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables

Resources are distributed across three Availability Zones.

---

### `modules/ecr`

Creates an **Amazon Elastic Container Registry (ECR)** repository.

Features:

- Docker image repository
- Lifecycle policy for old images

---

### `modules/eks`

Deploys:

- Amazon EKS Cluster
- Managed Node Groups
- IAM Roles
- Kubernetes networking

---

# 🐳 Django Containerization

The Django application is packaged as a Docker image.

Workflow:

1. Build Docker image
2. Tag image
3. Push image to Amazon ECR
4. Deploy image into Kubernetes

---

# ☸ Kubernetes Deployment

Deployment is managed using a custom Helm chart located at:

```
charts/django-app
```

The chart deploys:

- Django Deployment
- Kubernetes Service
- ConfigMap
- Secret

---

## PostgreSQL

A PostgreSQL instance is deployed inside Kubernetes using:

```
postgres.yaml
```

It creates:

- PostgreSQL Pod
- PostgreSQL Service

The database is accessible only within the cluster.

---

## Configuration

Environment variables are managed through:

- ConfigMap
- Secret

These are injected into the Django Pods using:

```yaml
envFrom:
```

Examples include:

- Database Host
- Database Name
- Username
- Password

---

## Load Balancer

The Kubernetes Service uses:

```yaml
type: LoadBalancer
```

AWS automatically provisions an **Elastic Load Balancer (ELB)**, exposing the application over HTTP (Port 80).

---

# 🌐 DNS Configuration

Traffic is routed using a custom domain.

A **CNAME** record points:

```
www.oleksandr-simakhin.tech
```

to the generated AWS LoadBalancer hostname.

The Django configuration (`ALLOWED_HOSTS`) must include:

- AWS LoadBalancer hostname
- Custom domain

---

# 🚀 Usage

## 1. Bootstrap Terraform Backend

Temporarily disable the remote backend.

```bash
mv backend.tf backend.tf.backup
```

Initialize Terraform locally.

```bash
terraform init
```

Create the backend resources.

```bash
terraform apply -auto-approve
```

Restore the backend configuration.

```bash
mv backend.tf.backup backend.tf
```

Migrate the local state to the remote backend.

```bash
terraform init -migrate-state
```

---

## 2. Build Docker Image

Navigate to the application directory.

```bash
cd app
```

Build the Docker image.

```bash
docker build -t django-app .
```

Tag the image.

```bash
docker tag django-app:latest <aws-account-id>.dkr.ecr.<region>.amazonaws.com/<repository>:latest
```

Push the image.

```bash
docker push <aws-account-id>.dkr.ecr.<region>.amazonaws.com/<repository>:latest
```

Return to the project root.

```bash
cd ..
```

---

## 3. Deploy PostgreSQL

```bash
kubectl apply -f postgres.yaml
```

---

## 4. Deploy the Django Application

Install the Helm chart.

```bash
helm install django-app ./charts/django-app
```

---

## 5. Update the Deployment

After modifying the Helm chart or values:

```bash
helm upgrade django-app ./charts/django-app
```

Restart the deployment.

```bash
kubectl rollout restart deployment django-app-deployment
```

---

# 🧹 Cleanup

> **Important:** Amazon EKS is **not included** in the AWS Free Tier. Destroy all resources after testing to avoid unexpected charges.

Uninstall the Helm release.

```bash
helm uninstall django-app
```

Delete PostgreSQL resources.

```bash
kubectl delete -f postgres.yaml
```

Destroy the Terraform infrastructure.

```bash
terraform destroy -auto-approve
```

---

# 📝 Notes

- Configure `terraform.tfvars` before running Terraform.
- Ensure database credentials match across:
  - `values.yaml`
  - `postgres.yaml`
- Update the Django `ALLOWED_HOSTS` setting whenever the LoadBalancer hostname or domain changes.
- Push a new Docker image to Amazon ECR before deploying application updates.