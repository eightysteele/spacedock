# syntax=docker/dockerfile:1.7-labs

# Sets up the XDG filesystem.
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-0.6.html

ARG XDG_HOME
ARG XDG_BIN_HOME=${XDG_HOME}/.local/bin
ARG XDG_CONFIG_HOME=${XDG_HOME}/.config
ARG XDG_DATA_HOME=${XDG_HOME}/.local/share
ARG XDG_CACHE_HOME=${XDG_HOME}/.cache

################################################################################
FROM ubuntu:22.04 AS xdg
################################################################################

ARG XDG_HOME
ARG XDG_BIN_HOME
ARG XDG_CONFIG_HOME
ARG XDG_DATA_HOME
ARG XDG_CACHE_HOME

RUN bash -x <<"EOF"
set -eu
mkdir -p \
    $XDG_HOME \
    $XDG_CONFIG_HOME \
    $XDG_DATA_HOME \
    $XDG_CACHE_HOME \
    $XDG_BIN_HOME
EOF
