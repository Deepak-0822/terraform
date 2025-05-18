resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
  }

  tags = var.tags
}

resource "aws_eks_node_group" "this" {
  for_each = var.eks_managed_node_groups

  cluster_name    = aws_eks_cluster.this.name
  node_group_name = each.key
  node_role_arn   = each.value["node_role_arn"]
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = each.value["desired_size"]
    max_size     = each.value["max_size"]
    min_size     = each.value["min_size"]
  }

  instance_types = each.value["instance_types"]
  tags           = var.tags
}

resource "aws_eks_addon" "this" {
  for_each = var.eks_addons

  cluster_name  = aws_eks_cluster.this.name
  addon_name    = each.key
  resolve_conflicts = each.value.resolve_conflicts

  # Optional addon_version (only set if not null)
  addon_version = each.value.addon_version != null ? each.value.addon_version : null

  service_account_role_arn = lookup(each.value, "service_account_role_arn", null)

  tags = var.tags
}
