region     = "la-south-2"

environment                      = "local"
enterprise_project_name          = "enterprise-app"
tags                             = {
    environment = "local"
    project     = "test"
    owner       = "alejandro"
    costcenter  = "it-001"
}

# ============================================================================
# VARIABLES PARA LA VPC
# ============================================================================
vpc_name = "vpc-tdp-config-catalog-cce"
vpc_cidr = "10.0.0.0/24"

subnets_configuration = [
  {
    name = "vpc-subnet-public"
    cidr = "10.0.0.0/28"
    dns_list = ["100.125.1.250", "100.125.21.250"]
  },
  {
    name = "vpc-subnet-cce"
    cidr = "10.0.0.16/28"
    dns_list = ["100.125.1.250", "100.125.21.250"]
  },
  {
    name = "vpc-subnet-cce-eni"
    cidr = "10.0.0.32/28"
    dns_list = ["100.125.1.250", "100.125.21.250"]
  }
]

security_group_public             = "sg-tdp-config-catalog-cce-public"
security_group_cce_eni            = "sg-tdp-config-catalog-cce-eni"
security_group_cce                = "sg-tdp-config-catalog-cce-node"

# ============================================================================
# VARIABLES PARA EL ELB - EIP
# ============================================================================
eip_elb_name = "eip-elb-public"
eip_ng_name  = "eip-ng-public"
eip_cce_name  = "eip-cce-public"

eip_publicip_configuration = [
  {
    type       = "5_bgp"
    ip_version = "4"
  }
]

eip_bandwidth_configuration = [
  {
    share_type = "PER"
    name       = "bw-tdp-config-catalog-cce"
    size       = 5
  }
]

# ============================================================================
# VARIABLES PARA NAT Gateway
# ============================================================================
ng_name                           = "ng-internet"
ng_spec                           = 1
ng_description                    = "NAT Gateway"

# ============================================================================
# VARIABLES PARA CCE
# ============================================================================
cce_network_cidr                  = "172.16.0.0/16"
cce_cluster_name                  = "cce-config-catalog"
cce_cluster_type                  = "VirtualMachine"
cce_cluster_flavor                = "cce.s1.small"
cce_k8s_version                   = "v1.33"
cce_network_type                  = "vpc-router"   #Standard
#cce_network_type                  = "eni"           #Turbo
cce_authentication_mode           = "rbac"
cce_charging_mode                 = "postPaid"
cce_node_password                 = "P@ssw0rdSecure123!"

key_pair_name                     = "basic-project-key"


dew_secret_name                   = "secret-app1-dev"
dew_secret_description            = "App Dev Secrets"

key_alias                         = "alias/infra-secrets-key"