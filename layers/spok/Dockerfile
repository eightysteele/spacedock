# syntax=docker/dockerfile:1.7-labs
# spok layer

ARG EMACS_VERSION

# ------------------------------------------------------------------------------
FROM clojure-layer AS spok-layer
# ------------------------------------------------------------------------------

# emacs
ARG EMACS_VERSION
COPY --from=emacs-builder / /build/
ADD tools.sh /usr/local/bin/tools.sh
RUN bash -x <<"EOF"
tools.sh --install-runtime-deps
tools.sh --copy-build-artifacts
rm -rf /build
EOF

# gh
COPY --from=gh-builder / /build/
ADD tools.sh /usr/local/bin/tools.sh
RUN bash -x <<"EOF"
tools.sh --install-runtime-deps
tools.sh --copy-build-artifacts
rm -rf /build
EOF

# brave
COPY --from=brave-builder / /build/
ADD tools.sh /usr/local/bin/tools.sh
RUN bash -x <<"EOF"
tools.sh --install-runtime-deps
tools.sh --copy-build-artifacts
rm -rf /build
EOF
