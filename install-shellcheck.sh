#!/usr/bin/env bash

# Installs the Cabal build dependency:
# https://github.com/haskell/ghcup-hs/tree/master/scripts/bootstrap
#
# Depends on:
#   - XDG_BIN_HOME
#   - CABAL_DIR

set -eux

git clone https://github.com/koalaman/shellcheck.git
pushd shellcheck
cabal install ShellCheck
popd
rm -rf shellcheck
rsync -L ${CABAL_DIR}/bin/shellcheck ${XDG_BIN_HOME}/
