# VSCode Web for DevContainers

This project provides a Docker image that combines VSCode Web and Docker-in-Docker (dind) to enable working with DevContainers in a web-based environment. The image is designed to be provisioned multiple times in an orchestrator of choice, allowing scalable and reproducible development environments.

## Project Purpose

The goal of this project is to create a Docker image that facilitates the use of DevContainers in a browser-based IDE. This includes:

- **Web-Based Development**: Access VSCode Web in a browser for a seamless development experience.
- **Docker-in-Docker Support**: Enable containerized workflows within the development environment.
- **DevContainer Compatibility**: Work with DevContainers to ensure consistent and isolated environments.

## Prerequisites

- Docker and Docker Compose installed on your machine.

## Getting Started

1. Clone this repository to your local machine.
   ```bash
   git clone https://github.com/marcoscobo/devcontainers-vscode-web.git
   cd devcontainers-vscode-web
   ```
2. Build the Docker image:
   ```bash
   docker build -t coder-dind .
   ```
3. Start the container using Docker Compose:
   ```bash
   docker compose up -d
   ```
4. Access the VSCode Web IDE in your browser at `http://localhost:81` or `http://localhost:82`
5. Deploy DevContainers enviroment with devcontainers CLI:
   ```bash
   devcontainer up --workspace-folder .
   ```

   In case you want to access one of the deployed containers, you can run `docker exec -it <container_name/id> /bin/bash`

## License

This project is licensed under the terms of the MIT license.
