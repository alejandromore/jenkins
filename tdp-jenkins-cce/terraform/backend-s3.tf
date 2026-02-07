terraform {
  backend "s3" {
    # Credentciales del backend
    access_key = "8ENLOAE2QCECKCRKANEU"
    secret_key = "vddTKjKuG8hcNGOb1cYv3jZ03RLlkOFEEhEHphl8"
    region = "us-east-1"  # Cualquier región válida de AWS

    # Bucket y archivo en el OBS
    bucket = "obs-alejandro-terraform-tfstate"
    key    = "tdp-jenkins-cce.tfstate"
    endpoint = "https://obs.la-south-2.myhuaweicloud.com"

    # Usa virtual-hosted style (requerido por Huawei Cloud)
    use_path_style              = false
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true  
  }
}