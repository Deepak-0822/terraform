## VPC
module "vpc" {
  source              = "./modules/vpc"

  name = "${var.environment}-${var.project_name}-vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnets
  availability_zones  = var.subnet_azs

}

module "sg" {
  source  = "./modules/security_group"
  vpc_id  = module.vpc.vpc_id
}


module "eks_cluster" {
  source = "./modules/eks"

  cluster_name             = "${var.environment}-${var.project_name}-eks"
  cluster_version          = "1.32"
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.public_subnet_ids
  cluster_role_arn         = "arn:aws:iam::971422676158:role/AmazonEKSAutoClusterRole"

    eks_addons = {
    "vpc-cni" = {
      resolve_conflicts = "OVERWRITE"
    }
    "kube-proxy" = {
      resolve_conflicts = "OVERWRITE"
    }
    "coredns" = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  eks_managed_node_groups = {
    ng-1 = {
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      instance_types = ["t3.medium"]
      node_role_arn  = "arn:aws:iam::971422676158:role/AmazonEKSAutoNodeRole"
    }
  }
  tags = {
    Environment = "dev"
    Project     = "EKS"
  }
}