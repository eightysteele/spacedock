# syntax=docker/dockerfile:1.7-labs
# clojure: https://clojure.org/guides/install_clojure#_linux_instructions

# ------------------------------------------------------------------------------
FROM ubuntu:22.04 AS clojure-builder

ADD tools.sh /usr/local/bin/tools.sh
RUN tools.sh --install-build-deps
RUN tools.sh --build

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS clojure-runtime

COPY --from=clojure-builder / /build/
ADD tools.sh /usr/local/bin/tools.sh
RUN bash -x <<"EOF"
tools.sh --install-runtime-deps
tools.sh --copy-build-artifacts
rm -rf /build
EOF

COPY --from=jdk-builder / /build/
ADD jdk-tools.sh /usr/local/bin/jdk-tools.sh
RUN bash -x <<"EOF"
jdk-tools.sh --install-runtime-deps
jdk-tools.sh --copy-build-artifacts
rm -rf /build
EOF

