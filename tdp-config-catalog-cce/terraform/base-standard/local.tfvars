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
dns_list = ["100.125.1.250", "100.125.21.250"]

vpc_name = "vpc-tdp-config-catalog-cce"
vpc_cidr = "10.0.0.0/24"

vpc_subnet_cce_name           = "vpc-subnet-cce"
vpc_subnet_cce_cidr           = "10.0.0.0/26"
vpc_subnet_cce_gateway_ip     = "10.0.0.1"

security_group_elb            = "sg-tdp-config-catalog-cce-elb"
security_group_cce            = "sg-tdp-config-catalog-cce"

# ============================================================================
# VARIABLES PARA EL ELB - EIP
# ============================================================================
bandwidth_name = "bw-shared"
bandwidth_size = 5

eip_elb_name  = "eip-elb-public"
eip_ng_name   = "eip-ng-public"
eip_cce_name  = "eip-cce-public"

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
#cce_network_type                  = "vpc-router"   #Standard
cce_network_type                  = "overlay_l2"   #Standard
#cce_network_type                  = "eni"           #Turbo
cce_authentication_mode           = "rbac"
cce_charging_mode                 = "postPaid"
cce_node_password                 = "P@ssw0rdSecure123!"

key_pair_name                     = "basic-project-key"

dew_secret_name                   = "secret-app1-dev"
dew_secret_description            = "App Dev Secrets"

key_alias                         = "alias/infra-secrets-key"