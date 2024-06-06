# syntax=docker/dockerfile:1.7-labs

# Installs clojure: https://clojure.org/guides/install_clojure#_linux_instructions

ARG USERNAME

################################################################################
FROM jdk AS clojure
################################################################################

ARG USERNAME

USER root

# install deps
RUN bash -x <<"EOF"
set -eu
apt-get update
apt-get install -y --no-install-recommends \
    curl \
    rlwrap
apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
EOF

# install clojure
RUN bash -x <<"EOF"
set -eu
curl -L -O https://github.com/clojure/brew-install/releases/latest/download/linux-install.sh
chmod +x linux-install.sh
./linux-install.sh
rm linux-install.sh
EOF

USER ${USERNAME}
