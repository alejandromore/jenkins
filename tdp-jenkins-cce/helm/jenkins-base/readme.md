export KUBECONFIG=\$KUBECONFIG
$env:KUBECONFIG="C:\Users\A00392472\Downloads\cce-jenkins-kubeconfig.yaml"

# Validar acceso
kubectl get nodes
kubectl get namespace
kubectl get secret -n jenkins

# Crear Namespace para Jenkins
kubectl create namespace jenkins

# Helm chart oficial está en Jenkins CI:
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm repo list

kubectl delete namespace jenkins

helm upgrade `
    --install jenkins ./jenkins-base `
    -n jenkins --create-namespace -f ./jenkins-base/values.yaml `
    --set persistence.sfsIP=10.1.32.2

helm upgrade --install jenkins ./helm-jenkins \
  --set persistence.sfsId=94396aa4-8d80-423f-93ca-2a56abf0c700


# Inicializar Jenkins
http://<EXTERNAL-IP>:8080
kubectl exec -n jenkins -it $(kubectl get pods -n jenkins -l app=jenkins-master -o jsonpath="{.items[0].metadata.name}") -- cat /var/jenkins_home/secrets/initialAdminPassword


helm upgrade --install ${releaseName} ./${config.chartDir} \\
    -n ${namespace} \\
    --create-namespace \\
    --wait \\
    --timeout ${timeoutSeconds}s \\
    --set elb.id=${config.elbId} \\
    --set-string app.healthPath=${healthEndpoint}


# Configurar almacenamiento persistente
kubectl apply -f pv-jenkins.yaml
kubectl apply -f pvc-jenkins.yaml

# Crear Deployment de Jenkins Master
kubectl apply -f jenkins-master-deployment.yaml
kubectl get pods -n jenkins

# Exponer Jenkins con un Service (LoadBalancer)
kubectl apply -f jenkins-service.yaml
kubectl get svc -n jenkins



6) Configurar Jenkins para ejecutar Agents en Kubernetes

Este paso permite a Jenkins lanzar build agents automáticamente como pods en tu CCE:

Instalación de plugin:

En Jenkins UI:

🔹 Manage Jenkins → Manage Plugins
🔹 Instala Kubernetes Plugin.

Configurar Cloud en Jenkins:

Ve a Manage Jenkins → Configure System.

Busca Cloud → Add a new Cloud → Kubernetes.

Define:

Kubernetes URL: deja en blanco para usar el interno.

Kubernetes Namespace: jenkins.

Credentials: crea credencial tipo Kubeconfig usando tu kubeconfig de CCE.

Agrega un Pod Template para agentes:

Name: jenkins-agent

Containers:

Image: jenkins/inbound-agent

Label: jenkins-agent

Guarda la configuración.

📌 Ahora Jenkins podrá crear agentes dinámicos en tu cluster para ejecutar jobs usando pods.