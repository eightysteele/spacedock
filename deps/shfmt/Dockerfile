# syntax=docker/dockerfile:1.7-labs

# Installs https://github.com/mvdan/sh

ARG GOROOT
ARG GOBIN
ARG USERNAME

################################################################################
FROM go AS shfmt
################################################################################

ARG GOROOT
ARG GOBIN
ARG USERNAME

USER root

#-------------------------------------------------------------------------------
# build dependencies
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF"
set -eu
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    git
apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
EOF

# ------------------------------------------------------------------------------
# shfmt
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF"
set -eu
export PATH=${GOBIN}:$PATH
go install mvdan.cc/sh/v3/cmd/shfmt@latest
EOF

USER ${USERNAME}
