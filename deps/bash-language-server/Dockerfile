# syntax=docker/dockerfile:1.7-labs

# Installs https://github.com/bash-lsp/bash-language-server

ARG NVM_DIR
ARG USERNAME

################################################################################
FROM xdg AS bash-language-server
################################################################################

ARG NVM_DIR
ARG USERNAME

USER root

COPY --from=node / /
COPY --from=shellcheck / /
COPY --from=bashate / /

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
# bash-language-server
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF"
set -eu
source ${NVM_DIR}/nvm.sh
npm i -g bash-language-server
EOF

USER ${USERNAME}
