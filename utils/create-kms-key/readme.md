terraform init 

terraform plan -var-file="local.tfvars" -out=tfplan

terraform apply tfplan