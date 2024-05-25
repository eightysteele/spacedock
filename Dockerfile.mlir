# syntax=docker/dockerfile:1.7-labs
ARG XDG_HOME
ARG XDG_BIN_HOME
ARG XDG_CONFIG_HOME
ARG XDG_DATA_HOME
ARG XDG_CACHE_HOME

ARG NVM_DIR
ARG EMACS_DIR

################################################################################
FROM emacs-build AS emacs
FROM spacedock-docker AS docker-layer
FROM ghcr.io/nvidia/jax:t5x-2024-05-09 as base
################################################################################

ARG XDG_HOME
ARG XDG_BIN_HOME
ARG XDG_CONFIG_HOME
ARG XDG_DATA_HOME
ARG XDG_CACHE_HOME

ARG NVM_DIR
ARG EMACS_DIR

RUN bash -x <<"EOF"
set -eu
apt-get update
apt-get install -y \
    build-essential \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    libxpm4 \
    libpng16-16 \
    libjpeg8 \
    libtiff5 \
    libgif7 \
    librsvg2-2 \
    libwebp7 \
    libgtk-3-0 \
    libgccjit0 \
    libjansson4 \
    libwebkit2gtk-4.0-37 \
    libmagickwand-6.q16-6 \
    libice6 \
    libsm6 \
    fonts-firacode \
    curl \
    git \
    wget \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update && apt-get install -y docker-ce-cli
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EOF

COPY --from=emacs ${EMACS_DIR} ${EMACS_DIR}
COPY --from=docker-layer ${NVM_DIR} ${NVM_DIR}
COPY --from=docker-layer ${XDG_BIN_HOME}/hadolint ${XDG_BIN_HOME}/hadolint

