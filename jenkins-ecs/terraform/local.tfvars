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

security_group_public_name        = "sg-jenkins-public"

vpc_name                          = "vpc-jenkins"
vpc_cidr                          = "10.2.0.0/16"
dns_list                          = ["100.125.1.250", "100.125.21.250"]

vpc_subnet_public_name            = "vpc-subnet-jenkins-public"
vpc_subnet_public_cidr            = "10.2.32.0/19"
vpc_subnet_public_gateway_ip      = "10.2.32.1"

ecs_public_name                   = "ecs-jenkins"

agency_name                       = "ecs-secrets-access-agency"
agency_description                = "Agency para autorizae ECS al SWR"
agency_delegated_service_name     = "op_svc_ecs"
agency_duration                   = "FOREVER"