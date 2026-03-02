# ============================================================================
# VARIABLES GENERALES
# ============================================================================
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
vpc_cidr = "10.3.0.0/16"

subnets_configuration = [
  {
    name = "vpc-subnet-jenkins-public"
    cidr = "10.3.32.0/19"
    dns_list = ["100.125.1.250", "100.125.21.250"]
  }
]

security_group_name = "sg-tdp-jenkins-public"

# ============================================================================
# VARIABLES PARA EL ECS
# ============================================================================
/*
instance_flavor_cpu_core_count = 4
instance_flavor_memory_size    = 8
instance_image_os_type      = "Ubuntu 24.04 server 64bit"
instance_image_architecture = "x86"
instance_name = "ecs-tdp-jenkins"

instance_disks_configuration = [
  {
    is_system_disk = true
    type           = "SSD"
    size           = 200
  },
  {
    is_system_disk = false
    name           = "data-disk-tdp-jenkins-0"
    type           = "SSD"
    size           = 100
  }
]

key_pair_name                     = "basic-project-key"
private_key_name                  = "basic-project-private-key"
*/