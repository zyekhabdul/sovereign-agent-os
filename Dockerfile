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

# Create developer user
RUN useradd -m -s /bin/bash fuckadmin && \
    echo "fuckadmin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER fuckadmin
WORKDIR /home/fuckadmin

# Configure global npm prefix
RUN mkdir -p /home/fuckadmin/.npm-global /home/fuckadmin/.local/bin /home/fuckadmin/Projects
ENV PATH="/home/fuckadmin/.local/bin:/home/fuckadmin/.npm-global/bin:${PATH}"
RUN npm config set prefix '/home/fuckadmin/.npm-global'

# Install universal AI & dev CLI packages
RUN npm install -g @modelcontextprotocol/server-filesystem @modelcontextprotocol/server-postgres @amonstack/gitea-mcp || true

COPY --chown=fuckadmin:fuckadmin . /home/fuckadmin/Projects/sovereign-agent-os

# Auto-run bootstrap within container
RUN cd /home/fuckadmin/Projects/sovereign-agent-os && bash scripts/bootstrap.sh --no-pkg

CMD ["/bin/bash"]
