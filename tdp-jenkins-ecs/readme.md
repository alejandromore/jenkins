# Terraform
.\set-env.ps1
terraform init
terraform validate
terraform plan -var-file="local.tfvars" -out=tfplan
terraform apply tfplan
terraform destroy -var-file="local.tfvars" -auto-approve


# Imagen Agente
docker build --provenance=false --sbom=false -t agent-huawei:1.0 -f Dockerfile-agent-huawei ./ansible/playbook/files/
# login remoto
docker login -u la-south-2@HST3W7DIQXFU40MN6WZH -p ce360d5dd25702de2d67f73f75151234d0668b73080d120931851f074354cb1f swr.la-south-2.myhuaweicloud.com
# tag
docker tag agent-huawei:1.0 swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/agent-huawei:1.0
# push
docker push swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/agent-huawei:1.0
