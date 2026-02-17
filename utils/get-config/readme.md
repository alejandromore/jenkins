terraform init 

terraform import -var-file="local.tfvars" huaweicloud_cce_cluster.mi_cluster_turbo 38be2e6d-0ba2-11f1-9307-0255ac100249

terraform show > cce-turbo.log