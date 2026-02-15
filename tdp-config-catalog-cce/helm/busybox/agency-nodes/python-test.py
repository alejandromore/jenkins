import os
from huaweicloudsdkcore.auth.credentials import InstanceMetadataCredentials
from huaweicloudsdkobs.v3 import ObsClient

# 1. Configurar credenciales basadas en la Agency del nodo
# El SDK consultará http://169.254.169.254 automáticamente
credentials = InstanceMetadataCredentials()

# 2. Inicializar cliente de OBS
obs_client = ObsClient(
    access_key_id=None, 
    secret_access_key=None, 
    server="https://obs.es-west-0.myhuaweicloud.com", # Ajusta tu región
    security_token=None,
    credentials=credentials
)

# 3. Probar acceso
resp = obs_client.listBuckets()
print(f"Buckets encontrados: {resp.body.buckets}")
