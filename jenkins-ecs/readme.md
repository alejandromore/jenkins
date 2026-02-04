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