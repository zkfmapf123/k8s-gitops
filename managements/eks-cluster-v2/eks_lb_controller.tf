variable "lb_attr" {
  default = {
    name       = "aws-load-balancer-controller"
    namespace  = "kube-system"
    repository = "https://aws.github.io/eks-charts"
    chart      = "aws-load-balancer-controller"
    version    = "1.7.1"
  }
}

## 쿠버네티스 내에서 AWS 리소스에 접근하는 것이기 때문에, IRSA 설정을 진행한다.
module "alb_controller_irsa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${lookup(var.eks_attr, "name")}-${lookup(var.lb_attr, "name")}-irsa"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    one = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:${var.lb_attr.name}"]
    }
  }
}

// ALB에 할당할, Service Account
resource "kubernetes_service_account" "alb_controller" {
  metadata {
    name      = lookup(var.lb_attr, "name")
    namespace = lookup(var.lb_attr, "namespace")

    annotations = {
      "eks.amazonaws.com/role-arn" = module.alb_controller_irsa.iam_role_arn
    }
  }
}

// LB
resource "helm_release" "alb_controller" {
  namespace  = var.lb_attr.namespace
  repository = var.lb_attr.repository
  name       = var.lb_attr.name
  chart      = var.lb_attr.chart
  version    = var.lb_attr.version

  set {
    name  = "clusterName"
    value = lookup(var.eks_attr, "name")
  }
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.alb_controller.metadata.0.name
  }
  set {
    name  = "region"
    value = "ap-northeast-2"
  }
  set {
    name  = "vpcId"
    value = local.vpc.vpc_id
  }
  depends_on = [kubernetes_service_account.alb_controller]
}