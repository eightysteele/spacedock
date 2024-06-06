# syntax=docker/dockerfile:1.7-labs

# Sets up the XDG filesystem.
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-0.6.html

ARG XDG_HOME
ARG XDG_BIN_HOME
ARG XDG_CONFIG_HOME
ARG XDG_DATA_HOME
ARG XDG_CACHE_HOME
ARG USERNAME

################################################################################
FROM ubuntu:22.04 AS xdg
################################################################################

ARG XDG_HOME
ARG XDG_BIN_HOME
ARG XDG_CONFIG_HOME
ARG XDG_DATA_HOME
ARG XDG_CACHE_HOME
ARG USERNAME

# install deps
RUN bash -x <<"EOF"
set -eu
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    sudo
apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
EOF

RUN bash -x <<"EOF"
set -eu
mkdir -p \
    $XDG_HOME \
    $XDG_CONFIG_HOME \
    $XDG_DATA_HOME \
    $XDG_CACHE_HOME \
    $XDG_BIN_HOME
EOF

RUN bash -x <<"EOF"
set -eu
useradd --create-home ${USERNAME}
usermod -aG sudo ${USERNAME}
echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

#useradd --create-home ${USERNAME}
#useradd -m -s /bin/bash ${USERNAME}
#usermod -aG sudo ${USERNAME}
#echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
EOF

USER ${USERNAME}
