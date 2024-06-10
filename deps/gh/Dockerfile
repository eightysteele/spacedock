# syntax=docker/dockerfile:1.7-labs

# gh: https://github.com/cli/cli

#------------------------------------------------------------------------------
FROM ubuntu:22.04 AS gh-builder

ADD tools.sh /usr/local/bin/tools.sh
RUN tools.sh --install-build-deps
RUN tools.sh --build

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS gh-runtime

COPY --from=gh-builder / /gh-build/
ADD tools.sh /usr/local/bin/gh-tools.sh
RUN gh-tools.sh --install-runtime-deps
RUN gh-tools.sh --copy-build-artifacts
RUN rm -rf /gh-build
