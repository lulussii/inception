# User Documentation — Inception

This document is intended for end users and administrators who want to use, access, and manage the Inception infrastructure without necessarily understanding the underlying technical implementation.

---

## What Services Are Provided?

The Inception stack exposes the following services:

| Service | Role | Accessible to the user? |
|---|---|---|
| **NGINX** | Reverse proxy — the single entry point of the infrastructure, handles HTTPS | Yes, via `https://lserodon.42.fr` |
| **WordPress** | The website and its administration panel | Yes, via the browser |
| **MariaDB** | Database storing all WordPress content | No (internal only) |

All traffic goes through **NGINX on port 443 (HTTPS)**. MariaDB is not exposed outside the Docker network and is only accessible internally by WordPress.

---

## Starting and Stopping the Project

### Start the project

From the root of the repository, run:

```bash
make
```

This command builds the Docker images (if not already built) and starts all containers in the background.

To verify that all containers are running:

```bash
docker compose ps
```

You should see three containers with status `Up`: `nginx`, `wordpress`, and `mariadb`.

### Stop the project

To stop all running containers without removing them:

```bash
make down
```

To stop the project and remove containers, networks, and volumes (⚠️ this will delete all stored data):

```bash
make clean
```

---

## Accessing the Website and the Administration Panel

### Website (frontend)

Open your browser and go to:

```
https://lserodon.42.fr
```

> ⚠️ Your browser may warn you about a self-signed certificate. This is expected — simply accept the security exception to proceed.

### WordPress Administration Panel

Go to:

```
https://lserodon.42.fr/wp-admin
```

Log in with the **WordPress admin credentials** (see the section below).

---

## Locating and Managing Credentials

All credentials are defined in the `.env` file located at the root of the `srcs/` directory. This file is **not included in the Git repository** for security reasons — it must be created manually during setup.

### Credentials stored in `.env`

| Variable | Description |
|---|---|
| `SQL_DATABASE` | Name of the WordPress database |
| `SQL_USER` | Database user used by WordPress |
| `DOMAIN_NAME` | Name of the domain |
| `WP_ADMIN_USER` | WordPress admin username |
| `WP_ADMIN_PASSWORD` | WordPress admin password |
| `WP_ADMIN_EMAIL` | WordPress admin email |
| `WP_USER` | Secondary WordPress user |
| `WP_USER_EMAIL` | Email for the secondary user |

> 🔒 Never share this file or commit it to version control. Keep it in a secure location.

### Changing credentials

1. Edit the `.env` file with the new values.
2. Rebuild and restart the stack:
   ```bash
   make clean
   make
   ```
   > ⚠️ Changing database credentials after the first launch requires a clean rebuild, as the database was already initialized with the old values.

---

## Checking That the Services Are Running Correctly

### Check container status

```bash
docker compose ps
```

All three containers (`nginx`, `wordpress`, `mariadb`) should show status `Up`.

### Check container logs

To view the logs of a specific service:

```bash
docker compose logs nginx
docker compose logs wordpress
docker compose logs mariadb
```

To follow logs in real time:

```bash
docker compose logs -f
```

### Check the website

Navigate to `https://lserodon.42.fr` in your browser. If the WordPress homepage loads, the stack is working correctly.

### Check the database connection

You can open a shell inside the MariaDB container to verify the database is accessible:

```bash
docker compose exec mariadb mariadb -u wpuser -p wordpress
```

Enter the database user's password when prompted. If you get a MariaDB prompt, the database is running correctly.