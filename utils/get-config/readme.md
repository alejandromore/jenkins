terraform init 

terraform import -var-file="local.tfvars" huaweicloud_cce_cluster.mi_cluster_turbo 38be2e6d-0ba2-11f1-9307-0255ac100249
terraform import -var-file="local.tfvars" huaweicloud_identity_agency.ecs-obs-agency 478fb311bc424ffa976f0b6fec14782c

terraform show