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
podman login -u la-south-2@HST3WKXMAFEUIMWGVUAS -p 3ee7ecf5830e0455268daf11a66e9d5ba8be601232e0923e5c37c8e6e28b4aba swr.la-south-2.myhuaweicloud.com

podman build -t jenkins-agent-huawei:1.0 -f ./Dockerfile-agent-huawei .
podman build -t jenkins-agent-terraform:1.0 -f ./Dockerfile-agent-terraform .
podman build -t jenkins-controller:1.0 -f ./Dockerfile-controller .





#Genesis Agents
podman login -u la-south-2@HST3W76SVC252GDFZY5B -p ae632fa5a8fffec8192f1cc5f92997ff109c61feacf0baf756c36a89ed41886e swr.la-south-2.myhuaweicloud.com

podman build -t jenkins-genesisbackjdk21:1.0 -f ./Dockerfile-agent-genesisbackjdk21 .
podman build -t jenkins-genesisfrontnodelts:1.0 -f ./Dockerfile-agent-genesisfrontnodelts .
podman build -t jenkins-genesissecrets:1.0 -f ./Dockerfile-agent-genesissecrets .
podman build -t jenkins-genesisdeploysecurelts:1.0 -f ./Dockerfile-agent-genesisdeploysecurelts .
podman build -t jenkins-genesisimagescan:1.0 -f ./Dockerfile-agent-genesisimagescan .

podman tag jenkins-genesisbackjdk21:1.0 swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-genesisbackjdk21:1.0
podman tag jenkins-genesisfrontnodelts:1.0 swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-genesisfrontnodelts:1.0
podman tag jenkins-genesissecrets:1.0 swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-genesissecrets:1.0
podman tag jenkins-genesisdeploysecurelts:1.0 swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-genesisdeploysecurelts:1.0
podman tag jenkins-genesisimagescan:1.0 swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-genesisimagescan:1.0



podman push swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-genesisbackjdk21:1.0
podman push swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-genesisfrontnodelts:1.0
podman push swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-genesissecrets:1.0
podman push swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-genesisdeploysecurelts:1.0
podman push swr.la-south-2.myhuaweicloud.com/cce-jenkins-integration-organization/jenkins-genesisimagescan:1.0


#En el ECS
docker compose pull
docker compose down
docker compose up -d
docker logs jenkins