region     = "la-south-2"

enterprise_project_name          = "enterprise-app"

tags                             = {
    environment = "local"
    project     = "test"
    owner       = "alejandro"
    costcenter  = "it-001"
}

key_pair_name                     = "basic-project-key"
key_alias                         = "alias/infra-secrets-key"

dew_secret_name                   = "secret-app1-dev"
dew_secret_description            = "App Dev Secrets"