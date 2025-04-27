# k8s gitops pattern

## Architecture

![todo](./public/toto.png)

```
    |- managements
    |- platforms
    |- services
```

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
