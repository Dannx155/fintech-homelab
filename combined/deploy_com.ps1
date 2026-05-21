# Step 1: Build Docker image
docker build -t churn-risk-api:latest ./app

# Step 2: Terraform creates namespace
cd combined/terraform
terraform init
terraform apply -auto-approve
cd ../..

# Step 3: Kubernetes deploys the app
kubectl apply -f combined/k8s/deployment.yaml
kubectl apply -f combined/k8s/service.yaml
kubectl rollout status deployment/churn-risk-api -n fintech

# Step 4: Forward port
kubectl port-forward -n fintech svc/churn-risk-api 5000:5000