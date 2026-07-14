# CI/CD Pipeline: Jenkins + Argo CD + AWS EKS

This project implements a full **CI/CD pipeline** for a Django application using **Jenkins**, **Argo CD**, **Terraform**, and **AWS (EKS, ECR, VPC, S3)**.

---

# 🏗 Architecture & Workflow

The system follows a GitOps-based CI/CD approach:

## 1. Infrastructure as Code (Terraform)

Terraform provisions the full AWS infrastructure:

- VPC (networking)
- Amazon EKS (Kubernetes cluster)
- Amazon ECR (Docker registry)
- S3 + DynamoDB (Terraform backend)
- Jenkins (via Helm)
- Argo CD (via Helm)

---

## 2. Continuous Integration (Jenkins)

Jenkins handles build automation:

- Trigger: Git push
- Runs inside Kubernetes (K8s agent)
- Uses **Kaniko** to build Docker images (no Docker daemon required)
- Pushes images to Amazon ECR
- Updates Helm chart (`values.yaml`) with new `image.tag`
- Commits and pushes changes back to GitHub

---

## 3. Continuous Deployment (Argo CD)

Argo CD implements GitOps deployment:

- Monitors Git repository (Helm chart)
- Detects changes automatically
- Syncs Kubernetes cluster state with Git
- Deploys:
  - Deployments
  - Services
  - HPA (Horizontal Pod Autoscaler)

---

# 🔁 CI/CD Flow

1. Developer pushes code to GitHub
2. Jenkins pipeline starts automatically
3. Docker image is built with Kaniko
4. Image is pushed to Amazon ECR
5. Jenkins updates Helm `values.yaml`
6. Changes are pushed back to GitHub
7. Argo CD detects changes
8. Argo CD syncs Kubernetes cluster
9. Application is updated automatically

---

# 🚀 Installation & Usage

## 1. Bootstrap Terraform Backend

Terraform uses S3 and DynamoDB for remote state.

### Step 1 — Disable backend temporarily

Comment out this block in `backend.tf`:

```hcl
backend "s3" {}
```

Initialize Terraform:

```bash
terraform init
```

Create backend resources:

```bash
terraform apply -target=module.s3_backend
```

---

### Step 2 — Enable backend

Uncomment the backend block and run:

```bash
terraform init -migrate-state
terraform apply -auto-approve
```

---

## 2. Deploy PostgreSQL

The database is deployed separately:

```bash
kubectl apply -f postgres.yaml
```

---

## 3. Configure Jenkins

Get Jenkins external URL:

```bash
kubectl get svc jenkins -n jenkins
```

Open in browser:

```
http://<EXTERNAL-IP>:8080
```

---

### Default Credentials

```
Username: admin
Password: adminpassword123
```

---

### Add GitHub Credentials

Navigate:

```
Manage Jenkins → Credentials → System → Global credentials
```

Add:

- Kind: Username with password
- ID: `github-token`
- Username: your GitHub username
- Password: GitHub Personal Access Token (PAT)

---

### Create Pipeline

- Create **Multibranch Pipeline**
- Connect your GitHub repository
- Run initial build

---

## 4. Verify Argo CD

Get Argo CD URL:

```bash
kubectl get svc argo-cd-argocd-server -n argocd
```

---

### Get Admin Password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
-o jsonpath="{.data.password}" | base64 -d
```

---

### Login

```
Username: admin
Password: <retrieved-password>
```

---

### Check Application

- Open Argo CD UI
- Find `django-app`
- Status should be:

```
Healthy
Synced
```

Once Jenkins updates the image tag, Argo CD will auto-sync.

---

# 🧹 Cleanup

> ⚠️ **Important:** Amazon EKS is NOT free and can incur charges.

Destroy all infrastructure:

```bash
terraform destroy -auto-approve
```

---

# 📝 Notes

- Ensure `terraform.tfvars` is properly configured
- Jenkins must have correct GitHub token permissions
- Argo CD must have access to the Git repository
- Keep Helm chart (`values.yaml`) in sync with image versions
- PostgreSQL is deployed separately — ensure connectivity settings match

---

# 📌 Tech Stack

- AWS (EKS, ECR, VPC, S3, DynamoDB)
- Terraform
- Kubernetes
- Helm
- Jenkins
- Argo CD
- Kaniko
- Django