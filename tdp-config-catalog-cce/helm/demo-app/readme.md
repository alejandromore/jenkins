$env:KUBECONFIG="C:\Users\A00392472\Downloads\cce-config-catalog-kubeconfig.yaml"
$env:KUBECONFIG="C:\Users\Huawei\Downloads\cce-config-catalog-kubeconfig.yaml"


helm upgrade --install demo-app . -n demo-app --create-namespace --wait --timeout 300s --set elb.id=2a49bd8f-9ce0-4ffa-a466-c3f3b065a17b --set secretsStoreCreds.access_key=HPUAXD2SC79NHBLHVUQW --set secretsStoreCreds.secret_key=zkG0BNslPAIm9mybwn5Tg3D8EAAvD9PUo1bH6ylz



kubectl apply -f secrets-store-creds.yaml
kubectl apply -f spc-app-dev-huawei-dew.yaml
kubectl apply -f sa-app-dev-dew.yaml
kubectl apply -f pod-test.yaml
kubectl exec -it pod-test -- /bin/sh
cat /mnt/secrets-store/secret-app1-dev
