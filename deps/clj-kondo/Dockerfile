# syntax=docker/dockerfile:1.7-labs

# Installs clj-kondo: https://github.com/clj-kondo/clj-kondo

ARG USERNAME

################################################################################
FROM xdg AS clj-kondo
################################################################################

ARG USERNAME

USER root

# install deps
RUN bash -x <<"EOF"
set -eu
rm -f /etc/apt/apt.conf.d/docker-clean
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    curl \
    unzip
apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
EOF

# install clj-kondo
RUN bash -x <<"EOF"
set -eu
curl -sLO https://raw.githubusercontent.com/clj-kondo/clj-kondo/master/script/install-clj-kondo
chmod +x install-clj-kondo
./install-clj-kondo
rm -rf install-clj-kondo
EOF

USER ${USERNAME}
