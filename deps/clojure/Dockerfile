# syntax=docker/dockerfile:1.7-labs
# clojure: https://clojure.org/guides/install_clojure#_linux_instructions

# ------------------------------------------------------------------------------
FROM ubuntu:22.04 AS clojure-builder

COPY deps/clojure/tools.sh /usr/local/bin/clojure-tools.sh
RUN bash -x <<"EOF"
clojure-tools.sh --install-build-deps
clojure-tools.sh --build
EOF

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS clojure-runtime

COPY --from=jdk-builder / /jdk-build/
COPY deps/jdk/tools.sh /usr/local/bin/jdk-tools.sh
RUN bash -x <<"EOF"
jdk-tools.sh --install-runtime-deps
jdk-tools.sh --copy-build-artifacts
rm -rf /jdk-build
EOF

COPY --from=clojure-builder / /clojure-build/
COPY deps/clojure/tools.sh /usr/local/bin/clojure-tools.sh
RUN bash -x <<"EOF"
clojure-tools.sh --install-runtime-deps
clojure-tools.sh --copy-build-artifacts
rm -rf /clojure-build
EOF
