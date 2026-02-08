# Usar la última Jenkins LTS en lugar de 2.452.1
FROM jenkins/jenkins:lts

USER root

# Instalar cliente SSH si usarás agentes SSH
RUN apt-get update && apt-get install -y --no-install-recommends openssh-client \
    && rm -rf /var/lib/apt/lists/*

USER jenkins

# Copiar plugins.txt y preinstalar plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

# Instalar plugins
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Activar BuildKit al construir (opcional pero recomendado)
# export DOCKER_BUILDKIT=1
