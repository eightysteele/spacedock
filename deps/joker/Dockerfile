# syntax=docker/dockerfile:1.7-labs

# Installs joker: https://github.com/candid82/joker

ARG GOROOT

FROM go AS joker

ARG GOROOT
ENV GOBIN=${GOROOT}/bin
ENV PATH=${GOBIN}:$PATH

# install deps
RUN bash -x <<"EOF"
set -eu
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    git
apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
EOF

# install joker
RUN bash -x <<"EOF"
set -eu
export GOROOT=${GOROOT}
export GOBIN=${GOBIN}
export PATH=$GOBIN:$PATH
git clone https://github.com/candid82/joker.git
pushd joker
./run.sh --version && go install
popd
rm -rf joker
EOF
