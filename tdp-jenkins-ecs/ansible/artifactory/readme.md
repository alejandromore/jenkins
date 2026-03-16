docker compose up -d

podman compose up -d
podman compose down
podman compose logs -f
podman logs -f artifactory
podman logs -f artifactory-postgres

podman exec -it artifactory cat /var/opt/jfrog/artifactory/var/etc/access/bootstrap.password

podman volume rm artifactory_artifactory-data
podman volume rm artifactory_postgres-data
podman volume prune
podman ps -a
podman rm -f artifactory artifactory-postgres

# UI
http://localhost:8081
# Docker registry
http://localhost:8082