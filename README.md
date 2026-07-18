# Django Cloud Orchestration: GitOps-Driven Infrastructure

This project provisions a production-ready AWS infrastructure and implements a **GitOps-based CI/CD pipeline** for a containerized Django application using **Terraform**, **Jenkins**, **Argo CD**, **Helm**, **Amazon EKS**, and a complete **monitoring stack**.

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
| Monitoring | Prometheus, Grafana | Metrics, dashboards & observability |
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
2. Jenkins builds the Docker image using **Kaniko**.
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

### 1. Bootstrap Terraform Backend

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

### 2. Configure Storage

Create the GP3 StorageClass used for dynamic EBS volumes:

```bash
kubectl apply -f sc.yaml
```

---

### 3. Configure Application Secrets

Create the required Kubernetes Secret:

```bash
kubectl create secret generic django-app-secret \
  --from-literal=DJANGO_SECRET_KEY='your-secure-key' \
  --from-literal=POSTGRES_PASSWORD='your-password' \
  -n default
```

Application configuration (database host, debug flags, etc.) is injected through a Kubernetes **ConfigMap**.

---

## 🛠 Troubleshooting

### Verify Secrets

If the application Pods fail to start, verify the secret exists:

```bash
kubectl get secret django-app-secret -n default
```

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