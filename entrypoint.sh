#!/bin/sh

sudo dockerd &

while ! docker info >/dev/null 2>&1; do
  sleep 1
done

code-server --bind-addr 0.0.0.0:8080 --auth none /home/coder