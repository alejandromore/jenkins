#alejandro.more@huawei.com
#hwstaff_intl_a00392472
#access_key = "8ENLOAE2QCECKCRKANEU"
#secret_key = "vddTKjKuG8hcNGOb1cYv3jZ03RLlkOFEEhEHphl8"
region     = "la-south-2"

environment                      = "local"
enterprise_project_name          = "enterprise-app"
tags                             = {
    environment = "local"
    project     = "test"
    owner       = "alejandro"
    costcenter  = "it-001"
}

security_group_public_name        = "sg-app-public"
security_group_data_name          = "sg-app-data"

vpc_name                          = "vpc-app"
vpc_cidr                          = "10.1.0.0/16"
dns_list                          = ["100.125.1.250", "100.125.21.250"]

vpc_subnet_public_name            = "vpc-subnet-public"
vpc_subnet_public_cidr            = "10.1.0.0/19"
vpc_subnet_public_gateway_ip      = "10.1.0.1"

vpc_subnet_data_name              = "vpc-subnet-data"
vpc_subnet_data_cidr              = "10.1.64.0/19"
vpc_subnet_data_gateway_ip        = "10.1.64.1"

rds_postgres_name                 = "rds-postgres"
rds_postgres_password             = "P@ssw0rdSecure123!"
rds_postgres_flavor               = "rds.pg.n1.large.2"
rds_postgres_volume_size          = 40

ecs_public_name                   = "ecs-app-public"

dew_secret_name                   = "db-credentials"
dew_secret_description            = "Credentiales de BD"