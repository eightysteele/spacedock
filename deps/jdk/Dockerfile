# syntax=docker/dockerfile:1.7-labs

# jdk: https://adoptium.net/installation/linux/

ARG JDK_VERSION

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS jdk-builder

ARG JDK_VERSION

ADD tools.sh /usr/local/bin/tools.sh
RUN tools.sh --install-build-deps
RUN tools.sh --build

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS jdk-runtime

ARG JDK_VERSION

COPY --from=jdk-builder / /build/

ADD tools.sh /usr/local/bin/tools.sh
RUN tools.sh --install-runtime-deps
RUN tools.sh --copy-build-artifacts

RUN rm -rf /build
