## continue-server docker image


[Continue](https://continue.dev) brings the power of ChatGPT to VS Code and JetBrains, offering an autopilot for software development. This Docker container makes it easy to deploy and run Continue in a self-contained environment.

## Getting Started with Docker Compose

Follow these steps to get `continue-server` up and running using Docker Compose:

1. **Clone the Repository**
   
   First, clone the `continue-server` repository from GitHub:

   ```bash
   git clone https://github.com/c0ldfront/continue-server.git
   cd continue-server
   ```

2. **Start the Server**

   Use Docker Compose to start the server:

   ```bash
   docker-compose up -d
   ```

   This command will start all the services defined in the `docker-compose.yml` file in detached mode.

3. **Access the Server**

   Once the server is running, you can access the `continue-server` web interface at `http://<your-ip>:65432`.

4. **Stopping the Server**

   To stop the server and remove the containers, use:

   ```bash
   docker-compose down
   ```

5. **Updating the Server**

   To update the server, pull the latest changes from the repository and restart the services:

   ```bash
   git pull
   docker-compose down
   docker-compose pull
   docker-compose up -d
   ```

This method ensures that you're always running the latest version of `continue-server` with minimal manual intervention.


## Application Setup

The continue server integrates with your IDE and offers features like code suggestions, documentation lookup, and more. Access the server at `http://<your-ip>:65432` after deployment.

## Usage

### docker-compose (recommended)

```yaml
---
version: "3.3"
services:
  continuedev:
    image: ghcr.io/c0ldfront/continue-server:latest
    container_name: continuedev
    restart: always
    environment:
      - MEILISEARCH_URL=http://meilisearch:7700
      - CONTINUE_PORT=65432
      - CONTINUE_HOST=0.0.0.0
    volumes:
      - continue_data:/home/continue/.continue
    ports:
      - 65432:65432
    depends_on:
      - meilisearch

  meilisearch:
    image: getmeili/meilisearch:v1.4
    container_name: meilisearch
    restart: always
    volumes:
      - meilisearch_data:/meili_data
    ports:
      - 7700:7700

volumes:
  continue_data: {}
  meilisearch_data: {}
```

### docker cli

```bash
docker run -d \
  --name=continuedev \
  -e MEILISEARCH_URL=http://meilisearch:7700 \
  -e CONTINUE_PORT=65432 \
  -e CONTINUE_HOST=0.0.0.0 \
  -p 65432:65432 \
  -v continue_data:/home/continue/.continue \
  --restart unless-stopped \
  ghcr.io/c0ldfront/continue-server:latest
```

## Parameters

| Parameter | Function |
| :----: | --- |
| `-p 65432` | Continue server web GUI |
| `-e MEILISEARCH_URL=http://meilisearch:7700` | URL for Meilisearch service |
| `-e CONTINUE_PORT=65432` | Port for the Continue server |
| `-e CONTINUE_HOST=0.0.0.0` | Host for the Continue server |
| `-v continue_data:/home/continue/.continue` | Persist data |

## Updating Info

### Via Docker Compose

* Update images:

    ```bash
    docker-compose pull
    docker-compose up -d
    ```

### Via Docker Run

* Update the image:

    ```bash
    docker pull ghcr.io/c0ldfront/continue-server:latest
    ```

* Stop the running container:

    ```bash
    docker stop continuedev
    ```

* Delete the container:

    ```bash
    docker rm continuedev
    ```

* Recreate a new container with the same docker run parameters.
