#!/usr/bin/env bash

# Installs the Cabal build dependency:
# https://github.com/haskell/ghcup-hs/tree/master/scripts/bootstrap
#
# Depends on:
#   - XDG_BIN_HOME
#   - XDG_CONFIG_HOME
#   - XDG_DATA_HOME
#   - CABAL_DIR
#   - GHCUP_USE_XDG_DIRS
#   - BOOTSTRAP_HASKELL_NONINTERACTIVE
#   - BOOTSTRAP_HASKELL_VERBOSE
#   - BOOTSTRAP_HASKELL_ADJUST_BASHRC

set -eux

mkdir ${CABAL_DIR} || exit 1
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
cabal update
cabal install cabal-install
rm -rf ~/.cache
