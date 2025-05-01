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

## 이슈 모음

### CrashBackOff (exec format error)
![cr](../public/cr-1.png)

- exec format error 
- github action 내 os 재구성

### CrashBackOff (Image Policy)

- ImagePolicy 내에서 IfNotPresent 일 경우, 이미지가 존재하지 않을 경우에만 이미지를 가져옴 (캐시는 좋으나, 문제가 있는 이미지를 계속 쓸 위험이 존재)
- Always를 사용하거나, Version을 바꿔줘야 함

### argocd 아무것도 안나옴 이슈