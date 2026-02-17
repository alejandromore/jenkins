# Steps
- Create agency
- Associate Node Pool (ECSs) to agency
kubectl apply -f service-account.yaml
kubectl apply -f pod-agency-test.yaml
kubectl exec -it pod-agency-test -- /bin/sh
curl http://169.254.169.254





apk add python3 py3-pip
pip install awscli
export AWS_DEFAULT_REGION=<tu-region>
aws s3 ls --endpoint-url https://obs.<region>.myhuaweicloud.com


$env:KUBECONFIG="C:\Users\A00392472\Downloads\cce-config-catalog-kubeconfig.yaml"
$env:KUBECONFIG="C:\Users\A00392472\Downloads\cce-turbo-kubeconfig.yaml"

# Validar acceso
kubectl get nodes

# Ejecutar yamls
kubectl apply -f service-account.yaml
kubectl apply -f pod-agency-test.yaml
kubectl delete pod pod-agency-test

kubectl exec -it pod-agency-test -- /bin/sh

# Instala curl (en Alpine)
apk add curl

# Obtén las credenciales temporales:
curl http://169.254.169.254
curl http://169.254.169.254 | grep "agency"

# JSON esperado
{
  "credential": {
    "access": "AK_TEMPORAL_XXXX",
    "secret": "SK_TEMPORAL_YYYY",
    "securitytoken": "TOKEN_ZZZZ",
    "expires_at": "2023-10-27T10:00:00Z"
  }
}

# Descargar hcloud CLI para Alpine (Linux 64 bit)
curl -LO "https://hwcloudcli.obs.cn-north-1.myhuaweicloud.com"
tar -xvzf huaweicloud-cli-linux-amd64.tar.gz
./hcloud configure set --cli-auth-mode=agency --cli-agency-name=cce_node_agency --cli-region=<TU_REGION>

# Probar DEW/CSMS
./hcloud CSMS ListSecrets

