# Developer Documentation — Inception

This document is intended for developers who want to understand, set up, build, and maintain the Inception infrastructure from scratch.

---

## Prerequisites

Before setting up the project, make sure the following tools are installed on your system:

| Tool | Minimum version | Purpose |
|---|---|---|
| `docker` | 24.x | Container engine |
| `docker compose` (plugin) | 2.x | Multi-container orchestration |
| `make` | any | Build automation |
| `git` | any | Version control |

> The project is designed to run inside a **Linux virtual machine** (Debian or Alpine recommended). Running it directly on macOS or Windows may require adjustments.

Check your versions:

```bash
docker --version
docker compose version
make --version
```

---

## Setting Up the Environment from Scratch

### 1. Clone the repository

```bash
git clone https://github.com/lserodon/inception.git
cd inception
```

### 2. Configure the `.env` file

Create the environment file at `srcs/.env` (or at the root, depending on your `docker-compose.yml` path):

```bash
cp srcs/.env.example srcs/.env   # if an example file exists
# or create it manually:
touch srcs/.env
```

Fill it with the following variables:

```env
DOMAIN_NAME=lserodon.42.fr

# MariaDB
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=your_db_password
MYSQL_ROOT_PASSWORD=your_root_password

# WordPress
WP_TITLE=Inception
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=your_wp_admin_password
WP_ADMIN_EMAIL=admin@lserodon.42.fr
WP_USER=user
WP_USER_PASSWORD=your_wp_user_password
WP_USER_EMAIL=user@lserodon.42.fr
```

> ⚠️ The `.env` file is listed in `.gitignore` and must **never** be committed to the repository.

### 3. Update `/etc/hosts`

Add the domain name to your local DNS resolution:

```bash
echo "127.0.0.1 lserodon.42.fr" | sudo tee -a /etc/hosts
```

### 4. Ensure the volume directories exist

Docker volumes are mounted to specific host paths. Make sure they exist before launching:

```bash
sudo mkdir -p /home/lserodon/data/wordpress
sudo mkdir -p /home/lserodon/data/mariadb
```

> Adjust the paths if your `docker-compose.yml` uses different bind targets.

---

## Building and Launching the Project

### Project structure

```
inception/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/
        ├── wordpress/
        │   ├── Dockerfile
        │   └── conf/
        └── mariadb/
            ├── Dockerfile
            └── conf/
```

### Makefile targets

| Target | Command | Description |
|---|---|---|
| `make` | `docker compose up --build -d` | Build images and start all containers in detached mode |
| `make down` | `docker compose down` | Stop and remove containers and networks |
| `make clean` | `docker compose down -v` + remove images | Full teardown including volumes and built images |
| `make re` | `make clean && make` | Full rebuild from scratch |

### Manual build (without make)

```bash
cd srcs/
docker compose up --build -d
```

To rebuild a single service (e.g., after modifying a Dockerfile):

```bash
docker compose build wordpress
docker compose up -d --no-deps wordpress
```

---

## Managing Containers and Volumes

### Useful container management commands

```bash
# List all running containers
docker compose ps

# View logs of a service
docker compose logs nginx
docker compose logs wordpress
docker compose logs mariadb

# Follow logs in real time
docker compose logs -f

# Open a shell inside a container
docker compose exec nginx sh
docker compose exec wordpress bash
docker compose exec mariadb bash

# Restart a single service
docker compose restart wordpress
```

### Inspecting Docker resources

```bash
# List all Docker volumes
docker volume ls

# Inspect a specific volume
docker volume inspect srcs_wordpress_data
docker volume inspect srcs_mariadb_data

# List Docker networks
docker network ls

# Inspect the project network
docker network inspect srcs_inception_network
```

### Cleaning up

```bash
# Remove all stopped containers
docker container prune

# Remove unused images
docker image prune

# Remove all unused volumes (⚠️ destructive)
docker volume prune

# Full Docker system cleanup (⚠️ removes everything unused)
docker system prune -a --volumes
```

---

## Data Storage and Persistence

### Where is the data stored?

The project uses **Docker volumes** to persist data across container restarts. The volumes are declared in `docker-compose.yml` and mounted to specific paths on the host machine:

| Volume name | Container path | Host path | Content |
|---|---|---|---|
| `wordpress_data` | `/var/www/html` | `/home/lserodon/data/wordpress` | WordPress core files, themes, plugins, uploads |
| `mariadb_data` | `/var/lib/mysql` | `/home/lserodon/data/mariadb` | MariaDB database files |

### How does persistence work?

- When a container is **stopped or restarted**, the data in the volumes is preserved.
- When `make down` is run, containers are removed but **volumes are kept** — data persists.
- When `make clean` is run, volumes are explicitly removed — **all data is lost**.

### Inspecting volume data directly

Since volumes are bind-mounted to the host, you can inspect the data directly:

```bash
ls /home/lserodon/data/wordpress
ls /home/lserodon/data/mariadb
```

> Modifying these files directly on the host while containers are running may cause inconsistencies. Prefer using `docker compose exec` to interact with data inside containers.

---

## TLS Certificate

NGINX uses a **self-signed TLS certificate** generated at build time (or at container startup). The certificate is stored inside the NGINX container and is not persisted on the host.

To regenerate it, simply rebuild the NGINX container:

```bash
docker compose build nginx
docker compose up -d --no-deps nginx
```

The certificate enforces **TLSv1.2 and TLSv1.3** only, as required by the project specification.