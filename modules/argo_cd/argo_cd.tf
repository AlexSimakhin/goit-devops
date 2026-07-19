resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argocd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = "5.51.6"

  values = [
    file("${path.module}/values.yaml")
  ]
}

resource "helm_release" "argocd_apps" {
  name      = "argocd-apps"
  chart     = "${path.module}/charts"
  namespace = kubernetes_namespace.argocd.metadata[0].name

  depends_on = [helm_release.argocd]

  values = [
    file("${path.module}/charts/values.yaml")
  ]
}

resource "random_password" "django_secret_key" {
  length           = 50
  special          = true
  override_special = "!@#$%^&*(-_=+)"
}

resource "kubernetes_secret" "django_app_secret" {
  metadata {
    name      = "django-app-secret"
    namespace = "default"
  }

  data = {
    POSTGRES_HOST     = var.db_endpoint
    POSTGRES_DB       = "myapp"
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = var.db_password
    DJANGO_SECRET_KEY = random_password.django_secret_key.result
  }

  depends_on = [helm_release.argocd]
}