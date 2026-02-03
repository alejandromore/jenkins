
docker images

docker volume ls

1. Crear imagen docker
docker-compose up -d

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