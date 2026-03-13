# dashboard
kubectl argo rollouts dashboard --namespace rollout-demo
http://localhost:3100/rollouts/rollout-demo

# Crear namespace (solo la primera vez)
kubectl create namespace rollout-demo
-------------------Canary
[Terminal-1] Deploy v1
# Crear el service
kubectl apply -f base/service.yaml
kubectl apply -f base/httproute.yaml
kubectl apply -f base/gateway.yaml
# Desplegar versión inicial (v1)
kubectl apply -f v1/rollout.yaml

[Terminal-2] Generar trafico
kubectl run load-generator -n rollout-demo `
--image=busybox `
--restart=Never `
-- /bin/sh -c "while true; do wget -q -O- http://demo-stable.rollout-demo; sleep 1; done"

[Terminal-1] Deploy v2
# Desplegar la nueva versión (v2)
kubectl apply -f v2/rollout.yaml

-------------------Blue - Green
[Terminal-1] Deploy v1
# Deploy infraestructura
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

kubectl argo rollouts dashboard --namespace rollout-demo
kubectl argo rollouts undo demo-rollou
kubectl argo rollouts promote demo-rollout -n rollout-demo
kubectl argo rollouts get rollout demo-rollout -n rollout-demo --watch
kubectl delete rollout demo-rollout -n rollout-demo
kubectl apply -f v1/rollout.yaml

# Ver tráfico generado
kubectl logs -f pod/load-generator -n rollout-demo
