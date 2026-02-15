# Steps
- Create agency
- Associate ECS to agency
- Enable in CCE console
En el menú izquierdo, ve a Settings (Configuraciones) > Network (Red).
Pod Access to Metadata
Habilitar la opción en la Consola de CCE
- Verify connectivity from POD to 
kubectl exec -it pod-agency-test -- curl http://169.254.169.254
curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"
curl -H "X-aws-ec2-metadata-token: <TOKEN>" \
http://169.254.169.254/latest/meta-data/iam/security-credentials/
curl https://obs.<region>.myhuaweicloud.com



$env:KUBECONFIG="C:\Users\A00392472\Downloads\cce-config-catalog-kubeconfig.yaml"

# Validar acceso
kubectl get nodes

# Ejecutar yamls
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

