# syntax=docker/dockerfile:1.7-labs

# go https://github.com/golang/go

ARG GO_VERSION
ARG GOROOT

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS go-builder

ARG GO_VERSION
ARG GOROOT

COPY deps/go/tools.sh /usr/local/bin/go-tools.sh
RUN bash -x <<"EOF"
go-tools.sh --install-build-deps
go-tools.sh --build
EOF

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS go-runtime

COPY --from=go-builder / /go-build/
COPY deps/go/tools.sh /usr/local/bin/go-tools.sh
RUN bash -x <<"EOF"
go-tools.sh --install-runtime-deps
go-tools.sh --copy-build-artifacts
rm -rf /go-build
EOF
