# syntax=docker/dockerfile:1.7-labs
# clojure: https://clojure.org/guides/install_clojure#_linux_instructions

# ------------------------------------------------------------------------------
FROM ubuntu:22.04 AS clojure-builder

COPY deps/clojure/tools.sh /usr/local/bin/tools.sh
RUN bash -x <<"EOF"
tools.sh --install-build-deps
tools.sh --build
EOF

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS clojure-runtime

COPY --from=clojure-builder / /build/
COPY deps/clojure/tools.sh /usr/local/bin/tools.sh
RUN bash -x <<"EOF"
tools.sh --install-runtime-deps
tools.sh --copy-build-artifacts
rm -rf /build
EOF

COPY --from=jdk-builder / /build/
COPY deps/jdk/tools.sh /usr/local/bin/jdk-tools.sh
RUN bash -x <<"EOF"
jdk-tools.sh --install-runtime-deps
jdk-tools.sh --copy-build-artifacts
rm -rf /build
EOF

