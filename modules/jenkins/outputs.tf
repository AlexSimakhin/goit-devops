output "jenkins_namespace" {
  description = "Created namespace for Jenkins"
  value       = kubernetes_namespace.jenkins.metadata[0].name
}