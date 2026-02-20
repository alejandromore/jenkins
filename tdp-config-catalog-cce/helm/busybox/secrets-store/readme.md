Patron: Secrets Store CSI Driver with Azure Key Vault
Service Principal legacy (client_id + client_secret)

Azure Legacy	                  | Huawei Equivalente
----------------------------------------------------------------
Service Principal                 | IAM User Programatic
client_id	                      | Access Key
client_secret	                   | Secret Key
Key Vault	                      | CSMS (DEW)
csi-secrets-store-provider-azure  | CCE Secrets Manager for DEW

[Terraform] instalar add on Secrets Store CSI Driver
[Terraform] crear usuario IAM (AK y SK) y privilegios
[Terraform] crear un Secret en el CCE con las credenciales AK y SK
[Helm]      crear el SecretProviderClass
[Helm]      crear el ServiceAccount


$env:KUBECONFIG="C:\Users\A00392472\Downloads\cce-config-catalog-kubeconfig.yaml"
$env:KUBECONFIG="C:\Users\Huawei\Downloads\cce-config-catalog-kubeconfig.yaml"


kubectl apply -f secrets-store-creds.yaml
kubectl apply -f spc-app-dev-huawei-dew.yaml
kubectl apply -f sa-app-dev-dew.yaml
kubectl apply -f pod-test.yaml
kubectl exec -it pod-test -- /bin/sh
cat /mnt/secrets-store/secret-app1-dev

ServiceAccount
   ↓ (autorización)
SecretProviderClass
   ↓ (solicitud)
DEW CSMS
   ↓
Volume mount in POD

kubectl apply -f cm-obsutil-setup.yaml
kubectl apply -f pod-obs-test.yaml
kubectl exec -it pod-obs-test -- /bin/sh



helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts

helm install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver --namespace kube-system