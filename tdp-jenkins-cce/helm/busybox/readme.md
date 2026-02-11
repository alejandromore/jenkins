$env:KUBECONFIG="C:\Users\Huawei\Downloads\cce-jenkins-kubeconfig.yaml"

$env:KUBECONFIG="C:\Users\A00392472\Downloads\cce-jenkins-kubeconfig.yaml"

# Validar acceso
kubectl get nodes

# Orden de despliegue PV Estatico
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml
kubectl apply -f pod-test.yaml

# Orden de despliegue PV Dinamico
kubectl apply -f storageclass.yaml
kubectl apply -f pvc.yaml
kubectl apply -f pod-test.yaml

# Verifica
kubectl get pv
kubectl get pvc
kubectl get pod

# Probar conexión
kubectl exec -it sfs-test-pod -- sh
cd /data
touch prueba.txt
ls -l /data

rm -rf /data/*

kubectl exec -it web-demo-7ff8d577b4-wlh4g -- sh
kubectl delete namespace jenkins
