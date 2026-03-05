region     = "la-south-2"

environment                      = "local"
enterprise_project_name          = "ep-tdp-${TEAM}"
enterprise_project_description   = "Enteprise Project: ${TEAM}"

tags                             = {
    environment = "local"
    project     = "test"
    owner       = "alejandro"
    costcenter  = "it-001"
}

security_group_public             = "sg-tdp-${TEAM}-public"
security_group_cce_eni            = "sg-tdp-${TEAM}-eni"
security_group_cce                = "sg-tdp-${TEAM}-node"

vpc_name                          = "vpc-tdp-${TEAM}-cce"
vpc_cidr                          = "${VPC_CIDR}"
dns_list                          = ["100.125.1.250", "100.125.21.250"]

vpc_subnet_public_name            = "vpc-subnet-public"
vpc_subnet_public_cidr            = "${VPC_SUBNET_PUBLIC_CIDR}"
vpc_subnet_public_gateway_ip      = "10.4.0.1"

vpc_subnet_cce_name               = "vpc-subnet-cce"
vpc_subnet_cce_cidr               = "${VPC_SUBNET_CCE_CIDR}"
vpc_subnet_cce_gateway_ip         = "10.4.32.1"

vpc_subnet_cce_eni_name           = "vpc-subnet-cce-eni"
vpc_subnet_cce_eni_cidr           = "${VPC_SUBNET_CCE_ENI_CIDR}"
vpc_subnet_cce_eni_gateway_ip     = "10.4.64.1"

cce_network_cidr                  = "172.16.0.0/16"
eip_cce_name                      = "eip-${TEAM}-server"

cce_cluster_name                  = "cce-${TEAM}"
cce_cluster_type                  = "VirtualMachine"
cce_cluster_flavor                = "cce.s1.small"
cce_k8s_version                   = "v1.33"
cce_network_type                  = "eni"           #Turbo
cce_authentication_mode           = "rbac"
cce_charging_mode                 = "postPaid"
key_pair_name                     = "basic-project-key"
cce_node_password                 = "P@ssw0rdSecure123!"

ng_name                           = "ng-internet"
ng_spec                           = 1
ng_description                    = "NAT Gateway"

key_alias                         = "alias/infra-secrets-key"
