# syntax=docker/dockerfile:1.7-labs
# brave https://brave.com/linux

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS brave-builder

ADD tools.sh /usr/local/bin/tools.sh
RUN tools.sh --install-build-deps
RUN tools.sh --build

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS brave-runtime

COPY --from=brave-builder / /brave-build/
ADD tools.sh /usr/local/bin/brave-tools.sh
RUN brave-tools.sh --install-runtime-deps
RUN brave-tools.sh --copy-build-artifacts
RUN rm -rf /brave-build
