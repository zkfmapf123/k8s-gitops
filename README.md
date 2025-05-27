# k8s gitops pattern

## Todo

### environments

- [x] eks terraform
- [x] eks cluster
- [x] eks node group
- [x] eks lb controller
- [x] eks metrics server
- [ ] eks karpenter
- [ ] eks keda

## Configure

### eks 설정

```sh
aws eks update-kubeconfig \
    --name [eks name] \
    --region [region] \
    --profile [profile]
```

## Trouble Shooting

### aws-auth not found

```sh
kubectl get configmap aws-auth -n kube-system
```

### aws-auth issue

```sh
Get "http://localhost/api/v1/namespaces/kube-system/configmaps/aws-auth": dial tcp [::1]:80: connect: connection refused
```

- state 를 삭제하고 다시 apply

```sh
terraform state rm aws_eks_cluster.eks_cluster
terraform apply
```
