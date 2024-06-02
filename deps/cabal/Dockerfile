# syntax=docker/dockerfile:1.7-labs

# Builds cabal with ghcup.
#
#   - $XDG_CONFIG_HOME/ghcup
#   - $XDG_BIN_HOME/ghcup
#   - $XDG_DATA_HOME/ghcup
#   - $XDG_CONFIG_HOME/.cabal
#   - $CABAL_DIR/bin/cabal
#
# https://github.com/haskell/ghcup-hs/tree/master/scripts/bootstrap

ARG CABAL_DIR
ARG XDG_HOME
ARG XDG_CONFIG_HOME=${XDG_HOME}/.config
ARG XDG_BIN_HOME=${XDG_HOME}/.local/bin
ARG XDG_DATA_HOME=${XDG_HOME}/.local/share

################################################################################
FROM xdg AS cabal
################################################################################

ARG CABAL_DIR
ARG XDG_HOME
ARG XDG_CONFIG_HOME
ARG XDG_BIN_HOME
ARG XDG_DATA_HOME

#-------------------------------------------------------------------------------
# build deps
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF"
set -eu
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    libgmp-dev \
    zlib1g-dev \
    git \
    curl
apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
EOF

# ------------------------------------------------------------------------------
# build cabal
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF"
set -eu
export BOOTSTRAP_HASKELL_NONINTERACTIVE=1
export GHCUP_USE_XDG_DIRS=1
export BOOTSTRAP_HASKELL_VERBOSE=1
export BOOTSTRAP_HASKELL_ADJUST_BASHRC=1
export PATH=${XDG_BIN_HOME}:$PATH
mkdir ${CABAL_DIR} || exit 1
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
cabal update
cabal install cabal-install
rm -rf ~/.cache
EOF

