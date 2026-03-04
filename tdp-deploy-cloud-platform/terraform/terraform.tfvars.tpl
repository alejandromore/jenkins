# ============================================================================
# VARIABLES GENERALES
# ============================================================================
region                           = "la-south-2"
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

# ============================================================================
# VARIABLES PARA LA VPC
# ============================================================================
vpc_name = "vpc-tdp-jenkins"
vpc_cidr = "${VPC_CIDR}"

subnets_configuration = [
  {
    name = "vpc-subnet-tdp-jenkins"
    cidr = "${SUBNET_CIDR}"
    dns_list = ["100.125.1.250", "100.125.21.250"]
  }
]

security_group_name = "sg-tdp-jenkins-public"
security_group_description = "Created by terraform module"

