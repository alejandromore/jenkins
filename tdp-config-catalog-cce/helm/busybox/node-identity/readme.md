$env:KUBECONFIG="C:\Users\A00392472\Downloads\cce-config-catalog-kubeconfig.yaml"
$env:KUBECONFIG="C:\Users\Huawei\Downloads\cce-config-catalog-kubeconfig.yaml"

# Steps
[Terraform] Create agency
[Terraform] Associate Node Pool (ECSs) to agency
[Consola] Habilitar el campo Settings - Network - Pod Access to Metadata

kubectl apply -f cm-obsutil-setup.yaml
kubectl apply -f pod-agency-test.yaml

kubectl exec -it pod-agency-test -- /bin/sh
curl http://169.254.169.254


# Validar acceso
kubectl get nodes
kubectl delete pod pod-agency-test
kubectl exec -it pod-agency-test -- /bin/sh
obsutil ls
