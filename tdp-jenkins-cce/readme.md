# Build the docker image locally
echo "=========================================="
echo "Login en el registry de Huawei Cloud..."
docker login la-south-2.swr.myhuaweicloud.com -u 8ENLOAE2QCECKCRKANEU -p vddTKjKuG8hcNGOb1cYv3jZ03RLlkOFEEhEHphl8

echo "=========================================="
echo "Build y push de la imagen Docker personalizada..."
docker build -t la-south-2.swr.myhuaweicloud.com/cce-basic-app/jenkins-ssh:2.452.1 -f docker/Dockerfile docker/
docker push la-south-2.swr.myhuaweicloud.com/cce-basic-app/jenkins-ssh:2.452.1