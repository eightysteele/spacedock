# syntax=docker/dockerfile:1.7-labs

# Installs python: https://www.python.org.

ARG PYTHON_MAJOR_VERSION
ARG PYTHON_MINOR_VERSION
ARG PYTHON_BUILD_NUMBER
ARG USERNAME

################################################################################
FROM xdg AS python
################################################################################

ARG PYTHON_MAJOR_VERSION
ARG PYTHON_MINOR_VERSION
ARG PYTHON_BUILD_NUMBER
ARG USERNAME

USER root

#-------------------------------------------------------------------------------
# build dependencies
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF"
set -eu
DEBIAN_FRONTEND=noninteractive
export TZ="America/Los_Angeles"
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
apt-get update
apt-get install -y --no-install-recommends \
    tzdata \
    ca-certificates \
    build-essential \
    wget \
    zlib1g-dev \
    postgresql-server-dev-all \
    pkg-config \
    libbz2-dev \
    libgdbm-dev \
    liblzma-dev \
    tk-dev \
    uuid-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libsqlite3-dev \
    libgdbm-dev \
    libreadline-dev
update-ca-certificates
apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
EOF

# ------------------------------------------------------------------------------
# python
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF"
set -eu
v="${PYTHON_MAJOR_VERSION}.${PYTHON_MINOR_VERSION}.${PYTHON_BUILD_NUMBER}"
base="https://www.python.org/ftp/python/$v/"
d="Python-$v"
tarf="$d.tgz"
url="$base$tarf"
wget $url
tar -xf $tarf
pushd $d || exit 1
./configure --enable-optimizations
make
make altinstall
popd
rm -rf $tarf
rm -rf $d
EOF

RUN bash -x <<"EOF"
set -eu
v="${PYTHON_MAJOR_VERSION}.${PYTHON_MINOR_VERSION}"
update-alternatives --install /usr/bin/python3 python3 "/usr/local/bin/python$v" 1
update-alternatives --install /usr/bin/pip3 pip3 "/usr/local/bin/pip$v" 1
update-alternatives --config python3
update-alternatives --config pip3
EOF

USER ${USERNAME}
