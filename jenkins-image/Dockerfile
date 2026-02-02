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
    && rm -rf /var/lib/apt/lists/*

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
