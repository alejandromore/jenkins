
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

---- Configuracion Base
Uso	                        Tipo	                        ID recomendado
Huawei Cloud Access Key	    Secret Text	                    HWC_ACCESS_KEY
Huawei Cloud Secret Key	    Secret Text	                    HWC_SECRET_KEY
GitHub repo	                Username/Password o SSH Key	    github-creds

git update-index --skip-worktree secrets/*.txt

setx HUAWEICLOUD_REGION "la-south-2"
setx HUAWEICLOUD_ACCESS_KEY "8ENLOAE2QCECKCRKANEU"
setx HUAWEICLOUD_SECRET_KEY "vddTKjKuG8hcNGOb1cYv3jZ03RLlkOFEEhEHphl8"


hcloud cce cluster get-kubeconfig --cluster-id "a8bbfe11-01ef-11f1-8f6f-0255ac10023b" --file ./kubeconfig.yaml --region "$HUAWEICLOUD_REGION" --assume-yes
hcloud cce cluster get-kubeconfig --cluster-id=a8bbfe11-01ef-11f1-8f6f-0255ac10023b --file=./kubeconfig.yaml --region=la-south-2
hcloud CCE ShowClusterConfig --cluster_id="a8bbfe11-01ef-11f1-8f6f-0255ac10023b" --cli-region="la-south-2" > kubeconfig.yaml
hcloud CCE ShowNodePool --cli-region="la-south-2"

hcloud CCE ShowClusterConfig --cli-region="la-south-2" --Content-Type="application/json"
hcloud CCE CreateClusterKubeconfig --clusterid="a8bbfe11-01ef-11f1-8f6f-0255ac10023b" --cli-output=json

curl -s -X POST https://iam.myhuaweicloud.com/v3/auth/tokens
{
  "auth": {
      "identity": {
          "methods": ["hw_ak_sk"],
          "hw_ak_sk": {
              "access": {
                  "key": "8ENLOAE2QCECKCRKANEU"
              },
              "secret": {
                  "key": "vddTKjKuG8hcNGOb1cYv3jZ03RLlkOFEEhEHphl8"
              }
          }
      },
      "scope": {
          "project": {
              "name": "la-south-2"
          }
      }
  }
}

curl -s -X POST \
  https://cce.la-south-2.myhuaweicloud.com/api/v3/projects/${PROJECT_ID}/clusters/${CLUSTER_ID}/clustercert \
  -H "X-Auth-Token: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"validity": 180}' \
  > kubeconfig.yaml