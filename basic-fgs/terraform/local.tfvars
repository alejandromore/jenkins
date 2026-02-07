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

security_group_public             = "sg-basic-fgs-public"

vpc_name                          = "vpc-basic-fgs"
vpc_cidr                          = "10.1.0.0/16"
dns_list                          = ["100.125.1.250", "100.125.21.250"]

vpc_subnet_public_name            = "vpc-subnet-basic-fgs-public"
vpc_subnet_public_cidr            = "10.1.32.0/19"
vpc_subnet_public_gateway_ip      = "10.1.32.1"

fgs_name                          = "fg-py-hello-world"
fgs_runtime                       = "Python3.9"
fgs_handler                       = "index.handler"
fgs_memory_size                   = 128
fgs_code_type                     = "obs"
app_file                          = "fg-py-hello-world.zip"

obs_bucket_name                   = "obs-apps-alejandro"
obs_bucket_acl                    = "private"
obs_storage_class                 = "STANDARD"
