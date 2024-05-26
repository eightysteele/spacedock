# syntax=docker/dockerfile:1.7-labs
ARG XDG_HOME
ARG XDG_BIN_HOME
ARG XDG_CONFIG_HOME
ARG XDG_DATA_HOME
ARG XDG_CACHE_HOME

ARG GO_DIR
ARG GO_VERSION
ARG GOROOT
ARG GOPATH
ARG GOBIN

################################################################################
FROM build-xdg AS base
################################################################################

ARG XDG_HOME
ARG XDG_BIN_HOME
ARG XDG_CONFIG_HOME
ARG XDG_DATA_HOME
ARG XDG_CACHE_HOME

ARG GO_DIR
ARG GO_VERSION
ARG GOROOT
ARG GOPATH
ARG GOBIN

ENV PATH=${XDG_BIN_HOME}:$PATH

#-------------------------------------------------------------------------------
# Install dependencies.
# ------------------------------------------------------------------------------

ENV DEBIAN_FRONTEND=noninteractive
RUN bash -x <<"EOF"
set -eu
rm -f /etc/apt/apt.conf.d/docker-clean
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    wget
EOF

# ------------------------------------------------------------------------------
# Install Go.
# https://github.com/hadolint/hadolint
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF"
set -eu
mkdir ${GO_DIR} && cd ${GO_DIR} || exit 1
mkdir ${GOPATH} || exit 1
mkdir goroot || exit 1
wget https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz
tar -C goroot -xzf go${GO_VERSION}.linux-amd64.tar.gz
rm go${GO_VERSION}.linux-amd64.tar.gz
EOF
