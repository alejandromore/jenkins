terraform init 

terraform import -var-file="local.tfvars" huaweicloud_cce_cluster.mi_cluster_turbo 38be2e6d-0ba2-11f1-9307-0255ac100249
terraform import -var-file="local.tfvars" huaweicloud_identity_agency.ecs-obs-agency 478fb311bc424ffa976f0b6fec14782c

terraform import -var-file="local.tfvars" huaweicloud_cce_addon.secrets_manager_dew a63e1ee2-0e5f-11f1-9307-0255ac100249/dew-provider

terraform import huaweicloud_cce_addon.secrets_manager_dew a63e1ee2-0e5f-11f1-9307-0255ac100249/3f8d3c5e-xxxx-xxxx

terraform show
terraform state show huaweicloud_cce_addon.secrets_manager_dew