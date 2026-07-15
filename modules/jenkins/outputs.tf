output "jenkins_namespace" {
  description = "Created namespace for Jenkins"
  value       = kubernetes_namespace.jenkins.metadata[0].name
}

data "kubernetes_service" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }
  depends_on = [helm_release.jenkins]
}

output "jenkins_url" {
  description = "Jenkins LoadBalancer URL"
  value       = try(data.kubernetes_service.jenkins.status[0].load_balancer[0].ingress[0].hostname, "Waiting for LoadBalancer...")
}