$env:KUBECONFIG="C:\Users\A00392472\Downloads\cce-config-catalog-kubeconfig.yaml"
$env:KUBECONFIG="C:\Users\Huawei\Downloads\cce-config-catalog-kubeconfig.yaml"

[Terraform] Create Identity Provider y Rules
[Helm]      Create Service Account
[Helm]      Desplegar PODs




# Obtain the Signature Public Key of the CCE Cluster
kubectl get --raw /openid/v1/jwks

# Create Identity Provider
kubectl get --raw /.well-known/openid-configuration
obtener campo issuer - para crear el Identity Provider


# Create service account
en el POD se han mantado 2 carpetas
ls /mnt/secrets-store
ls /var/run/secrets/tokens
ls /var/run/secrets/kubernetes.io/serviceaccount



kubectl apply -f sa-workload-identity.yaml -n workload-identity
kubectl apply -f spc-app-dev-huawei-dew.yaml -n workload-identity
kubectl apply -f dp-pod-test.yaml -n workload-identity
kubectl apply -f cm-obsutil-setup.yaml -n workload-identity
kubectl apply -f dp-pod-obs-test.yaml -n workload-identity


# Create test obs
kubectl apply -f cm-obsutil-setup.yaml
kubectl apply -f pod-obs-test.yaml
kubectl exec -it pod-obs-test -- /bin/sh
obsutil ls
obsutil cp obs://obs-alejandro-app1-dev/CatalogoErroresTabla.json ./CatalogoErroresTabla.json
# Create test dew
kubectl apply -f cm-hcloud-setup.yaml
kubectl apply -f pod-dew-test.yaml
kubectl exec -it pod-dew-test -- /bin/sh
hcloud CSMS ListSecrets --region=la-south-2




# documentacion
https://support.huaweicloud.com/intl/en-us/bestpractice-cce/cce_bestpractice_0333.html


http://169.254.169.254/openstack/latest/securitykey




# Validar acceso
kubectl get nodes
kubectl delete pod pod-obs-test
kubectl delete pod pod-dew-test

