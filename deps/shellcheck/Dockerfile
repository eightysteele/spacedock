# syntax=docker/dockerfile:1.7-labs

# Build shellcheck.
#
#  - $CABAL_DIR/bin/shellcheck
#
# https://github.com/koalaman/shellcheck

ARG CABAL_DIR
ARG XDG_HOME
ARG XDG_BIN_HOME

################################################################################
FROM cabal AS shellcheck
################################################################################

ARG CABAL_DIR
ARG XDG_HOME
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
# build shellcheck
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF"
set -eu
export PATH=${XDG_BIN_HOME}:$PATH
git clone https://github.com/koalaman/shellcheck.git
pushd shellcheck
cabal install ShellCheck
popd
rm -rf shellcheck
EOF
