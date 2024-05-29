# syntax=docker/dockerfile:1.7-labs

# Installs https://github.com/golang/go in $GOROOT.

ARG GO_VERSION
ARG GOROOT

################################################################################
FROM xdg AS go
################################################################################

ARG GO_VERSION
ARG GOROOT

#-------------------------------------------------------------------------------
# build dependencies
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF"
set -eu
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
grd=$(dirname "$GOROOT")
wget https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz
tar -C "$grd" -xzf go${GO_VERSION}.linux-amd64.tar.gz
rm go${GO_VERSION}.linux-amd64.tar.gz
EOF
