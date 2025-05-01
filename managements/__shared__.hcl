remote_state {
    backend = "s3"

    generate = {
        path = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }

    config = {
        bucket = "donggyu-gitops-state"
        key = "${path_relative_to_include()}/terraform.tfstate"
        region = "ap-northeast-2"
        encrypt = true
        assume_role = {
            role_arn = "arn:aws:iam::${get_aws_account_id()}:role/TerraformAssumedRole"
        }
    }
}

generate "provider" {
    path = "provider.tf"
    if_exists = "skip"
    contents = <<EOF
provider "aws" {
    region = "ap-northeast-2"
    assume_role {
        role_arn = "arn:aws:iam::${get_aws_account_id()}:role/TerraformAssumedRole"
    }
}
EOF
}

generate "terraform" {
    path = "vars.tf"
    if_exists = "overwrite_terragrunt"

    contents = <<EOF
    variable "is_use" {
        type = bool
        default = true
    }

    variable "eks_name" {
        type = string
        default = "donggyu-eks"
    }

    variable "eks_cluster_attr" {
    
    }

    variable "vpc" {}
    variable "nodegroup_iam_role_name" {}

    data "aws_caller_identity" "current" {}
    EOF
}

dependency "network" {
    config_path = "../network"

    mock_outputs = {
        vpc = {}
    }

}

dependency "k8s" {
    config_path = "../eks-cluster"

    mock_outputs =  {
        nodegroup_iam_role_name = ""
    }
}

inputs = {
    // 실제 사용 여부
    is_use = false
    eks_name = "donggyu-eks"

    vpc = dependency.network.outputs.vpc
    nodegroup_iam_role_name = dependency.k8s.outputs.nodegroup_iam_role_name

    eks_cluster_attr = {
        version = "1.32"
        ng_min_size = 1
        ng_max_size = 3
        ng_desired_size = 2
        eks_instance_type = "t4g.medium"
        ami_type = "AL2_ARM_64"
    }
}