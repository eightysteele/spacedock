# syntax=docker/dockerfile:1.7-labs
ARG XDG_HOME
ARG XDG_BIN_HOME
ARG XDG_CONFIG_HOME
ARG XDG_DATA_HOME
ARG XDG_CACHE_HOME

ARG EMACS_DIR
ARG EMACS_VERSION

################################################################################
FROM xdg-build AS base
################################################################################

ARG XDG_HOME
ARG XDG_BIN_HOME
ARG XDG_CONFIG_HOME
ARG XDG_DATA_HOME
ARG XDG_CACHE_HOME

ARG EMACS_DIR
ARG EMACS_VERSION

ENV DEBIAN_FRONTEND=noninteractive
RUN bash -x <<"EOF"
set -eu
rm -f /etc/apt/apt.conf.d/docker-clean
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    wget \
    gnupg \
    git \
    libncurses5-dev \
    libgnutls28-dev \
    libxml2-dev \
    xorg-dev \
    libgtk-3-dev \
    libharfbuzz-dev \
    libxaw7-dev \
    libxpm-dev \
    libpng-dev \
    zlib1g-dev \
    libjpeg-dev \
    libtiff-dev \
    libgif-dev \
    librsvg2-dev \
    libwebp-dev \
    imagemagick \
    libmagickwand-dev \
    libwebkit2gtk-4.0-dev \
    libgccjit-11-dev \
    libjansson-dev
wget https://ftp.gnu.org/gnu/gnu-keyring.gpg
gpg --import gnu-keyring.gpg
EOF

#-------------------------------------------------------------------------------
# Build emacs.
# https://www.gnu.org/software/emacs/news/NEWS.29.3
#-------------------------------------------------------------------------------

RUN bash -x <<"EOF"
set -eu
export TZ=America/Los_Angeles
dir=emacs-${EMACS_VERSION}
tar=${dir}.tar.gz
sig=${dir}.tar.gz.sig
taru=https://ftp.gnu.org/gnu/emacs/$tar
sigu=https://ftp.gnu.org/gnu/emacs/$sig
wget $taru
wget $sigu
if ! gpg --verify $sig $tar; then
    echo "gpg --verify failed"
	  exit 1
fi
tar xf $tar
cd $dir
./configure \
    --prefix=${EMACS_DIR} \
    --with-xwidgets \
    --with-x \
    --with-x-toolkit=gtk3 \
    --with-imagemagick \
    --with-json \
    --with-native-compilation=yes \
    --with-mailutils
make -j$(nproc)
make install
EOF
