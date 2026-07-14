output "argocd_namespace" {
  description = "Created namespace for Argo CD"
  value       = kubernetes_namespace.argocd.metadata[0].name
}