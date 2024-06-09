# syntax=docker/dockerfile:1.7-labs

# jdk: https://adoptium.net/installation/linux/

ARG JDK_VERSION

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS jdk-builder

ARG JDK_VERSION

COPY deps/jdk/tools.sh /usr/local/bin/tools.sh
RUN bash -x <<"EOF"
tools.sh --install-build-deps
tools.sh --build
EOF

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS jdk-runtime

ARG JDK_VERSION

COPY --from=jdk-builder / /build/

COPY deps/jdk/tools.sh /usr/local/bin/tools.sh
RUN bash -x <<"EOF"
tools.sh --install-runtime-deps
tools.sh --copy-build-artifacts
rm -rf /build
EOF
