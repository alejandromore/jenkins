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
vpc_cidr = "10.3.0.0/16"

subnets_configuration = [
  {
    name = "vpc-subnet-tdp-jenkins"
    cidr = "10.3.32.0/19"
    dns_list = ["100.125.1.250", "100.125.21.250"]
  }
]

security_group_name = "sg-tdp-jenkins-public"

# ============================================================================
# VARIABLES PARA EL ECS
# ============================================================================
instance_name = "ecs-tdp-jenkins"

instance_flavor_cpu_core_count = 4
instance_flavor_memory_size    = 8

keypair_name = "basic-project-key"

instance_disks_configuration = [
  {
    is_system_disk = true
    type           = "SSD"
    size           = 50
  },
  {
    is_system_disk = false
    name           = "data-disk-demo-0"
    type           = "SSD"
    size           = 100
  }
]

# ============================================================================
# VARIABLES PARA EL ECS - EIP
# ============================================================================
eip_name = "eip-ecs-tdp-jenkins"

eip_publicip_configuration = [
  {
    type       = "5_bgp"
    ip_version = "4"
  }
]

eip_bandwidth_configuration = [
  {
    share_type = "PER"
    name       = "eip-bw-ecs-tdp-jenkins"
    size       = 5
  }
]