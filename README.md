# PHP project template
A batteries-included, fully containerized PHP project template.

## Getting started

### Prerequisites

- Docker
- [traefik-localdev](https://github.com/thomasbruninx/traefik-localdev) instance


## Project structure
By default, the template has the following structure:

```
php-project/                        # Project root
|-- config/                         # Configuration files
    |-- php/                        # Additional PHP configuration files
        |-- zzz-10-custom.ini       # Custom PHP configuration
        |-- zzz-99-local.ini        # Local custom PHP configuration (gets ignored by Git)
    |-- httpd/                      # Additional Apache2 configuration files
        |-- 000-default.ini         # Custom HTTPD configuration
|-- docs/                           # Project documentation
|-- public/                         # Public web folder (DocumentRoot)
    |-- assets/                     # Public assets (Images, CSS, ...)
    |-- index.php                   # Example index.php
|-- src/                            # Actual PHP source code
|-- tests/                          # Unit tests
|-- vendor/                         # Composer vendor directory (will appear after running composer install)
|-- .env.example                    # Example .env file (template for .development.env and .production.env)
|-- .init.env.example               # Example .init.env file, used for initializing a new MariaDB instance
|-- composer.json                   # Composer project file
|-- composer.lock                   # Composer dependency version lock file
|-- Dockerfile                      # Dockerfile describing the project assembly 
|-- docker-compose.development.yml  # Docker Compose file describing the hosting stack used for development
|-- docker-compose.production.yml   # Docker Compose file describing the hosting stack used for production
```


### Configuration

#### Environment variables through .env files
Dynamic configuration (like domain name, database settings, ...) gets done with .env files. Both compose files (production and development) source their own .env file (`.production.env` and `.development.env` respectively). An example .env is provided in this repository.

For the initialization of a MariaDB database, the `.init.env` file can be used to set an additional user, create an empty database and changing the root user's password. An example of this file is also provided in this repository.

#### Custom httpd configuration
In the `./config/httpd` directory a `000-default.conf` file can be found. This maps directly to `/etc/apache2/sites-available/000-default.conf` file of the php-apache container.

#### Custom php configuration
In the `./config/php` directory a `zzz-10-custom.ini` file can be found. This gets injected into the `/usr/local/etc/php/conf.d/` folder of the php-apache container. This file gets loaded after all the builtin and default PHP configuration files in the php-apache container.

Additionally, you can define a `zzz-99-local.ini` in the `./config/php` directory to define a local configuration. This file gets loaded after the `zzz-10-custom.ini` file and gets ignored by Git by default.


### Usage

#### Development

1. Create a .development.env file to configure your project instance

2. (Optional) Create an .init.env to initialize the MariaDB instance

3. Launch hosting stack:
   ```
   docker compose --env-file .development.env -f docker-compose.development.yml up -d
   ```
All source code and configuration files are accessible for the container through "bind" mounts. You can edit them on the fly, without the need to restart the Docker container.

#### Production

1. Create a .production.env file to configure your project instance

2. (Optional) Create an .init.env to initialize the MariaDB instance

3. Create a docker-compose.hosting.yml with the necessary networking and proxy configuration like this example:
   ```
   services:
     app:
       restart: 'unless-stopped'
       networks:
         - default
         - management
       labels:
         - "traefik.enable=true"
         - "traefik.enable=true"
         - "traefik.http.routers.$DOCKER_PREFIX-http.rule=Host(`$WWW_DOMAIN`)"
         - "traefik.http.routers.$DOCKER_PREFIX-http.entrypoints=web"
         - "traefik.http.routers.$DOCKER_PREFIX-http.middlewares=$DOCKER_PREFIX-https"
         - "traefik.http.middlewares.$DOCKER_PREFIX-https.redirectscheme.scheme=https"
         - "traefik.http.routers.$DOCKER_PREFIX.rule=Host(`$WWW_DOMAIN`)"
         - "traefik.http.routers.$DOCKER_PREFIX.entrypoints=websecure"
         - "traefik.http.routers.$DOCKER_PREFIX.tls.certresolver=letsencrypt"
         - "traefik.http.services.$DOCKER_PREFIX-app.loadbalancer.server.port=8080"
         - "traefik.http.services.$DOCKER_PREFIX-app.loadbalancer.passhostheader=true"    
     database:
       restart: 'unless-stopped'
       networks:
         - management
   networks:
     default:
       name: proxy-network
       external: true
     management:
       name: mgmt-network
       external: true
   ```

4. Launch hosting stack:
   ```
   docker compose --env-file .production.env -f docker-compose.production.yml -f docker-compose.hosting.yml up -d
   ```

The source code, dependencies and configuration files are baked into the Docker image. The SQL database and httpd's /tmp and /var/uploads folders are mounted as Docker volumes.

## General recommendations
TODO

## Known issues

- In the docker-compose.development.yml file we reference the `host.docker.internal`variable in the XDebug configuration. Unfortunately, this doesn't work properly on Linux systems. To fix this you should put in your hostname instead.

