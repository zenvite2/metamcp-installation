# MetaMCP Installation with Docker CLI Support

This setup extends the official MetaMCP installation to include Docker CLI inside the container, allowing MCP servers like desktop-command-mcp to interact with the host's Docker daemon.

## Changes Made

1. Created a custom Dockerfile (Dockerfile.metamcp) that extends the official MetaMCP image and installs Docker CLI
2. Modified docker-compose.yml to:
   - Build from the custom Dockerfile instead of pulling the official image
   - Add the container user to the docker group using `group_add`

## Prerequisites

Ensure that Docker is installed and running on your host machine.

## Usage

1. Make sure the Docker socket is accessible:
   ```bash
   ls -la /var/run/docker.sock
   ```

2. Start the services:
   ```bash
   docker-compose up -d --build
   ```

3. The MetaMCP container now has Docker CLI installed and can access the host's Docker daemon through the mounted socket.

## How It Works

- The Docker socket (`/var/run/docker.sock`) is mounted into the container as a volume
- Docker CLI is installed inside the container during the image build process
- The container user is added to the docker group (using `group_add` in docker-compose.yml) to grant permissions to access the socket
- MCP servers running inside the MetaMCP container (like desktop-command-mcp) can now execute Docker commands that will be handled by the host's Docker daemon

## Verification

You can verify that Docker CLI is working inside the container by running:

```bash
docker exec metamcp docker version
```

This should show both client and server version information.

## Troubleshooting

If you encounter permission issues:
1. Check that the user ID in the container matches your host user ID
2. Ensure your host user is a member of the docker group:
   ```bash
   sudo usermod -aG docker $USER
   ```
   (You'll need to log out and back in for this to take effect)