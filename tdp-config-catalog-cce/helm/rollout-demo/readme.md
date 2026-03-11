kubectl argo rollouts get rollout demo-rollout -n rollout-demo --watch

STEP 1  setWeight 20
STEP 2  pause
STEP 3  setWeight 50
STEP 4  pause


kubectl argo rollouts promote demo-rollout -n rollout-demo

-------------------Canary
1️⃣ Crear namespace (solo la primera vez)
kubectl create namespace rollout-demo
2️⃣ Crear el service
kubectl apply -f base/service.yaml
3️⃣ Desplegar versión inicial (v1)
kubectl apply -f v1/rollout.yaml
kubectl argo rollouts get rollout demo-rollout -n rollout-demo
4️⃣ Exponer el servicio
kubectl port-forward svc/demo-service 8080:80 -n rollout-demo
5️⃣ Generar tráfico En terminal 2:
.\canary-watch.ps1
6️⃣ Desplegar la nueva versión (v2)
kubectl apply -f v2/rollout.yaml
7️⃣ Observar el rollout
kubectl argo rollouts get rollout demo-rollout -n rollout-demo --watch
8️⃣ Promover si está pausado
kubectl argo rollouts promote demo-rollout -n rollout-demo