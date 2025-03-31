# PHP project template
A batteries-included, fully containerized PHP project template.

## Getting started

### Prerequisites

- Docker
- [traefik-localdev](https://github.com/thomasbruninx/traefik-localdev) instance

### Configuration



### Usage

#### Development

1. Create a .development.env file to configure your project instance

2. (Optional) Create an .init.env to initialize the MariaDB instance

3. Launch hosting stack:
   ```
   docker compose --env-file .development.env -f docker-compose.development.yml up -d
   ```

#### Production

1. Create a .production.env file to configure your project instance

2. (Optional) Create an .init.env to initialize the MariaDB instance

3. Launch hosting stack:
   ```
   docker compose --env-file .production.env -f docker-compose.production.yml up -d
   ```

## Project structure
By default the template has the following structure:

```
php-project/                    # Project root
|-- config/                     # Configuration files
    |-- php/                    # Additional PHP configuration files
    |-- apache2/                # Additional Apache2 configuration files
|-- docs/                       # Project documentation
|-- public/                     # Public web folder (DocumentRoot)
    |-- assets/                 # Public assets (Images, CSS, ...)
    |-- index.php               # Example index.php
|-- src/                        # Actual PHP source code
|-- tests/                      # Unit tests
|-- vendor/                     # Composer vendor directory (will appear after running composer install)
.env.example                    # Example .env file (template for .development.env and .production.env)
.init.env.example               # Example .init.env file, used for initializing a new MariaDB instance
composer.json                   # Composer project file
composer.lock                   # Composer dependency version lock file
Dockerfile                      # Dockerfile describing the project assembly 
docker-compose.development.yml  # Docker Compose file describing the hosting stack used for development
docker-compose.production.yml   # Docker Compose file describing the hosting stack used for production
```

## General recommendations


## Known issues


## TODO
- Finish this README.md
