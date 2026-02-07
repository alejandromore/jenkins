#alejandro.more@huawei.com
#hwstaff_intl_a00392472
#access_key = "8ENLOAE2QCECKCRKANEU"
#secret_key = "vddTKjKuG8hcNGOb1cYv3jZ03RLlkOFEEhEHphl8"
region     = "la-south-2"
project_id = "0371a9a7f90b493fadebbf130f6fcd2c"

environment                      = "local"
enterprise_project_name          = "enterprise-app"
tags                             = {
    environment = "local"
    project     = "test"
    owner       = "alejandro"
    costcenter  = "it-001"
}

security_group_public             = "sg-app-public"
security_group_cce_eni            = "sg-app-cce-eni"
security_group_cce                = "sg-app-cce-node"
security_group_data               = "sg-app-data"

vpc_name                          = "vpc-app"
vpc_cidr                          = "10.1.0.0/16"
dns_list                          = ["100.125.1.250", "100.125.21.250"]

vpc_subnet_public_name            = "vpc-subnet-public"
vpc_subnet_public_cidr            = "10.1.0.0/19"
vpc_subnet_public_gateway_ip      = "10.1.0.1"

vpc_subnet_cce_name               = "vpc-subnet-cce"
vpc_subnet_cce_cidr               = "10.1.32.0/19"
vpc_subnet_cce_gateway_ip         = "10.1.32.1"

vpc_subnet_cce_eni_name           = "vpc-subnet-cce-eni"
vpc_subnet_cce_eni_cidr           = "10.1.64.0/19"
vpc_subnet_cce_eni_gateway_ip     = "10.1.64.1"

vpc_subnet_data_name              = "vpc-subnet-data"
vpc_subnet_data_cidr              = "10.1.96.0/19"
vpc_subnet_data_gateway_ip        = "10.1.96.1"

cce_network_cidr                  = "172.16.0.0/16"

rds_postgres_name                 = "rds-postgres"
rds_postgres_password             = "P@ssw0rdSecure123!"
rds_postgres_flavor               = "rds.pg.n1.large.2"
rds_postgres_volume_size          = 40

dew_secret_name                   = "db-credentials"
dew_secret_description            = "Credentiales de BD"

eip_cce_name                      = "eip-cce-app"

cce_cluster_name                  = "cce-app"
cce_cluster_type                  = "VirtualMachine"
cce_cluster_flavor                = "cce.s1.small"
cce_k8s_version                   = "v1.32"
cce_network_type                  = "vpc-router"

cce_authentication_mode           = "rbac"
cce_charging_mode                 = "postPaid"
cce_node_password                 = "P@ssw0rdSecure123!"

ng_name                           = "ng-internet"
ng_spec                           = 1
ng_description                    = "NAT Gateway"