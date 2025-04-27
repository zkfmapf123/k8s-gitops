################################################################################
# EKS Blueprints Addons
################################################################################
module "eks_blueprints_addons" {

  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  create_kubernetes_resources = true

  enable_cluster_autoscaler           = false
  enable_karpenter                    = true
  enable_aws_load_balancer_controller = true
  enable_metrics_server               = true
  enable_external_dns                 = false

  external_dns_route53_zone_arns = ["arn:aws:route53:::hostedzone/Z00048241CBNRGJ5TTDPT"]

  karpenter = {
    repository_username = data.aws_ecrpublic_authorization_token.token.user_name
    repository_password = data.aws_ecrpublic_authorization_token.token.password
  }

  karpenter_enable_spot_termination          = true
  karpenter_enable_instance_profile_creation = true
  karpenter_node = {
    iam_role_use_name_prefix = false
  }

  aws_load_balancer_controller = {
    set = [
      {
        name  = "enableServiceMutatorWebhook"
        value = false
      }
    ]
  }

  tags = {
    Blueprint = var.eks_name
  }
}

data "aws_iam_policy_document" "ebs_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateVolume",
      "ec2:CreateTags",
      "ec2:AttachVolume"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ebs_policy" {
  name        = "${var.eks_name}-ebs-permission"
  description = "A test putObejct policy"
  policy      = data.aws_iam_policy_document.ebs_policy.json
}

resource "aws_iam_role_policy_attachment" "ebs_role" {
  role       = module.eks_blueprints_addons.karpenter.node_iam_role_name
  policy_arn = aws_iam_policy.ebs_policy.arn
}
