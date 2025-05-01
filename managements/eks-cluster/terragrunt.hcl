include "root" {
    path = find_in_parent_folders("__shared__.hcl")
}

terraform {

after_hook "eks_update" {
    commands = ["apply"]
    
    // kube config update
    execute = ["aws", "eks", "update-kubeconfig", "--name", "donggyu-eks", "--region", "ap-northeast-2", "--profile", "leedonggyu"]
    run_on_error = true
}
}
