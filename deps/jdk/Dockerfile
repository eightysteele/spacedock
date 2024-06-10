# syntax=docker/dockerfile:1.7-labs

# jdk: https://adoptium.net/installation/linux/

ARG JDK_VERSION

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS jdk-builder

ARG JDK_VERSION

COPY deps/jdk/tools.sh /usr/local/bin/jdk-tools.sh
RUN bash -x <<"EOF"
jdk-tools.sh --install-build-deps
jdk-tools.sh --build
EOF

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS jdk-runtime

ARG JDK_VERSION

COPY --from=jdk-builder / /jdk-build/

COPY deps/jdk/tools.sh /usr/local/bin/jdk-tools.sh
RUN bash -x <<"EOF"
jdk-tools.sh --install-runtime-deps
jdk-tools.sh --copy-build-artifacts
rm -rf /jdk-build
EOF
