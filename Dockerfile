FROM codercom/code-server:4.103.1-ubuntu
USER root
# ---------- Required packages ----------
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        openssh-client \
        tini \
        curl \
        ca-certificates \
        tar \
        tzdata \
        gpg \
        gnupg2 \
        dirmngr && \
    rm -rf /var/lib/apt/lists/*
# ---------- Docker ----------
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo \"${UBUNTU_CODENAME:-$VERSION_CODENAME}\") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    groupadd -f docker && usermod -aG docker coder && newgrp docker && \
    rm -rf /var/lib/apt/lists/*
# ---------- Nvm ----------
ARG NODE_VERSION=20
ENV NVM_DIR=/root/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash && \
    bash -lc 'source "$NVM_DIR/nvm.sh" && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    BIN_DIR="$(dirname "$(nvm which default)")" && \
    ln -sf "$BIN_DIR/node" /usr/local/bin/node && \
    ln -sf "$BIN_DIR/npm"  /usr/local/bin/npm && \
    ln -sf "$BIN_DIR/npx"  /usr/local/bin/npx'
# ---------- Dev Containers CLI ----------
RUN npm install -g @devcontainers/cli
# ---------- Entrypoint ----------
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# CONTAINER_ID=$(docker run --privileged --rm -d -p 127.0.0.1:80:80 vscode-dind)
# Inside vscode terminal: devcontainer up --workspace-folder .
# Inside vscode terminal: docker exec -it <container_name/id> /bin/bash