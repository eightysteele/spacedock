# syntax=docker/dockerfile:1.7-labs

# joker https://github.com/candid82/joker

ARG PATH
ARG GOBIN
ARG GOROOT

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS joker-builder

ARG PATH
ARG GOBIN
ARG GOROOT

COPY --from=go-builder / /go-build/
COPY deps/go/tools.sh /usr/local/bin/go-tools.sh
RUN bash -x <<"EOF"
go-tools.sh --install-runtime-deps
go-tools.sh --copy-build-artifacts
rm -rf /go-build
EOF

COPY deps/joker/tools.sh /usr/local/bin/joker-tools.sh
RUN bash -x <<"EOF"
joker-tools.sh --install-build-deps
joker-tools.sh --build
rm -rf /go-build
EOF

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS joker-runtime

COPY --from=go-builder / /go-build/
COPY deps/go/tools.sh /usr/local/bin/go-tools.sh
RUN bash -x <<"EOF"
go-tools.sh --install-runtime-deps
go-tools.sh --copy-build-artifacts
rm -rf /go-build
EOF

COPY --from=joker-builder / /joker-build/
COPY deps/joker/tools.sh /usr/local/bin/joker-tools.sh
RUN bash -x <<"EOF"
joker-tools.sh --install-runtime-deps
joker-tools.sh --copy-build-artifacts
rm -rf /joker-build
EOF
