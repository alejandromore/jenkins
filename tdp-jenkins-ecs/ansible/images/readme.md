# Imagen Agente
$env:DOCKER_BUILDKIT=1
docker build --provenance=false --sbom=false -t jenkins-agent-huawei:1.0 -f ./Dockerfile-agent-huawei .
docker build --provenance=false --sbom=false -t jenkins-controller:1.0 -f ./Dockerfile-controller .



# login remoto
docker login -u la-south-2@HST3W35HWFM8MUI418IY -p f7f2e30ce83b56f8bb226204d493ef91665523a7ddcc5a2d613ffdd807192197 swr.la-south-2.myhuaweicloud.com

# tag
docker tag jenkins-agent-huawei:1.0 swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-agent-huawei:1.0
docker tag jenkins-controller:1.0 swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-controller:1.0

# push
docker push swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-agent-huawei:1.0
docker push swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-controller:1.0


podman build -t jenkins-agent-huawei:1.0 -f ./Dockerfile-agent-huawei .
podman login -u la-south-2@HST3W35HWFM8MUI418IY -p f7f2e30ce83b56f8bb226204d493ef91665523a7ddcc5a2d613ffdd807192197 swr.la-south-2.myhuaweicloud.com
podman tag jenkins-agent-huawei:1.0 swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-agent-huawei:1.0
podman push swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-agent-huawei:1.0