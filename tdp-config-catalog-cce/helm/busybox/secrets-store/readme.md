Patron: Secrets Store CSI Driver with Azure Key Vault
Service Principal legacy (client_id + client_secret)

Azure Legacy	                  | Huawei Equivalente
----------------------------------------------------------------
Service Principal                 | IAM User Programatic
client_id	                      | Access Key
client_secret	                  | Secret Key
Managed Identity                  | Agency
Key Vault	                      | CSMS (DEW)
csi-secrets-store-provider-azure  | CCE Secrets Manager for DEW

[Terraform] crear usuario IAM (AK y SK) y privilegios
[Terraform] crear CSMS (DEW) guardando AK y SK
[Terraform] instalar add on Secrets Store CSI Driver


$env:KUBECONFIG="C:\Users\A00392472\Downloads\cce-config-catalog-kubeconfig.yaml"
$env:KUBECONFIG="C:\Users\Huawei\Downloads\cce-config-catalog-kubeconfig.yaml"

# Secrets Store CSI Driver
CCE Secrets Manager for DEW

helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts

helm install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver --namespace kube-system