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

security_group_public_name        = "sg-basic-ecs-public"

vpc_name                          = "vpc-basic-ecs"
vpc_cidr                          = "10.1.0.0/16"
dns_list                          = ["100.125.1.250", "100.125.21.250"]

vpc_subnet_public_name            = "vpc-subnet-basic-ecs-public"
vpc_subnet_public_cidr            = "10.1.32.0/19"
vpc_subnet_public_gateway_ip      = "10.1.32.1"

ecs_public_name                   = "ecs-public-basic-ecs"
key_pair_name                     = "basic-project-key"