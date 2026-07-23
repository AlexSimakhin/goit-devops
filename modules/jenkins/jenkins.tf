resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_service_account" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.jenkins.metadata[0].name

    annotations = {
      "eks.amazonaws.com/role-arn" = var.service_account_role_arn
    }
  }
}

resource "helm_release" "jenkins" {
  name             = "jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  namespace        = "jenkins"
  create_namespace = true
  timeout          = 600

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "controller.serviceType"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.admin.password"
    value = var.admin_password
  }
}