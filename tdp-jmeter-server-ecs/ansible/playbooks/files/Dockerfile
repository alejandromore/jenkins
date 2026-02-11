# Dockerfile para JMeter 5.6.3
FROM openjdk:17-jdk-slim

# Variables
ENV JMETER_VERSION=5.6.3
ENV JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}
ENV PATH=$JMETER_HOME/bin:$PATH

# Instalar dependencias básicas
RUN apt-get update && apt-get install -y wget unzip curl && rm -rf /var/lib/apt/lists/*

# Descargar y descomprimir JMeter
RUN wget https://dlcdn.apache.org/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz -O /tmp/jmeter.tgz \
    && mkdir -p /opt \
    && tar -xzf /tmp/jmeter.tgz -C /opt \
    && rm /tmp/jmeter.tgz

# Puerto por defecto (RMI)
EXPOSE 1099 50000

# Comando por defecto
ENTRYPOINT ["jmeter"]
