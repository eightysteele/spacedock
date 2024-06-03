# syntax=docker/dockerfile:1.7-labs

# Builds hadolint.
#
#  - $CABAL_DIR/bin/hadolint
#
# https://github.com/hadolint/hadolint

ARG CABAL_DIR
ARG XDG_HOME
ARG XDG_BIN_HOME=${XDG_HOME}/.local/bin

################################################################################
FROM shellcheck AS hadolint
################################################################################

ARG CABAL_DIR
ARG XDG_BIN_HOME

#-------------------------------------------------------------------------------
# build deps
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
# build hadolint
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF"
set -eu
export PATH=${XDG_BIN_HOME}:$PATH
git clone https://github.com/hadolint/hadolint
pushd hadolint
mv cabal.project.freeze cabal.project.freeze.backup
cabal update
cabal configure
cabal update
cabal build
cabal install
popd
rm -rf hadolint
EOF
