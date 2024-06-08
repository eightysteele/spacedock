# syntax=docker/dockerfile:1.7-labs

# gh: https://github.com/cli/cli

#------------------------------------------------------------------------------
FROM ubuntu:22.04 AS gh-builder

ADD tools.sh /usr/local/bin/tools.sh
RUN tools.sh --install-build-deps
RUN tools.sh --build

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS gh-runtime

COPY --from=gh-builder / /build/
ADD tools.sh /usr/local/bin/tools.sh
RUN tools.sh --install-runtime-deps
RUN tools.sh --copy-build-artifacts
RUN rm -rf /build
