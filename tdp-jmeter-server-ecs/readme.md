# Paso 1: Crear la carpeta dentro del contenedor
docker exec -it jmeter-server bash
mkdir -p /opt/jmeter
exit

# Paso 2: Copiar el archivo .jmx
docker cp app-java.jmx jmeter-server:/opt/jmeter/tp-app-java.jmx

# Paso 3: Crear carpeta de resultados
docker exec -it jmeter-server bash
mkdir -p /opt/jmeter/results
exit

# Después de esto, tu contenedor tendrá:
/opt/jmeter/tp-app-java.jmx
/opt/jmeter/results/

docker exec -it jmeter-server bash
jmeter -n -t /opt/jmeter/tp-app-java.jmx -l /opt/jmeter/results/results.jtl






docker ps
docker logs -f jmeter-server

![Diagrama Arquitectura](./architecture.jpg)

Provider: huaweicloud v1.85.0

cd .\examples\basic-app-bd

terraform init
terraform validate
terraform plan -var-file="local.tfvars"
terraform apply -auto-approve -var-file="local.tfvars"

terraform plan -var-file="local.tfvars" -out=tfplan
terraform show -json tfplan > tfplan.json

#Destroy environment
terraform destroy -auto-approve -var-file="local.tfvars"

git remote add origin https://github.com/huawei-delivery-peru/huaweicloud-terraform.git
git branch -M main
git add --all
git remote -v
git commit -m "First commit"
git push -u origin main

http://110.238.64.126:8081/app-java/healthCheck
http://110.238.64.126:8081/app-java/clientes
http://110.238.64.126:8081/app-java/dew-info

docker login -u 8ENLOAE2QCECKCRKANEU -p vddTKjKuG8hcNGOb1cYv3jZ03RLlkOFEEhEHphl8 https://swr.la-south-2.myhuaweicloud.com