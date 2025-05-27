module "eks_managed_node_group" {
  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "~> 20.0"

  name            = join("-",[lookup(var.eks_attr, "name"),"ng"]) 
  cluster_name    = lookup(var.eks_attr, "name")
  cluster_version = lookup(var.eks_attr, "version")

  subnet_ids = values(local.vpc.was_subnets)

  cluster_service_cidr = "172.20.0.0/16"  # VPC CIDR과 다른 대역 사용
  cluster_ip_family    = "ipv4"

  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
  vpc_security_group_ids            = [module.eks.node_security_group_id]

    use_name_prefix          = false
    iam_role_name            = join("-", [var.eks_name, "ng"])
    iam_role_use_name_prefix = false

  min_size     = 2
  max_size     = 5  
  desired_size = 2
  disk_size = 20

  instance_types = ["t4g.medium"]
  ami_type       = "AL2_ARM_64"
  capacity_type  = "ON_DEMAND"  // "SPOT"

  labels = {
    Environment = "dev"
    NodeGroup = "general"
  }

#   taints = {
#     dedicated = {
#       key    = "dedicated"
#       value  = "gpuGroup"
#       effect = "NO_SCHEDULE"
#     }
#   }

  tags = merge(
    {
      Environment = "dev"
      NodeGroup   = "general"
      "k8s.io/cluster-autoscaler/enabled" = "true"
      "k8s.io/cluster-autoscaler/${lookup(var.eks_attr, "name")}" = "owned"
    }
  )

  update_config = {
    max_unavailable_percentage = 50
  }
}