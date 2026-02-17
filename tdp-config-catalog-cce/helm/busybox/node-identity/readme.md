$env:KUBECONFIG="C:\Users\A00392472\Downloads\cce-config-catalog-kubeconfig.yaml"
$env:KUBECONFIG="C:\Users\Huawei\Downloads\cce-config-catalog-kubeconfig.yaml"

# Steps
[Terraform] Create agency
[Terraform] Associate Node Pool (ECSs) to agency
[Consola] Habilitar el campo Settings - Network - Pod Access to Metadata

kubectl apply -f cm-obsutil-setup.yaml
kubectl apply -f pod-obs-test.yaml
kubectl exec -it pod-obs-test -- /bin/sh
curl http://169.254.169.254

kubectl apply -f cm-hcloud-setup.yaml
kubectl apply -f pod-dew-test.yaml
kubectl exec -it pod-dew-test -- /bin/sh
curl -s http://169.254.169.254/openstack/latest/securitykey





# Validar acceso
kubectl get nodes
kubectl delete pod pod-obs-test
kubectl delete pod pod-dew-test
obsutil ls
