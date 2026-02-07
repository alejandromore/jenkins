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

security_group_public_name        = "sg-basic-rds-public"

vpc_name                          = "vpc-basic-rds"
vpc_cidr                          = "10.1.0.0/16"
dns_list                          = ["100.125.1.250", "100.125.21.250"]

vpc_subnet_public_name            = "vpc-subnet-rds-public"
vpc_subnet_public_cidr            = "10.1.32.0/19"
vpc_subnet_public_gateway_ip      = "10.1.32.1"

rds_postgres_name                 = "rds-postgres"
rds_postgres_password             = "P@ssw0rdSecure123!"
rds_postgres_flavor               = "rds.pg.n1.large.2"
rds_postgres_volume_size          = 40
