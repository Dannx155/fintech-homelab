docker build -t churn-risk-api:latest ./app
kubectl apply -f k8s/namespace.yaml
Start-Sleep -Seconds 2
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl rollout status deployment/churn-risk-api -n fintech
kubectl port-forward -n fintech svc/churn-risk-api 5000:5000