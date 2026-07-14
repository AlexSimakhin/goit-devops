# CI/CD Pipeline: Jenkins + Argo CD + AWS EKS

This project implements a GitOps-based **CI/CD pipeline** for a Django application using **Terraform**, **Jenkins**, **Argo CD**, **Helm**, and **AWS**.

---

## 🏗 Architecture

### Infrastructure (Terraform)

Terraform provisions:

- AWS VPC
- Amazon EKS
- Amazon ECR
- Amazon S3 + DynamoDB (Terraform backend)
- Jenkins (Helm)
- Argo CD (Helm)

### Continuous Integration (Jenkins)

Jenkins runs inside Kubernetes and:

- Triggers on Git push or manual build
- Builds Docker images using **Kaniko**
- Pushes images to Amazon ECR
- Updates the Helm `image.tag`
- Commits the updated Helm chart back to GitHub

### Continuous Deployment (Argo CD)

Argo CD continuously monitors the Git repository and automatically synchronizes Kubernetes resources with the latest Helm configuration.

---

## 🔄 CI/CD Workflow

1. Push code to GitHub.
2. Jenkins builds a Docker image with Kaniko.
3. The image is pushed to Amazon ECR.
4. Jenkins updates the Helm chart and pushes the new commit.
5. Argo CD detects the change.
6. Argo CD deploys the updated application to Amazon EKS.

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

---

### 2. Configure Jenkins

Get the external address:

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

Create a **Pipeline** using:

- Repository URL
- `github-token`
- `Jenkinsfile`
- Target branch

Run **Build Now**.

---

### 3. Deploy PostgreSQL

```bash
kubectl apply -f sc.yaml
kubectl apply -f postgres.yaml
```

If the application is already running, restart it:

```bash
kubectl rollout restart deployment django-app-deployment
```

---

### 4. Verify Argo CD

Get the external address:

```bash
kubectl get svc argo-cd-argocd-server -n argocd
```

Retrieve the admin password:

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

- **Healthy**
- **Synced**

---

## 🛠 Troubleshooting

### Jenkins Pods remain Pending

Increase EKS node capacity by:

- changing instance type (e.g. `t3.medium`)
- increasing the node group's `desired_size`

Then run:

```bash
terraform apply
```

### Argo CD Application stays in "Progressing"

If no Ingress Controller is installed, disable Ingress in the Helm chart:

```yaml
ingress:
  enabled: false
```

Commit and push the change. Argo CD will synchronize automatically, and the application can be accessed through its LoadBalancer service.

---

## 🧹 Cleanup

Destroy all AWS resources:

```bash
terraform destroy -auto-approve
```

> **Note:** Amazon EKS is not included in the AWS Free Tier. Destroy resources after testing to avoid unnecessary charges.

---

## 📌 Tech Stack

- Terraform
- AWS (VPC, EKS, ECR, S3, DynamoDB)
- Kubernetes
- Helm
- Jenkins
- Argo CD
- Kaniko
- Django
- PostgreSQL
- Nginx