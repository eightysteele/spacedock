# syntax=docker/dockerfile:1.7-labs

# Builds https://github.com/rcjsuen/dockerfile-language-server

ARG NVM_DIR
ARG USERNAME

################################################################################
FROM node AS docker-language-server
################################################################################

ARG NVM_DIR
ARG USERNAME

USER root

# ------------------------------------------------------------------------------
# install build dependencies
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF"
set -eu
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    git
apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
EOF

# ------------------------------------------------------------------------------
# build dockerfile-language-server
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF"
set -eu
source ${NVM_DIR}/nvm.sh
git clone https://github.com/rcjsuen/dockerfile-language-server.git
pushd dockerfile-language-server
npm install
npm audit fix
npm run build
npm test
npm install -g dockerfile-language-server-nodejs
popd
rm -rf dockerfile-language-server
EOF

USER ${USERNAME}
