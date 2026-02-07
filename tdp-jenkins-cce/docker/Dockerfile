FROM jenkins/jenkins:2.452.1

USER root

# Instalar cliente SSH si usarás agentes SSH
RUN apt-get update && apt-get install -y openssh-client

USER jenkins

# Copiar plugins.txt y preinstalar plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
