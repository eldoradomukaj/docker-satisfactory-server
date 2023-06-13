# Docker-Satisfactory-Server

This repository contains the necessary setup to run a Satisfactory server using Docker. It includes configuration file handling and script-based setup, allowing you to customize your server's settings.

## Repository Structure

- **.github/workflows**: This directory contains the workflow files for GitHub Actions, if any.
- **Dockerfile**: This is the main file that describes the Docker image for running a Satisfactory server.
- **Engine.ini, Game.ini, Scalability.ini**: These are the configuration files for the Satisfactory game server. They're initially copied into the Docker image and then used by the server.
- **docker-compose.yaml**: This file defines the services, networks, and volumes for the Docker compose.
- **entrypoint.sh**: The shell script that serves as the entrypoint for the Docker container.
- **start_server.sh**: This shell script is used to set up the server. It handles tasks such as updating the game, setting the max players, and managing save files.

## Quick Start

1. Clone this repository.
2. Navigate into the repository's directory.
3. Run `docker-compose up -d`

This command will build the Docker image and start a container using the configuration specified in `docker-compose.yaml`. 

## Environment Variables

The `docker-compose.yaml` file and `start_server.sh` script use a number of environment variables that you can modify as needed:

- **PGID**: Group ID for the server process.
- **PUID**: User ID for the server process.
- **SERVERGAMEPORT**: The port the game server runs on.
- **SERVERQUERYPORT**: The port for server queries.
- **SERVERBEACONPORT**: The port for server beacons.
- **MAXPLAYERS**: Maximum number of players allowed on the server.

## Network Configuration

The following ports are exposed by the container:

- 7777/udp
- 15777/udp
- 15000/udp

These ports should be mapped to the host using the `docker-compose.yaml` or Docker run command.

## Volumes

The configuration directory (`/config`) is a Docker volume and can be mapped to a directory on the host machine for persistence across container restarts and removals. It contains the game files and save files.

## Maintenance and Customization

To modify the game configuration, adjust the `Game.ini`, `Engine.ini`, and `Scalability.ini` files as needed. The `start_server.sh` script checks for these files and will copy them into the container's game configuration directory at startup.

To customize the server's setup process, modify the `start_server.sh` script as needed.

## Note

This project is still in development, so there may be unexpected issues or errors. If you encounter any problems, please create an issue in this repository.
