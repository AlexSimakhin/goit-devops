# Django Cloud Orchestration: GitOps-Driven Infrastructure

This project provisions a production-ready AWS infrastructure and implements a **GitOps-based CI/CD pipeline** for a containerized Django application using **Terraform**, **Jenkins**, **Argo CD**, **Helm**, **Amazon EKS**, and a complete **monitoring stack**.

---

## Quick Start

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and set your environment values.
2. Run `terraform init` and bootstrap the backend with `terraform apply -target=module.s3_backend`.
3. Re-run `terraform init -migrate-state` and then `terraform apply -auto-approve`.
4. Configure `kubectl`, apply `sc.yaml`, and verify the application secret in `default`.

---

## Prerequisites

Before deploying, make sure you have:

- Terraform
- AWS CLI configured for the target account
- `kubectl`
- Helm
- Access to the EKS cluster after provisioning

---

## 🏗 Architecture

| Component | Technology | Purpose |
|-----------|------------|---------|
| Infrastructure | Terraform | AWS resource provisioning |
| Cloud | AWS (VPC, EKS, ECR, RDS/Aurora, S3, DynamoDB) | Cloud infrastructure |
| Compute | Amazon EKS | Kubernetes orchestration |
| Storage | GP3 StorageClass | Dynamic EBS persistent volumes |
| CI | Jenkins + Kaniko | Build and publish Docker images |
| CD | Argo CD | GitOps deployment |
| Monitoring | metrics-server, Prometheus, Grafana, ingress-nginx, cert-manager | Metrics, dashboards, autoscaling, and ingress support |
| Runtime | Django, PostgreSQL 15, Nginx | Application stack |

---

## 🗄 Database Infrastructure

The project includes a reusable Terraform module supporting both **Amazon RDS** and **Amazon Aurora**.

Supported database engines:

- PostgreSQL
- MySQL
- Aurora PostgreSQL
- Aurora MySQL

The module automatically provisions:

- Security Group
- DB Subnet Group
- Parameter Group
- RDS Instance or Aurora Cluster

Switching between RDS and Aurora only requires changing Terraform variables.

---

## 🔄 CI/CD Workflow

The deployment process is fully automated:

1. Push code to GitHub.
2. Jenkins builds the Docker image using **Kaniko** with IRSA-based AWS access.
3. The image is pushed to **Amazon ECR**.
4. Jenkins updates `charts/django-app/values.yaml` with the new image tag.
5. Jenkins commits and pushes the updated Helm chart to GitHub.
6. Argo CD detects repository changes.
7. Argo CD synchronizes the Kubernetes cluster.
8. The updated application is deployed automatically.

---

## 📊 Monitoring & Observability

The cluster includes a monitoring stack for infrastructure and application observability.

Components:

- **Prometheus** – collects metrics from Kubernetes workloads.
- **Grafana** – visualizes metrics using customizable dashboards.
- **Node Exporter** – exposes CPU, memory, disk, and network metrics for cluster nodes.
- **Kube State Metrics** – provides metrics for Kubernetes resources such as Pods, Deployments, Nodes, and Services.

The monitoring stack enables:

- Cluster health monitoring
- Resource utilization analysis
- Application performance visualization
- Kubernetes workload monitoring
- Infrastructure observability through Grafana dashboards

---

## 🚀 Deployment

### 1. Prepare Terraform Variables

Start from the example file and adjust values for your environment:

```bash
cp terraform.tfvars.example terraform.tfvars
```

### 2. Bootstrap Terraform Backend

Initialize Terraform and create the backend resources:

```bash
terraform init
terraform apply -target=module.s3_backend
```

Enable the S3 backend and migrate the Terraform state:

```bash
terraform init -migrate-state
terraform apply -auto-approve
```

This provisions the complete AWS infrastructure, including:

- VPC
- EKS
- ECR
- RDS/Aurora
- Jenkins
- Argo CD

---

### 3. Configure Kubernetes Access and Storage

After provisioning, update your local kubeconfig and create the storage class used by the application:

```bash
aws eks update-kubeconfig --name <cluster-name> --region <aws-region>
kubectl apply -f sc.yaml
```

---

### 4. Application Runtime

Application secrets are created by Terraform in the `default` namespace as `django-app-secret`.

The secret contains:

- `DJANGO_SECRET_KEY`
- `POSTGRES_HOST`
- `POSTGRES_DB`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`

Application configuration such as debug flags and allowed hosts is injected through a Kubernetes **ConfigMap**.

If you want to verify the secret after deployment:

```bash
kubectl get secret django-app-secret -n default
```

The cluster installs **metrics-server**, **ingress-nginx**, **cert-manager**, **Prometheus**, and **Grafana** through Terraform.

If you need to refresh the cluster issuer, apply:

```bash
kubectl apply -f cluster-issuer.yaml
```

Make sure the DNS record for `oleksandr-simakhin.tech` points to the ingress controller load balancer.

---

## 🛠 Troubleshooting

### Verify Secrets

If the application Pods fail to start, verify the `django-app-secret` secret exists and contains the expected keys.

### Terraform State Locked

If Terraform reports a locked state:

```bash
terraform force-unlock <LOCK_ID>
```

### Infrastructure Cleanup

If `terraform destroy` cannot remove all resources:

- Empty all Amazon ECR repositories.
- Remove all object versions from the S3 backend bucket.
- Run:

```bash
terraform destroy
```

---

## 📌 Tech Stack

- Terraform
- AWS (VPC, EKS, ECR, RDS/Aurora, S3, DynamoDB)
- Kubernetes
- Helm
- Jenkins
- Argo CD
- Kaniko
- Prometheus
- Grafana
- Node Exporter
- Kube State Metrics
- Django
- PostgreSQL 15
- Nginx