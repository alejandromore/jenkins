# Terraform
.\set-env.ps1
terraform init
terraform validate
terraform plan -var-file="local.tfvars" -out=tfplan
terraform apply tfplan
terraform destroy -var-file="local.tfvars" -auto-approve


# Imagen Agente
$env:DOCKER_BUILDKIT=1
docker build `
  --provenance=false `
  --sbom=false `
  -t agent-huawei:1.0 `
  -f ./ansible/playbook/files/Dockerfile-agent-huawei `
  ./ansible/playbook/files/
  
# login remoto
docker login -u la-south-2@HST3W28G3LCA8DY3HFYV -p 7a620b2d6e4c7c8ad22dc2ebdbe69ba6e090a653b2fed09f57d919d7af4d0f37 swr.la-south-2.myhuaweicloud.com
# tag
docker tag agent-huawei:1.0 swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/agent-huawei:1.0
# push
docker push swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/agent-huawei:1.0
