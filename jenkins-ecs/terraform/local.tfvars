region     = "la-south-2"

environment                      = "local"
enterprise_project_name          = "enterprise-app"
tags                             = {
    environment = "local"
    project     = "test"
    owner       = "alejandro"
    costcenter  = "it-001"
}

cloud_init_config = <<-EOF
  #cloud-config
  timezone: America/Lima
  runcmd:
    - [ timedatectl, set-timezone, America/Lima ]
EOF

security_group_public_name        = "sg-jenkins-public"

vpc_name                          = "vpc-jenkins"
vpc_cidr                          = "10.2.0.0/16"
dns_list                          = ["100.125.1.250", "100.125.21.250"]

vpc_subnet_public_name            = "vpc-subnet-jenkins-public"
vpc_subnet_public_cidr            = "10.2.32.0/19"
vpc_subnet_public_gateway_ip      = "10.2.32.1"

ecs_public_name                   = "ecs-jenkins"
key_pair_name                     = "basic-project-key"