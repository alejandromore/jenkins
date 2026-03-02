.\set-env.ps1

terraform init

terraform validate

terraform plan -var-file="local.tfvars" -out=tfplan

terraform apply tfplan

terraform destroy