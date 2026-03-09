terraform init 

terraform import -var-file="local.tfvars" huaweicloud_cce_cluster.mi_cluster_turbo 38be2e6d-0ba2-11f1-9307-0255ac100249
terraform import -var-file="local.tfvars" huaweicloud_identity_agency.ecs-obs-agency 478fb311bc424ffa976f0b6fec14782c

terraform import -var-file="local.tfvars" huaweicloud_cce_addon.secrets_manager_dew a63e1ee2-0e5f-11f1-9307-0255ac100249/dew-provider




terraform import -var-file="local.tfvars" huaweicloud_cce_addon.ingress_controller 17b294eb-1bbe-11f1-8f6f-0255ac10023b/6cf810f9-b3e5-4ed0-a46e-d3b3076f9202



terraform import -var-file="local.tfvars" huaweicloud_cce_addon.ingress_controller 6cf810f9-b3e5-4ed0-a46e-d3b3076f9202

terraform import -var-file="local.tfvars" huaweicloud_cce_addon.nginx_ingress 6cf810f9-b3e5-4ed0-a46e-d3b3076f9202/nginx-ingress

hcloud cce ListAddonInstances --cluster_id=17b294eb-1bbe-11f1-8f6f-0255ac10023b --cli-region=la-south-2



terraform import huaweicloud_cce_addon.secrets_manager_dew a63e1ee2-0e5f-11f1-9307-0255ac100249/3f8d3c5e-xxxx-xxxx


terraform show > cce-addon.log
terraform state show huaweicloud_cce_addon.secrets_manager_dew

#terraform import huaweicloud_identity_group_role_assignment.obs_assignment <group_id>/<role_id>/<project_id>
#terraform import huaweicloud_identity_group_role_assignment.obs_assignment d8ccd1d818004d2cb4de25f72134ebcb

-var-file="local.tfvars"

terraform import -var-file="local.tfvars" huaweicloud_identity_group_role_assignment.obs_assignment d8ccd1d818004d2cb4de25f72134ebcb/ROLE_ID_OBS/ENTERPRISE_PROJECT_ID


terraform state rm huaweicloud_identity_group_role_assignment.obs_assignment

<group_id>/<role_id>/<enterprise_project_id_real>
terraform import -var-file="local.tfvars" `
huaweicloud_identity_group_role_assignment.obs_assignment `
d8ccd1d818004d2cb4de25f72134ebcb/8eb36151949e434e857a3446e58cf107/4dcc0216-fe93-4eb0-a1a9-3032e195af78

terraform import -var-file="local.tfvars" `
huaweicloud_identity_group_role_assignment.csms_assignment `
d8ccd1d818004d2cb4de25f72134ebcb/0536f2ae1ea5465ca498c7f98ad58510/4dcc0216-fe93-4eb0-a1a9-3032e195af78

terraform plan -var-file="local.tfvars"




hcloud CCE ListAddonTemplates --cli-region=la-south-2 --addon_template_name=nginx-ingress