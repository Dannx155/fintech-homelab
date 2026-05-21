docker build -t churn-risk-api:latest ./app
cd terraform
terraform apply -auto-approve
cd ..
kubectl port-forward -n fintech svc/churn-risk-api 5000:5000