$env:KUBECONFIG="C:\Users\A00392472\Downloads\cce-config-catalog-kubeconfig.yaml"
$env:KUBECONFIG="C:\Users\Huawei\Downloads\cce-config-catalog-kubeconfig.yaml"


helm upgrade --install demo-app . -n demo-app --create-namespace --wait --timeout 300s --set elb.id=b4251027-0e17-4312-8841-a83fbf58394c --set secretsStoreCreds.access_key=HPUAJFCAW0JR4SWR8CUB --set secretsStoreCreds.secret_key=P1WMRV6OtaGggERk1jNNEabImdl4fGSixNWDBXv0

kubectl apply -f secrets-store-creds.yaml
kubectl apply -f spc-app-dev-huawei-dew.yaml
kubectl apply -f sa-app-dev-dew.yaml
kubectl apply -f pod-test.yaml
kubectl exec -it pod-test -- /bin/sh
cat /mnt/secrets-store/secret-app1-dev
