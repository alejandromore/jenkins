$env:KUBECONFIG="C:\Users\A00392472\Downloads\cce-config-catalog-kubeconfig.yaml"

./install-nginx-ingress.ps1
./install-dew-provider.ps1

kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx

hcloud CCE ListAddonTemplates --cli-region=la-south-2 > addons.txt
hcloud CCE ListAddonInstances --cli-region=la-south-2 --cluster_id=17b294eb-1bbe-11f1-8f6f-0255ac10023b > addons-installed.txt



helm uninstall envoy-gateway -n envoy-gateway-system
helm upgrade --install envoy-gateway oci://docker.io/envoyproxy/gateway-helm -n envoy-gateway-system --create-namespace --wait --timeout 300s -f envoy-controller/values.yaml

helm uninstall gateway-infra -n envoy-gateway-system

helm upgrade --install gateway-infra ./gateway-infra -n envoy-gateway-system --create-namespace --wait --timeout 300s --set-string elb.id=55252264-0994-42a9-9491-336dcac870cf


helm uninstall envoy-gateway -n envoy-gateway-system
helm uninstall gateway-infra -n envoy-gateway-system

# Probar WAF