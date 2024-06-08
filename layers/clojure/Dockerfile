# syntax=docker/dockerfile:1.7-labs
# clojure layer

# ------------------------------------------------------------------------------
FROM ubuntu:22.04 AS clojure-layer
# ------------------------------------------------------------------------------

# clojure
COPY --from=clojure-builder / /build/
ADD tools.sh /usr/local/bin/tools.sh
RUN tools.sh --install-runtime-deps
RUN tools.sh --copy-build-artifacts
RUN rm -rf /build

# jdk
COPY --from=jdk-builder / /build/
ADD jdk-tools.sh /usr/local/bin/jdk-tools.sh
RUN jdk-tools.sh --install-runtime-deps
RUN jdk-tools.sh --copy-build-artifacts
RUN rm -rf /build
