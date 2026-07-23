output "argocd_namespace" {
  description = "Created namespace for Argo CD"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argo-cd-argocd-server"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }
  depends_on = [helm_release.argocd]
}

output "argocd_url" {
  description = "Argo CD LoadBalancer URL"
  value       = try(data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].hostname, "Waiting for LoadBalancer...")
}