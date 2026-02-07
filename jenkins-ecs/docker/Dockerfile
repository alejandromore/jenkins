FROM jenkins/jenkins:lts-jdk21

USER root

# ===============================
# Paquetes base + Python
# ===============================
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    jq \
    bash \
    openssh-client \
    gnupg \
    ca-certificates \
    unzip \
    postgresql-client \
    python3 \
    python3-pip \
    python3-venv \
    python3-cryptography \
    netcat-openbsd \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# ===============================
# Obsutil (Huawei OBS)
# ===============================
RUN curl -fL https://obs-community.obs.cn-north-1.myhuaweicloud.com/obsutil/current/obsutil_linux_amd64.tar.gz \
    -o /tmp/obsutil.tar.gz \
 && tar -xzf /tmp/obsutil.tar.gz -C /tmp \
 && find /tmp -type f -name obsutil -exec mv {} /usr/local/bin/obsutil \; \
 && chmod +x /usr/local/bin/obsutil \
 && rm -rf /tmp/obsutil*

# ===============================
# Terraform
# ===============================
RUN curl -fsSL \
    https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip \
    -o /tmp/terraform.zip && \
    unzip /tmp/terraform.zip -d /usr/local/bin && \
    rm /tmp/terraform.zip

# ===============================
# kubectl
# ===============================
RUN curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin

# ===============================
# Helm
# ===============================
RUN curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# ===============================
# Huawei Cloud CLI (KooCLI)
# Instalación sin configuración
# ===============================
RUN echo "=== Instalando Huawei Cloud CLI ===" && \
    curl -sSL https://ap-southeast-3-hwcloudcli.obs.ap-southeast-3.myhuaweicloud.com/cli/latest/hcloud_install.sh \
      -o /tmp/hcloud_install.sh && \
    chmod +x /tmp/hcloud_install.sh && \
    echo "y" | /tmp/hcloud_install.sh -y && \
    rm -f /tmp/hcloud_install.sh

# Forzar permisos ejecutables
RUN chmod 755 /usr/local/bin/hcloud

# ===============================
# Aceptar disclaimer del KooCLI
# (clave para CI/CD)
# ===============================
RUN echo "y" | hcloud --version || true

# ===============================
# Python virtualenv para Jenkins
# ===============================
RUN python3 -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

RUN /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install \
        ansible==8.6.0 \
        ansible-lint \
        huaweicloudsdkcore \
        huaweicloudsdkcce \
        huaweicloudsdkrds \
        huaweicloudsdkobs \
        psycopg2-binary \
        boto3

# ===============================
# Permisos Jenkins
# ===============================
RUN chown -R jenkins:jenkins /opt/venv

# ===============================
# Plugins Jenkins
# ===============================
RUN mkdir -p /usr/share/jenkins/ref/plugins && \
    chown -R jenkins:jenkins /usr/share/jenkins/ref

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

USER jenkins
