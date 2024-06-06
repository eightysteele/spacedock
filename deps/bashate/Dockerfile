# syntax=docker/dockerfile:1.7-labs

# Builds bashate: https://github.com/openstack/bashate

ARG USERNAME

################################################################################
FROM python AS bashate
################################################################################

ARG USERNAME

USER root

# ------------------------------------------------------------------------------
# build deps
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF"
set -eu
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    git
apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
EOF

# ------------------------------------------------------------------------------
# bashate
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF"
set -eu
git clone https://github.com/openstack/bashate.git
pushd bashate
pip3 install .
popd
rm -rf bashate
echo ""
EOF

USER ${USERNAME}
