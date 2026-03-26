# Construir localmente
docker compose build --no-cache

# Login to SWR
docker login -u la-south-2@HST3WYM94KP843RRQEBV -p 30a2c15562b9748a5a8a29a75393004310c5affc7006744a465d90161ff7daab swr.la-south-2.myhuaweicloud.com

# Tag in SWR
docker tag jenkins-hwc:2.0 swr.la-south-2.myhuaweicloud.com/cce-basic-app/jenkins-hwc:2.0

# Push to SWR
docker push swr.la-south-2.myhuaweicloud.com/cce-basic-app/jenkins-hwc:2.0

docker compose push

# Ejecutar localmente
docker-compose up -d

Secrets por defecto, estan en el archivo secrets.env, 
Uso	                                Tipo	                        ID 
----------------------------------------------------------------------------------------------
Huawei Cloud Access Key	            Secret Text	                    HWC_ACCESS_KEY
Huawei Cloud Secret Key	            Secret Text	                    HWC_SECRET_KEY
GitHub repo	                        Username/Password o SSH Key	    github-creds
CCE Kubeconfig file for Jenkins     file                            cce-jenkins-kubeconfig
CCE Kubeconfig file for App         file                            ce-app-kubeconfig
SWR Login Jenkins                   Username/Password o SSH Key     swr-jenkins


git update-index --skip-worktree secrets.env

-----------------------

docker images

docker volume ls

1. Crear imagen docker
docker-compose up -d
docker-compose up -d --build

2. Detener y borrar el docker
docker stop jenkins
docker rm jenkins

3. Iniciar imagen
docker run -d `
  --name jenkins `
  --restart unless-stopped `
  -p 8080:8080 `
  -p 50000:50000 `
  -v jenkins_home:/var/jenkins_home `
  jenkins-terraform:1.7.5

4. Ver Log
docker logs jenkins

3. Acceder a Jenkins
http://localhost:8080

4. Obtener password inicial
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
Password: 259488c2c82a450eba9366dfcf17eaf2

git update-index --skip-worktree secrets/*.txt

setx HUAWEICLOUD_REGION "la-south-2"
setx HUAWEICLOUD_ACCESS_KEY "8ENLOAE2QCECKCRKANEU"
setx HUAWEICLOUD_SECRET_KEY "vddTKjKuG8hcNGOb1cYv3jZ03RLlkOFEEhEHphl8"

# compatible con SWR
setx DOCKER_BUILDKIT 1
setx BUILDKIT_PROVENANCE false
setx BUILDKIT_SBOM false
setx BUILDKIT_OUTPUT_FORMAT docker
setx DOCKER_DEFAULT_PLATFORM linux/amd64

setx DOCKER_BUILDKIT 0

docker compose build --no-cache
docker compose push

docker-compose up -d --build

docker tag jenkins-hwc:1.0 swr.la-south-2.myhuaweicloud.com/cce-basic-app/jenkins-hwc:1.0.0

docker login -u la-south-2@HST3WZLQY47S41GW38DJ -p 7f1a60eeb60c684566511e1e9c68fe13a352cb6755ed1cc4d763c7a7ef9a6185 swr.la-south-2.myhuaweicloud.com

docker push swr.la-south-2.myhuaweicloud.com/cce-basic-app/jenkins-hwc:1.0.0





