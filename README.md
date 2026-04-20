*This project has been created as part of the 42 curriculum by lserodon.*

# Inception

## Description

Inception is a system administration project. The goal is to broaden knowledge of system administration by using **Docker** to virtualize a small infrastructure composed of different services, all orchestrated with **Docker Compose**.

The infrastructure runs inside a dedicated virtual machine and consists of three interconnected containers:

- **NGINX** — the only entry point to the infrastructure, handling HTTPS (TLSv1.2/1.3) connections on port 443.
- **WordPress** — a PHP-FPM powered WordPress instance (without NGINX), connected to the database.
- **MariaDB** — the database service storing all WordPress data.

Each service runs in its own container, built from a custom `Dockerfile` based on the penultimate stable version of Alpine or Debian. The containers communicate through a dedicated Docker network, and persistent data is stored using Docker volumes.

## Instructions

### Prerequisites

- Docker and Docker Compose installed
- A virtual machine running Linux (Debian/Alpine recommended)
- `make` utility available

### Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/lserodon/inception.git
   cd inception
   ```

2. **Configure environment variables:**

   Create a `.env` file at the root of the project (or inside `srcs/`) with the following variables:
   ```env
   DOMAIN_NAME=lserodon.42.fr

   # MariaDB
   MYSQL_DATABASE=wordpress
   MYSQL_USER=wpuser

   # WordPress
   WP_TITLE=Inception
   WP_ADMIN_USER=admin
   WP_ADMIN_EMAIL=admin@lserodon.42.fr
   WP_USER=user
   WP_USER_EMAIL=user@lserodon.42.fr
   ```

3. **Add the domain to your `/etc/hosts`:**
   ```bash
   echo "127.0.0.1 lserodon.42.fr" | sudo tee -a /etc/hosts
   ```

4. **Build and start the infrastructure:**
   ```bash
   make
   ```
   This will build the Docker images and start all containers via `docker-compose up --build -d`.

5. **Access the site:**

   Open your browser and navigate to: `https://lserodon.42.fr`

## Resources

### Documentation & References

- [Docker official documentation](https://docs.docker.com/)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [WordPress CLI documentation](https://wp-cli.org/)
- [MariaDB documentation](https://mariadb.com/kb/en/documentation/)
- [Alpine Linux packages](https://pkgs.alpinelinux.org/packages)
- [TLS/SSL configuration best practices – Mozilla SSL Config Generator](https://ssl-config.mozilla.org/)
- [Docker volumes vs bind mounts – Docker docs](https://docs.docker.com/storage/)
- [Understanding Docker networking](https://docs.docker.com/network/)

### AI Usage

**Tool used:** Claude (Anthropic)

AI was used during this project for **research and understanding** purposes:

- Clarifying Docker concepts (volumes, networks, multi-stage builds, entrypoints)
- Understanding differences between configuration approaches (e.g., secrets vs environment variables, bridge vs host network)
- Getting explanations of NGINX TLS configuration directives
- Understanding how `wp-cli` works for automated WordPress setup
- Helping interpret error messages during debugging sessions

AI was **not** used to directly write Dockerfiles, configuration files, or scripts — all code was written manually after understanding the underlying concepts.