FROM codercom/code-server:4.103.1-ubuntu

USER root

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
        nodejs \
        npm && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo \"${UBUNTU_CODENAME:-$VERSION_CODENAME}\") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    groupadd -f docker && usermod -aG docker coder && newgrp docker && \
    npm install -g @devcontainers/cli && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER coder

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# RUN apt-get update && apt-get install -y --no-install-recommends jq && \
#     rm -rf /var/lib/apt/lists/*
# RUN jq '.extensionsGallery = {"serviceUrl":"https://marketplace.visualstudio.com/_apis/public/gallery","itemUrl":"https://marketplace.visualstudio.com/items","cacheUrl":"https://vscode.blob.core.windows.net/gallery/index"}' \
#   /usr/lib/code-server/lib/vscode/product.json > /tmp/product.json && \
#   mv /tmp/product.json /usr/lib/code-server/lib/vscode/product.json
# RUN code-server --install-extension ms-vscode-remote.remote-containers

# CONTAINER_ID=$(docker run --privileged --rm -d -p 127.0.0.1:8080:8080 vscode-dind)