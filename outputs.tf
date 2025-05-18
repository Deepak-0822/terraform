output "cluster_name" {
  value = module.eks_cluster.cluster_name
}

output "cluster_endpoint" {
  value = module.eks_cluster.cluster_endpoint
}

output "cluster_ca_certificate" {
  value = module.eks_cluster.cluster_ca_certificate
}
