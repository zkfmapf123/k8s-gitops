# ArgoCD GitOps

## Naming

```sh
    [namespace or common]-[service-name]
```

- common 일 경우, 내부에서 namespace 정의

## argocd 수정

```sh
sed -i '' 's/namespace: argocd/namespace: platform/g' install.yaml
sed -i '' 's/namespace: .*/namespace: platform/g' install.yaml

```

## CrashBackOff 모음

![cr](../public/cr-1.png)

- exec format error 
- github action 내 os 재구성