# syntax=docker/dockerfile:1.7-labs
# GitHub CLI: https://github.com/cli/cli

# ------------------------------------------------------------------------------
FROM ubuntu:22.04 AS gh-builder
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF" # install build deps
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

RUN bash -x <<"EOF" # install gh
set -eu

mkdir -p -m 755 /etc/apt/keyrings

wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null

chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] \
    https://cli.github.com/packages stable main" \
    | tee /etc/apt/sources.list.d/github-cli.list > /dev/null

apt update
apt install gh -y --no-install-recommends

apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
EOF

# ------------------------------------------------------------------------------
FROM ubuntu:22.04 AS gh-runtime
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF" # install runtime deps
set -eu

apt update
apt install -y --no-install-recommends \
    git

apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
EOF

COPY --parents --from=gh-builder \
    /usr/bin/gh \
    /usr/share/bash-completion/completions/gh \
    /
