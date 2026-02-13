$env:KUBECONFIG="C:\Users\A00392472\Downloads\cce-jenkins-kubeconfig.yaml"
$env:KUBECONFIG="C:\Users\A00392472\Downloads\cce-config-catalog-kubeconfig.yaml"

# Validar acceso
kubectl get nodes

# Ejecutar yamls
kubectl apply -f service-account.yaml

kubectl apply -f pod-agency-test.yaml
kubectl exec -it pod-agency-test -- /bin/sh

# Instala curl (en Alpine)
apk add curl

# Obtén las credenciales temporales:
curl http://169.254.169.254
# JSON esperado
{
  "credential": {
    "access": "AK_TEMPORAL_XXXX",
    "secret": "SK_TEMPORAL_YYYY",
    "securitytoken": "TOKEN_ZZZZ",
    "expires_at": "2023-10-27T10:00:00Z"
  }
}

kubectl delete pod agency-test
