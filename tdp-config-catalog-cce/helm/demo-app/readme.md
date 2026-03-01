$env:KUBECONFIG="C:\Users\A00392472\Downloads\cce-config-catalog-kubeconfig.yaml"
$env:KUBECONFIG="C:\Users\Huawei\Downloads\cce-config-catalog-kubeconfig.yaml"


helm upgrade --install demo-app . -n demo-app --create-namespace --wait --timeout 300s --set elb.id=a0299b45-f3f9-4d4a-94b9-511d90db0973 --set secretsStoreCreds.access_key=HPUAWFHAOV1FNHFO6E8P --set secretsStoreCreds.secret_key=YD0zWuXs3FlxGox1Z5Pv3Q0EzPGyFt6BX1rLDp4r

kubectl apply -f secrets-store-creds.yaml
kubectl apply -f spc-app-dev-huawei-dew.yaml
kubectl apply -f sa-app-dev-dew.yaml
kubectl apply -f pod-test.yaml
kubectl exec -it pod-test -- /bin/sh
cat /mnt/secrets-store/secret-app1-dev
