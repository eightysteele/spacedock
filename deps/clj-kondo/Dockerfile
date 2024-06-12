# syntax=docker/dockerfile:1.7-labs
# clj-kondo: https://github.com/clj-kondo/clj-kondo

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS clj-kondo-builder

COPY deps/clj-kondo/tools.sh /usr/local/bin/clj-kondo-tools.sh
RUN bash -x <<"EOF"
clj-kondo-tools.sh --install-build-deps
clj-kondo-tools.sh --build
EOF

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS clj-kondo-runtime

COPY --from=clj-kondo-builder / /clj-kondo-build/
COPY deps/clj-kondo/tools.sh /usr/local/bin/clj-kondo-tools.sh
RUN bash -x <<"EOF"
clj-kondo-tools.sh --install-runtime-deps
clj-kondo-tools.sh --copy-build-artifacts
rm -rf /clj-kondo-build
EOF
