# syntax=docker/dockerfile:1.7-labs
# spok layer

ARG EMACS_VERSION

# ------------------------------------------------------------------------------
FROM ubuntu:22.04 AS spok-layer
# ------------------------------------------------------------------------------

# TOOLS

# emacs
ARG EMACS_VERSION
COPY --from=emacs-builder / /emacs-build/
COPY deps/emacs/tools.sh /usr/local/bin/emacs-tools.sh
RUN bash -x <<"EOF"
emacs-tools.sh --install-runtime-deps
emacs-tools.sh --copy-build-artifacts
rm -rf /emacs-build
EOF

# gh
COPY --from=gh-builder / /gh-build/
COPY deps/gh/tools.sh /usr/local/bin/gh-tools.sh
RUN bash -x <<"EOF"
gh-tools.sh --install-runtime-deps
gh-tools.sh --copy-build-artifacts
rm -rf /gh-build
EOF

# brave
COPY --from=brave-builder / /brave-build/
COPY deps/brave/tools.sh /usr/local/bin/brave-tools.sh
RUN bash -x <<"EOF"
brave-tools.sh --install-runtime-deps
brave-tools.sh --copy-build-artifacts
rm -rf /brave-build
EOF

# CLOJURE LAYER

# jdk
COPY --from=jdk-builder / /jdk-build/
COPY deps/jdk/tools.sh /usr/local/bin/jdk-tools.sh
RUN bash -x <<"EOF"
jdk-tools.sh --install-runtime-deps
jdk-tools.sh --copy-build-artifacts
rm -rf /jdk-build
EOF

# go
COPY --from=go-builder / /go-build/
COPY deps/go/tools.sh /usr/local/bin/go-tools.sh
RUN bash -x <<"EOF"
go-tools.sh --install-runtime-deps
go-tools.sh --copy-build-artifacts
rm -rf /go-build
EOF

# clj-kondo
COPY --from=clj-kondo-builder / /clj-kondo-build/
COPY deps/clj-kondo/tools.sh /usr/local/bin/tools.sh
RUN bash -x <<"EOF"
tools.sh --install-runtime-deps
tools.sh --copy-build-artifacts
rm -rf /clj-kondo-build
EOF

# clojure (depends on jdk)
COPY --from=clojure-builder / /clojure-build/
COPY deps/clojure/tools.sh /usr/local/bin/clojure-tools.sh
RUN bash -x <<"EOF"
clojure-tools.sh --install-runtime-deps
clojure-tools.sh --copy-build-artifacts
rm -rf /clojure-build
EOF

# joker (depends on go)
COPY --from=joker-builder / /joker-build/
COPY deps/joker/tools.sh /usr/local/bin/joker-tools.sh
RUN bash -x <<"EOF"
joker-tools.sh --install-runtime-deps
joker-tools.sh --copy-build-artifacts
rm -rf /joker-build
EOF


