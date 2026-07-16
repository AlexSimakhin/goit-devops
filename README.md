# CI/CD Pipeline & Infrastructure: Jenkins + Argo CD + AWS EKS + RDS/Aurora

This project implements a GitOps-based **CI/CD pipeline** for a Django application and provisions a highly available AWS infrastructure using **Terraform**, **Jenkins**, **Argo CD**, **Helm**, and **Amazon EKS**.

---

## 🏗 Architecture

### Infrastructure (Terraform)

Terraform provisions:

- AWS VPC (Public & Private Subnets)
- Amazon EKS
- Amazon ECR
- Amazon RDS or Aurora (configurable)
- Amazon S3 + DynamoDB (Terraform backend)
- Jenkins (Helm)
- Argo CD (Helm)

### Continuous Integration (Jenkins)

Jenkins runs inside Kubernetes and:

- Triggers on Git push or manual build
- Builds Docker images with **Kaniko**
- Pushes images to Amazon ECR
- Updates the Helm `image.tag`
- Pushes changes back to GitHub

### Continuous Deployment (Argo CD)

Argo CD continuously watches the Git repository and automatically synchronizes the Kubernetes cluster with the latest Helm configuration.

---

## 🗄 Flexible Database Module

The project includes a reusable Terraform module (`modules/rds`) that supports both **Amazon RDS** and **Amazon Aurora**.

Switch between database types using a single variable:

```hcl
use_aurora = false   # RDS
use_aurora = true    # Aurora
```

Supported engines:

- PostgreSQL
- MySQL
- Aurora PostgreSQL
- Aurora MySQL

The module automatically creates:

- Security Group
- DB Subnet Group
- Parameter Group
- RDS Instance or Aurora Cluster

---

## 🔄 CI/CD Workflow

1. Push code to GitHub.
2. Jenkins builds a Docker image using Kaniko.
3. The image is pushed to Amazon ECR.
4. Jenkins updates the Helm chart.
5. Jenkins pushes the updated configuration to GitHub.
6. Argo CD detects the change.
7. Argo CD deploys the new version to Amazon EKS.

---

## 🚀 Installation

### 1. Bootstrap Terraform Backend

Create the backend resources:

```bash
terraform init
terraform apply -target=module.s3_backend
```

Enable the S3 backend and migrate the state:

```bash
terraform init -migrate-state
terraform apply -auto-approve
```

Terraform will provision the AWS infrastructure, including EKS, Jenkins, Argo CD, and the configured RDS/Aurora database.

---

### 2. Configure Jenkins

Retrieve the external address:

```bash
kubectl get svc jenkins -n jenkins
```

Open:

```
http://<EXTERNAL-IP>:8080
```

Default credentials:

```
Username: admin
Password: adminpassword123
```

Create the following Jenkins credentials:

| ID | Type |
|----|------|
| `github-token` | Username with password |
| `aws-access-key` | Secret text |
| `aws-secret-key` | Secret text |

Create a Pipeline using:

- Repository URL
- `github-token`
- `Jenkinsfile`
- Target branch

Run **Build Now**.

---

### 3. Verify Argo CD

Retrieve the external address:

```bash
kubectl get svc argo-cd-argocd-server -n argocd
```

Retrieve the initial password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
-o jsonpath="{.data.password}" | base64 -d
```

Login:

```
https://<EXTERNAL-IP>

Username: admin
Password: <retrieved-password>
```

The application should eventually display:

- ✅ Healthy
- ✅ Synced

---

## 🛠 Troubleshooting

### Jenkins Pods remain Pending

Increase the EKS node capacity by:

- using a larger instance type (e.g. `t3.medium`)
- increasing the node group's `desired_size`

Then apply the changes:

```bash
terraform apply
```

### Argo CD Application stays in "Progressing"

If your cluster does not include an Ingress Controller, disable Ingress:

```yaml
ingress:
  enabled: false
```

Commit and push the change. Argo CD will synchronize automatically, and the application will be accessible through its LoadBalancer service.

---

## 🧹 Cleanup

Destroy the infrastructure:

```bash
terraform destroy -auto-approve
```

> **Note:** Amazon EKS, NAT Gateways, and Amazon RDS/Aurora are not included in the AWS Free Tier. Destroy all resources after testing to avoid unnecessary charges. If required, manually empty ECR repositories or S3 buckets before running `terraform destroy`.

---

## 📌 Tech Stack

- Terraform
- AWS (VPC, EKS, ECR, RDS/Aurora, S3, DynamoDB)
- Kubernetes
- Helm
- Jenkins
- Argo CD
- Kaniko
- Django
- PostgreSQL / MySQL
- Nginx