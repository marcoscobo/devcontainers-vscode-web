#!/bin/sh
# Start the Docker daemon in the background
sudo dockerd &
# Wait until the Docker daemon is ready
while ! docker info >/dev/null 2>&1; do
  sleep 1
done
# Start code-server with no authentication, binding to port 80
code-server --bind-addr 0.0.0.0:80 --auth none /home/coder