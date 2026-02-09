$schema = terraform providers schema -json | ConvertFrom-Json
$huaweicloudProvider = $schema.provider_schemas["registry.terraform.io/huaweicloud/huaweicloud"]

$huaweicloudProvider.resource_types.Keys
$huaweicloudProvider.resource_types["huaweicloud_sfs_turbo"].block.attributes.Keys

# Build the docker image locally

echo "=========================================="
echo "Build y push de la imagen Docker personalizada..."
# 1️⃣ Build de la imagen Jenkins con SSH
docker build -t swr.la-south-2.myhuaweicloud.com/cce-basic-app/jenkins-ssh:lts -f docker/Dockerfile docker/

# 2️⃣ (Opcional) Tag adicional si quieres mantener un nombre "local"
docker tag swr.la-south-2.myhuaweicloud.com/cce-basic-app/jenkins-ssh:lts swr.la-south-2.myhuaweicloud.com/cce-basic-app/jenkins-ssh:lts

# 3️⃣ Push a Huawei SWR
docker push swr.la-south-2.myhuaweicloud.com/cce-basic-app/jenkins-ssh:lts