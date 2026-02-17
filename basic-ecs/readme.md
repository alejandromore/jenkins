# Instalar CURL
export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get install -y curl tar ca-certificates

# Ver el nombre del agency asociado
curl http://169.254.169.254

# Obtener credenciales temporales (AK, SK y Token)
curl http://169.254.169.254managed_role/cce-obs-agency

# Descarga e instalación
curl -Lk "https://obs-community.obs.myhuaweicloud.com/obsutil/current/obsutil_linux_amd64.tar.gz" -o obsutil_linux_amd64.tar.gz

tar -xzvf obsutil_linux_amd64.tar.gz
FOLDER=$(ls -d obsutil_linux_amd64_*)
mv $FOLDER/obsutil /usr/local/bin/
chmod +x /usr/local/bin/obsutil

# Configuración usando el Agency de Huawei Cloud
./obsutil config -i=ECS -e=obs.la-south-2.myhuaweicloud.com
./obsutil ls