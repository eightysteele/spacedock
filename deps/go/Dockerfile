# syntax=docker/dockerfile:1.7-labs

# Installs go: https://github.com/golang/go

ARG GO_VERSION
ARG GOROOT

FROM xdg AS go

ARG GO_VERSION
ARG GOROOT

# install deps
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

# install go
RUN bash -x <<"EOF"
set -eu
f=go${GO_VERSION}.linux-amd64.tar.gz
wget https://golang.org/dl/$f
d=$(dirname "${GOROOT}")
tar -C $d -xzf $f
rm $f
EOF
