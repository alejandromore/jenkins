$namespace="ingress-nginx"

Write-Host "Adding Helm repository..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

Write-Host "Checking namespace..."
kubectl get namespace $namespace 2>$null
if ($LASTEXITCODE -ne 0) {
    kubectl create namespace $namespace
}

Write-Host "Installing nginx ingress..."

helm upgrade --install nginx-ingress ingress-nginx/ingress-nginx `
  --namespace $namespace `
  --values values-nginx-ingress.yaml

Write-Host "Waiting for controller..."

kubectl rollout status deployment/nginx-ingress-ingress-nginx-controller `
  -n $namespace