variable "eks_attr" {
  default = {
    "name" : "donggyu-eks"
    "version" : "1.32"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = lookup(var.eks_attr, "name")
  cluster_version = lookup(var.eks_attr, "version")
  cluster_endpoint_public_access = true
  cluster_endpoint_private_access = false

  create_cluster_security_group = false
  create_node_security_group    = false

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id     = local.vpc.vpc_id
  subnet_ids = values(local.vpc.was_subnets)

  # EKS Addons
  cluster_addons = {
    coredns            = {
      most_recent = true
    }
    kube-proxy         = {
        most_recent = true
    }
    vpc-cni            = {
        most_recent = true
    }
    aws-ebs-csi-driver = {
        most_recent = true
    }
    # eks-pod-identity-agent = {}
  }

  tags = merge({
    Blueprint = lookup(var.eks_attr, "name")
    }, {
    "karpenter.sh/discovery" = lookup(var.eks_attr, "name")
  })

}

module "eks_aws_auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.0"

  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AWSReservedSSO_AdministratorAccess_18f0ecd34fab4ea6"
      username = "admin"
      groups   = ["system:masters"]
    }
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/admin"
      username = "admin"
      groups   = ["system:masters"]
    }
  ]

  depends_on = [ module.eks ]
}