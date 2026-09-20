# jenkins-image — Jenkins local (controlador)

Imagen del Jenkins que corre en la máquina local (`http://localhost:8080`) y que ejecuta los
pipelines `deploy-jenkins-<cuenta>` de
[`tdp-jenkins-ecs`](https://github.com/alejandro-jenkins/tdp-jenkins-ecs) para desplegar un
Jenkins en cada cuenta de Huawei Cloud.

| Componente | Versión |
|---|---|
| Jenkins | `2.568.3-lts-jdk21` (fijada en el `Dockerfile`) |
| Terraform | 1.14.4 |
| Ansible | 8.6.0 (venv en `/opt/venv`) |
| Imagen | `jenkins-hwc:3.0` (`docker-compose.yml`) |

## Configuración

Todo se declara por JCasC en [`casc.yaml`](casc.yaml) (bind-mount, se relee al reiniciar el
contenedor) y los secretos en `secrets.env` (gitignored; plantilla en
[`secrets.env.example`](secrets.env.example)).

### Credenciales (una por cuenta)

| ID | Tipo | user / password | Variables en `secrets.env` |
|---|---|---|---|
| `github-creds` | Username/Password | usuario / token GitHub | `GITHUB_USER`, `GITHUB_TOKEN` |
| `hwc-<cuenta>` | Username/Password | AK / SK (provider Terraform **y** backend OBS del state) | `HWC_<CUENTA>_AK`, `HWC_<CUENTA>_SK` |
| `swr-<cuenta>` | Username/Password | `<region>@<AK>` / token SWR | `SWR_<CUENTA>_USER`, `SWR_<CUENTA>_PASSWORD` |

Cuentas actuales: `alejandro`, `aiops`. Los IDs legacy `hwc-access-key`, `hwc-secret-key` y
`swr-jenkins` siguen existiendo apuntando a la cuenta `alejandro` porque otros Jenkinsfiles del
repo los usan.

Las cuentas sin valores en `secrets.env` quedan con la credencial creada pero vacía; el pipeline
lo detecta y falla con un mensaje claro en la etapa *Resolve account*.

### Jobs

La sección `jobs:` de `casc.yaml` crea por Job DSL un pipeline por cuenta
(`deploy-jenkins-alejandro`, `deploy-jenkins-aiops`, ...), todos apuntando al mismo `Jenkinsfile`
de `tdp-jenkins-ecs`. El pipeline deduce la cuenta del nombre del job.

### Agregar una cuenta

1. `secrets.env`: `HWC_<CUENTA>_AK/SK` y `SWR_<CUENTA>_USER/PASSWORD`.
2. `casc.yaml`: credenciales `hwc-<cuenta>` / `swr-<cuenta>` y el nombre en la lista `ACCOUNTS`.
3. En `tdp-jenkins-ecs`: entrada en `accounts.groovy` y `terraform/accounts/<cuenta>.*`.
4. Reiniciar el contenedor (abajo).

## Operación (podman)

```powershell
# Construir la imagen (tras cambiar Dockerfile o plugins.txt)
podman build --platform linux/amd64 -t jenkins-hwc:3.0 -f Dockerfile .

# Recrear el contenedor (jenkins_data persiste: jobs, historial, plugins)
podman rm -f jenkins-hwc
podman run -d --name jenkins-hwc --platform linux/amd64 --restart unless-stopped `
  -p 8080:8080 -p 50000:50000 `
  --env-file secrets.env `
  -e JAVA_OPTS="-Djenkins.install.runSetupWizard=false" `
  -e CASC_JENKINS_CONFIG=/var/jenkins_home/casc.yaml `
  -v jenkins_data:/var/jenkins_home `
  -v "${PWD}\casc.yaml:/var/jenkins_home/casc.yaml:ro" `
  jenkins-hwc:3.0

# Solo cambió casc.yaml o secrets.env: recrear el contenedor (secrets.env se lee al crear)
# Solo cambió casc.yaml: basta con
podman restart jenkins-hwc

# Logs
podman logs -f jenkins-hwc
```

Con `docker compose` disponible, `docker compose up -d --build` hace lo mismo
([`docker-compose.yml`](docker-compose.yml)).

## Subir de versión

1. Cambiar el `FROM` en el `Dockerfile` (LTS vigente en https://www.jenkins.io/changelog-stable/).
2. Subir el tag en `docker-compose.yml` y en el comando `podman run`.
3. Rebuild + recrear el contenedor. Antes de un bump de core, respaldar el volumen:
   `podman volume export jenkins_data -o jenkins_data.tar`.
