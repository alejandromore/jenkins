# encriptar archivo de secrets
# Genera un par de llaves PGP (si no lo tienes):

gpg --full-generate-key
gpg --list-keys

# Crea tu archivo de secretos YAML, por ejemplo secrets.yaml:
# secrets.yaml
DB_USER: "admin"
DB_PASSWORD: "SuperSecreta123!"
API_KEY: "abcdef-123456"

# Encripta el archivo con sops:
sops --encrypt --pgp <tu-fingerprint> secrets.yaml > secrets.enc.yaml

kubectl apply -f secrets.yaml -n default
kubectl get secrets -n catalog

$env:KUBECONFIG="C:\Users\Huawei\Downloads\cce-jenkins-kubeconfig.yaml"

$env:KUBECONFIG="C:\Users\A00392472\Downloads\cce-jenkins-kubeconfig.yaml"

# Validar acceso
kubectl get nodes

# Orden de despliegue PV Estatico
kubectl apply -f pv.yaml