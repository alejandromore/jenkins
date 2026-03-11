# dashboard
kubectl argo rollouts dashboard --namespace rollout-demo
http://localhost:3100/rollouts/rollout-demo

# 1. Crear namespace (solo la primera vez)
kubectl create namespace rollout-demo
-------------------Canary
[Terminal-1] Deploy y observar rollout
# 2️. Crear el service
kubectl apply -f base/service.yaml
# 3️. Desplegar versión inicial (v1)
kubectl apply -f v1/rollout.yaml
# 4. Observar el rollout
kubectl argo rollouts dashboard --namespace rollout-demo

[Terminal-2] Generador de tráfico dentro del cluster
# 5. Exponer el servicio
kubectl run load-generator -n rollout-demo --image=busybox --restart=Never `
-- /bin/sh -c "while true; do wget -q -O- http://demo-service.rollout-demo; done"
# 6️. Ver tráfico generado
kubectl logs -f pod/load-generator -n rollout-demo

[Terminal-3] Lanzar el Canary
# 6️. Desplegar la nueva versión (v2)
kubectl apply -f v2/rollout.yaml

-------------------Blue - Green
# 2. Deploy infraestructura
kubectl apply -f base/gateway.yaml
kubectl apply -f base/httproute.yaml
kubectl apply -f base/active-service.yaml
kubectl apply -f base/preview-service.yaml

# Deploy Blue
kubectl apply -f blue/rollout.yaml

# Generar tráfico
kubectl run load-generator -n rollout-demo --image=busybox --restart=Never `
-- /bin/sh -c "while true; do wget -q -O- http://demo-active.rollout-demo; done"
# Ver tráfico generado
kubectl logs -f pod/load-generator -n rollout-demo

# Desplegar Green
kubectl apply -f green/rollout.yaml

# Promover Green
kubectl argo rollouts promote demo-rollout -n rollout-demo
# Rollback
kubectl argo rollouts undo demo-rollout -n rollout-demo



kubectl delete namespace rollout-demo

kubectl argo rollouts undo demo-rollou
kubectl argo rollouts promote demo-rollout -n rollout-demo
kubectl argo rollouts get rollout demo-rollout -n rollout-demo --watch