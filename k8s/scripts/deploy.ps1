# Apply Secrets (Manual step usually, but for dev we use env files or skipped)
# kubectl apply -f k8s/config/secrets.yaml

# Apply Deployments and Services
kubectl apply -f k8s/config/credit-deployment.yaml
kubectl apply -f k8s/config/payment-deployment.yaml

echo "Deployments applied."
