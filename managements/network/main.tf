module "eks_vpc" {

  source = "zkfmapf123/vpc3tier/lee"

  vpc_cidr      = "10.0.0.0/16"
  prefix        = "eks"
  vpc_name      = "network"
  is_enable_nat = var.is_use

  vpc_region = "ap-northeast-2"

  webserver_subnets = {
    "a" : "10.0.1.0/24"
    "b" : "10.0.2.0/24"
    "c" : "10.0.3.0/24"
  }

  was_subnets = {
    "a" : "10.0.10.0/24"
    "b" : "10.0.11.0/24"
    "c" : "10.0.12.0/24"
  }

  db_subnets = {
    "a" : "10.0.101.0/24"
    "b" : "10.0.102.0/24"
    "c" : "10.0.103.0/24"
  }

  endpoint_setting = {
    "apigateway_is_enable" : false,
    "codepipeline_is_enable" : false,
    "ecr_is_enable" : false,
    "s3_is_enable" : false,
    "sqs_is_enable" : false
  }

  public_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "karpenter.sh/discovery"          = var.eks_name
  }
}
