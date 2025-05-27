locals {
  vpc              = jsondecode(var.vpc)
  eks_cluster_attr = jsondecode(var.eks_cluster_attr)
}
