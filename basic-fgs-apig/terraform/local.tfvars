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

security_group_public_name        = "sg-basic-fgs-apig-public"

vpc_name                          = "vpc-basic-fgs-apig"
vpc_cidr                          = "10.1.0.0/16"
dns_list                          = ["100.125.1.250", "100.125.21.250"]

vpc_subnet_public_name            = "vpc-subnet-basic-fgs-apig-public"
vpc_subnet_public_cidr            = "10.1.32.0/19"
vpc_subnet_public_gateway_ip      = "10.1.32.1"

apig_name                         = "apig-publc"
apig_edition                      = "BASIC"
apig_description                  = "APIG Basic"
apig_stage_name                   = "DEV"
apig_stage_description            = "APIG Stage"
apig_bandwith_size                = 5
apig_ingress_bandwith_size        = 5
apig_ingress_charging             = "bandwidth"

api_group_name                    = "api-group-apis"
api_group_description             = "API Group APIS" 

fgs_name                          = "fg_basic_py_event"
fgs_runtime                       = "Python3.9"
fgs_handler                       = "index.handler"
fgs_memory_size                   = 128
fgs_code_type                     = "obs"
app_file                          = "fg-py-hello-world.zip"

obs_bucket_name                   = "obs-apps-alejandro"
obs_bucket_acl                    = "private"
obs_storage_class                 = "STANDARD"
