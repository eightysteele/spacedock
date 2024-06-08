# syntax=docker/dockerfile:1.7-labs
# emacs: https://www.gnu.org/software/emacs/news/NEWS.29.3

ARG EMACS_VERSION

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS emacs-builder

ARG EMACS_VERSION

ADD tools.sh /usr/local/bin/tools.sh
RUN tools.sh --install-build-deps
RUN tools.sh --build

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS emacs-runtime

ARG EMACS_VERSION

COPY --from=emacs-builder / /build/
ADD tools.sh /usr/local/bin/tools.sh
RUN tools.sh --install-runtime-deps
RUN tools.sh --copy-build-artifacts
RUN rm -rf /build
