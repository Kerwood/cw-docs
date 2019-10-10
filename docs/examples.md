# Examples
## Keycloak
[https://github.com/Kerwood/keycloak-example](https://github.com/Kerwood/keycloak-example)

Docker compose example on Keycloak.

```
version: '3'

volumes:
  keycloak-db:

services:
  keycloak:
    image: jboss/keycloak:latest
    container_name: keycloak
    ports:
      - 8080:8080
    environment:
      # Create a user after the container up and running with the following command
      # or uncomment below environment variables.
      # docker exec <container> keycloak/bin/add-user-keycloak.sh -u <username> -p <password>
      #KEYCLOAK_USER: 'admin'
      #KEYCLOAK_PASSWORD: 'admin'
      PROXY_ADDRESS_FORWARDING: 'true'
      DB_VENDOR: 'mariadb'
      DB_ADDR: 'mariadb'
      DB_PORT: '3306'
      DB_DATABASE: 'keycloak'
      DB_USER: 'keycloak'
      DB_PASSWORD: 'database-password-here'

  mariadb:
    image: mariadb:5
    container_name: keycloak-db
    restart: unless-stopped
    expose:
      - 3306
    volumes:
      - keycloak-db:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: 'root-password-here'
      MYSQL_DATABASE: 'keycloak'
      MYSQL_USER: 'keycloak'
      MYSQL_PASSWORD: 'database-password-here'
```

![](https://search-guard.com/wp-content/uploads/2018/07/keycloak_add_client.png)

## Home Assisstant
[https://github.com/Kerwood/deconz-home-assistant-example](https://github.com/Kerwood/deconz-home-assistant-example)

Docker compose example of deCONZ and Home Assistant.  
Change the mount point of the two volumes and make sure that your Conbee device is at /dev/ttyUSB0.

```
version: "3"
services:
  deconz:
    image: marthoc/deconz
    container_name: deconz
    network_mode: host
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /home/kerwood/conbee/deconz_data:/root/.local/share/dresden-elektronik/deCONZ
    devices:
      - /dev/ttyUSB0
    environment:
      - DECONZ_WEB_PORT=80
      - DECONZ_WS_PORT=443
      - DEBUG_INFO=1
      - DEBUG_APS=0
      - DEBUG_ZCL=0
      - DEBUG_ZDP=0
      - DEBUG_OTAU=0

  homeassistant:
    container_name: home-assistant
    image: homeassistant/home-assistant
    restart: unless-stopped
    network_mode: host
    volumes:
      - /home/kerwood/conbee/HA_config:/config
      - /etc/localtime:/etc/localtime:ro
```
![](https://i0.wp.com/smartyhome.io/wp-content/uploads/2017/12/Pasted_Image_12_2_17__8_54_PM-1.png?resize=750%2C410&ssl=1)


## Seafile
[https://github.com/haiwen/seafile-docker](https://github.com/haiwen/seafile-docker)

Seafile is an open source file sync&share solution designed for high reliability, performance and productivity. Sync, share and collaborate across devices and teams. Build your team's knowledge base with Seafile's built-in Wiki feature.

```
docker run -d --name seafile \
  -e SEAFILE_SERVER_HOSTNAME=seafile.example.com \
  -e SEAFILE_ADMIN_EMAIL=me@example.com \
  -e SEAFILE_ADMIN_PASSWORD=a_very_secret_password \
  -v /opt/seafile-data:/shared \
  -p 80:80 \
  seafileltd/seafile:latest
```
Seafile will only be available on `SEAFILE_SERVER_HOSTNAME`, so put it in your `hosts` file or something.

![](https://upload.wikimedia.org/wikipedia/commons/7/7e/Seafile_web_interface.png)

## Owncloud
[https://hub.docker.com/_/owncloud](https://hub.docker.com/_/owncloud)

ownCloud is a self-hosted file sync and share server. It provides access to your data through a web interface, sync clients or WebDAV while providing a platform to view, sync and share across devices easily—all under your control. ownCloud’s open architecture is extensible via a simple but powerful API for applications and plugins and it works with any storage.

```
docker run --name owncloud -p 80:80 -d owncloud:8.1
```
![](https://owncloud.org/wp-content/uploads/2017/12/owncloud-server-web-ui.jpg)


## Portainer
[https://www.portainer.io/](https://www.portainer.io/)

Portainer is a lightweight management UI which allows you to easily manage your different Docker environments (Docker hosts or Swarm clusters). Portainer is meant to be as simple to deploy as it is to use. 

```
docker run -d -p 8000:8000 -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer
```
![](https://d1jiktx90t87hr.cloudfront.net/354/wp-content/uploads/sites/2/2018/12/homescreen.png)

## Dockercraft
[https://github.com/docker/dockercraft](https://github.com/docker/dockercraft)

A simple Minecraft Docker client, to visualize and manage Docker containers.
![](https://raw.githubusercontent.com/docker/dockercraft/master/docs/img/logo.png)

## Traefik
An open-source reverse proxy and load balancer for HTTP and TCP-based applications that is easy, dynamic, automatic, fast, full-featured, production proven, provides metrics, and integrates with every major cluster technology.

![](https://docs.traefik.io/assets/img/providers/docker.png)

For both exampels, create a network.
```
docker network create traefik-public
```

### With out TLS
#### Docker compose file
```
version: '3.7'

networks:
  default:
    external: true
    name: traefik-public

services:
  traefik:
    image: traefik
    container_name: traefik
    restart: unless-stopped
    command: --api \
             --loglevel=info \ 
             --defaultentrypoints=http,https
             --entrypoints="Name:http Address::80" \
             --docker \
             --docker.endpoint="unix:///var/run/docker.sock" \
             --docker.watch=true \
             --docker.exposedbydefault=false \
    ports:
      - 80:80
    labels:
      - traefik.enable=true
      - traefik.frontend.rule=Host:traefik.example.org
      - traefik.port=8080
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```

### With TLS
Create `acme.json` file to store certificates.

```
touch /srv/traefik/acme.json
chmod 600 /srv/traefik/acme.json
```
#### Docker compose file
```
version: '3.7'

networks:
  default:
    external: true
    name: traefik-public

  traefik:
    image: traefik
    container_name: traefik
    restart: unless-stopped
    command: --api \
             --loglevel=info \ 
             --defaultentrypoints=http,https
             --entrypoints="Name:http Address::80 Redirect.EntryPoint:https" \
             --entrypoints="Name:https Address::443 TLS" \
             --docker \
             --docker.endpoint="unix:///var/run/docker.sock" \
             --docker.watch=true \
             --docker.exposedbydefault=false \
             --acme=true \
             --acme.email=my@mail.com \
             --acme.entrypoint=https
             --acme.storage=/acme.json \
             --acme.onhostrule=true \
             --acme.httpChallenge.entryPoint=http
    ports:
      - 80:80
      - 443:443
    labels:
      - traefik.enable=true
      - traefik.frontend.rule=Host:traefik.example.org
      - traefik.port=8080
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /srv/traefik/acme.json:/acme.json
```

### Add service
#### Docker compose file
```
version: '3.7'

networks:
  default:
    external: true
    name: traefik-public

services:
  hello-world:
    image: kerwood/hello-world
    container_name: hello-world
    expose:
      - 80
    labels:
      - traefik.enable=true
      - traefik.frontend.rule=Host:hello-world.example.org
      - traefik.port=80
```
