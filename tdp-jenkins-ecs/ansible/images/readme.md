##### Utilizando Docker
$env:DOCKER_BUILDKIT=1
docker build --provenance=false --sbom=false -t jenkins-agent-huawei:1.0 -f ./Dockerfile-agent-huawei .
docker build --provenance=false --sbom=false -t jenkins-controller:1.0 -f ./Dockerfile-controller .

docker login -u la-south-2@HST3W35HWFM8MUI418IY -p f7f2e30ce83b56f8bb226204d493ef91665523a7ddcc5a2d613ffdd807192197 swr.la-south-2.myhuaweicloud.com

docker tag jenkins-agent-huawei:1.0 swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-agent-huawei:1.0
docker tag jenkins-controller:1.0 swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-controller:1.0

docker push swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-agent-huawei:1.0
docker push swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-controller:1.0

##### Utilizando Podman
podman login -u la-south-2@HST3WIMA3XEFMOOE1V9S -p c449c44026f546e0dd9340908215938c9426ac206fd33040bd5f267be336536c swr.la-south-2.myhuaweicloud.com

podman build -t jenkins-agent-huawei:1.0 -f ./Dockerfile-agent-huawei .
podman build -t jenkins-agent-terraform:1.0 -f ./Dockerfile-agent-terraform .
podman build -t jenkins-controller:1.0 -f ./Dockerfile-controller .

podman tag jenkins-agent-huawei:1.0 swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-agent-huawei:1.0
podman tag jenkins-agent-terraform:1.0 swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-agent-terraform:1.0
podman tag jenkins-controller:1.0 swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-controller:1.0

podman push swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-agent-huawei:1.0
podman push swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-agent-terraform:1.0
podman push swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-controller:1.0


docker compose pull
docker compose down
docker compose up -d
docker logs jenkins