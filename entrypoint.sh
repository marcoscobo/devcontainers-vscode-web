#!/bin/sh
set -e
# Start Docker in the background
dockerd &
# Wait until Docker is ready
while ! docker info >/dev/null 2>&1; do
  sleep 1
done
# Optional repository cloning
git config --global --add safe.directory /home/coder
if [ -n "${CLONE_REPO:-}" ]; then
  echo "[entrypoint] CLONE_REPO=${CLONE_REPO}"
  mkdir -p /home/coder
  if [ -d /home/coder/.git ]; then
    CURRENT_REMOTE="$(git -C /home/coder remote get-url origin 2>/dev/null || echo '')"
    # If the remote matches the desired repository, leave it intact
    if [ "$CURRENT_REMOTE" = "$CLONE_REPO" ]; then
      echo "[entrypoint] Repository already matches $CLONE_REPO. Leaving it intact."
    else
      # If the remote does not match, clean the directory and clone the new repository
      rm -rf /home/coder/* /home/coder/.[!.]* /home/coder/..?* 2>/dev/null || true
      git clone "$CLONE_REPO" /home/coder
    fi
  else
    # If not a Git repository, clean the directory and clone the repository
    rm -rf /home/coder/* /home/coder/.[!.]* /home/coder/..?* 2>/dev/null || true
    git clone "$CLONE_REPO" /home/coder
  fi
else
  # If CLONE_REPO is not defined, skip cloning
  echo "[entrypoint] CLONE_REPO not defined. Starting without cloning."
fi
# Start code-server
exec code-server --bind-addr 0.0.0.0:80 --auth none /home/coder