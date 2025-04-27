module "eks" {

  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name                   = var.eks_name
  cluster_version                = local.eks_cluster_attr.version
  cluster_endpoint_public_access = true

  vpc_id     = local.vpc.vpc_id
  subnet_ids = values(local.vpc.was_subnets)

  create_cluster_security_group = false
  create_node_security_group    = false

  eks_managed_node_groups = {
    zent-node = {
      name                     = join("-", [var.eks_name, "nodegroup"])
      use_name_prefix          = false
      iam_role_name            = join("-", [var.eks_name, "nodegroup"])
      iam_role_use_name_prefix = false

      min_size       = lookup(local.eks_cluster_attr, "ng_min_size")
      max_size       = lookup(local.eks_cluster_attr, "ng_max_size")
      desired_size   = lookup(local.eks_cluster_attr, "ng_desired_size")
      instance_types = [lookup(local.eks_cluster_attr, "eks_instance_type")]
      ami_type       = "AL2_ARM_64"
      subnet_ids     = values(local.vpc.was_subnets)

      capacity_type = "SPOT"
    }
  }

  enable_cluster_creator_admin_permissions = true

  # EKS Addons
  cluster_addons = {
    coredns            = {}
    kube-proxy         = {}
    vpc-cni            = {}
    aws-ebs-csi-driver = {}
    # eks-pod-identity-agent = {}
  }

  iam_role_name            = join("-", [var.eks_name, "nodegroup"])
  iam_role_use_name_prefix = true

  tags = merge({
    Blueprint = var.eks_name
    }, {
    # NOTE - if creating multiple security groups with this module, only tag the
    # security group that Karpenter should utilize with the following tag
    # (i.e. - at most, only one security group should have this tag in your account)
    "karpenter.sh/discovery" = var.eks_name
  })
}

## https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/UPGRADE-20.0.md
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
}

output "nodegroup_iam_role_name" {
  value = module.eks.eks_managed_node_groups["zent-node"].iam_role_name
}
