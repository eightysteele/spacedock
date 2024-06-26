# syntax=docker/dockerfile:1.7-labs
# clojure layer

# ------------------------------------------------------------------------------
FROM ubuntu:22.04 AS clojure-layer
# ------------------------------------------------------------------------------

# clojure
COPY --from=clojure-builder / /build/
COPY deps/clojure/tools.sh /usr/local/bin/clojure-tools.sh
RUN bash -x <<"EOF"
clojure-tools.sh --install-runtime-deps
clojure-tools.sh --copy-build-artifacts
rm -rf /build
EOF

# jdk
COPY --from=jdk-builder / /build/
COPY deps/jdk/tools.sh /usr/local/bin/jdk-tools.sh
RUN bash -x <<"EOF"
jdk-tools.sh --install-runtime-deps
jdk-tools.sh --copy-build-artifacts
rm -rf /build
EOF

# clj-kondo
COPY --from=clj-kondo-builder / /build/
COPY deps/clj-kondo/tools.sh /usr/local/bin/tools.sh
RUN bash -x <<"EOF"
tools.sh --install-runtime-deps
tools.sh --copy-build-artifacts
rm -rf /build
EOF

# go
COPY --from=go-builder / /build/
COPY deps/go/tools.sh /usr/local/bin/go-tools.sh
RUN bash -x <<"EOF"
go-tools.sh --install-runtime-deps
go-tools.sh --copy-build-artifacts
rm -rf /build
EOF

