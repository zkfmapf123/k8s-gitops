terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1"
    }
  }
}

data "aws_eks_cluster_auth" "kubernetes" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "helm" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "kubectl" {
  name = module.eks.cluster_name
}

data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

data "aws_availability_zones" "available" {}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/TerraformAssumedRole"
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.kubernetes.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.helm.token
  }
}

provider "kubectl" {
  apply_retry_count      = 10
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  load_config_file       = false
  token                  = data.aws_eks_cluster_auth.kubectl.token
}

locals {
  name   = var.eks_name
  region = "ap-northeast-2"

  tags = {
    Blueprint  = var.eks_name
    GithubRepo = "github.com/aws-ia/terraform-aws-eks-blueprints"
  }
}
