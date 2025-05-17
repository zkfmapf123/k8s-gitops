# ArgoCD 설치
kubectl apply -f ./install.yaml -n platform

# ArgoCD Web UI 접속시 admin 패스워드 확인 방법
kubectl -n platform get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo