# syntax=docker/dockerfile:1.7-labs

# Installs https://github.com/golang/go in $GO_DIR/goroot. 

ARG GO_VERSION
ARG GO_DIR
ARG GOPATH

################################################################################
FROM xdg AS go
################################################################################

ARG GO_VERSION
ARG GO_DIR
ARG GOPATH

#-------------------------------------------------------------------------------
# build dependencies
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF"
set -eu
rm -f /etc/apt/apt.conf.d/docker-clean
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    wget
apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
EOF

# ------------------------------------------------------------------------------
# go
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
