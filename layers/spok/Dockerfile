# syntax=docker/dockerfile:1.7-labs
# spok layer

ARG EMACS_VERSION

# ------------------------------------------------------------------------------
FROM clojure-layer AS spok-layer
# ------------------------------------------------------------------------------

# emacs
ARG EMACS_VERSION
COPY --from=emacs-builder / /build/
COPY deps/emacs/tools.sh /usr/local/bin/emacs-tools.sh
RUN bash -x <<"EOF"
emacs-tools.sh --install-runtime-deps
emacs-tools.sh --copy-build-artifacts
rm -rf /build
EOF

# gh
COPY --from=gh-builder / /build/
COPY deps/gh/tools.sh /usr/local/bin/gh-tools.sh
RUN bash -x <<"EOF"
gh-tools.sh --install-runtime-deps
gh-tools.sh --copy-build-artifacts
rm -rf /build
EOF

# brave
COPY --from=brave-builder / /build/
COPY deps/brave/tools.sh /usr/local/bin/brave-tools.sh
RUN bash -x <<"EOF"
brave-tools.sh --install-runtime-deps
brave-tools.sh --copy-build-artifacts
rm -rf /build
EOF
