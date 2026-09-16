# syntax=docker/dockerfile:1
FROM debian:bookworm-slim

LABEL maintainer="zyekhabdul <zyekhabdulqadirjailani@gmail.com>"
LABEL description="Sovereign AI Developer & Agent Runtime Sandbox"

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Install system dependencies & dev tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ripgrep \
    jq \
    curl \
    ca-certificates \
    openssh-client \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    tar \
    gzip \
    procps \
    nano \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create developer user (configurable via build arg)
ARG DEV_USER=developer
ARG DEV_UID=1000

RUN useradd -m -s /bin/bash -u ${DEV_UID} ${DEV_USER} 2>/dev/null || useradd -m -s /bin/bash ${DEV_USER} && \
    echo "${DEV_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${DEV_USER}
WORKDIR /home/${DEV_USER}

# Configure global npm prefix
RUN mkdir -p /home/${DEV_USER}/.npm-global /home/${DEV_USER}/.local/bin /home/${DEV_USER}/Projects
ENV PATH="/home/${DEV_USER}/.local/bin:/home/${DEV_USER}/.npm-global/bin:${PATH}"
RUN npm config set prefix "/home/${DEV_USER}/.npm-global"

# Install universal AI & dev CLI packages
RUN npm install -g @modelcontextprotocol/server-filesystem @modelcontextprotocol/server-postgres @amonstack/gitea-mcp || true

COPY --chown=${DEV_USER}:${DEV_USER} . /home/${DEV_USER}/Projects/sovereign-agent-os

# Auto-run bootstrap within container
RUN cd /home/${DEV_USER}/Projects/sovereign-agent-os && bash scripts/bootstrap.sh --no-pkg

CMD ["/bin/bash"]
