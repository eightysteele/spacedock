# syntax=docker/dockerfile:1.7-labs

# Builds ${EMACS_VERSION} installed to ${EMACS_DIR}.
# https://www.gnu.org/software/emacs/news/NEWS.29.3
#
# COPY --from=emacs ${EMACS_DIR} ${EMACS_DIR}
#
# Runtime dependencies:
#   ca-certificates
#   libxpm4
#   libpng16-16
#   libjpeg8
#   libtiff5
#   libgif7
#   librsvg2-2
#   libwebp7
#   libgtk-3-0
#   libgccjit0
#   libjansson4
#   libwebkit2gtk-4.0-37
#   libmagickwand-6.q16-6
#   libice6
#   libsm6
#   curl
#   git
#   wget

ARG EMACS_DIR
ARG EMACS_VERSION

################################################################################
FROM xdg AS emacs
################################################################################

ARG EMACS_DIR
ARG EMACS_VERSION

# ------------------------------------------------------------------------------
# install build dependencies
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF"
set -eu
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
apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
EOF

#-------------------------------------------------------------------------------
# build emacs
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
pushd $dir
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
popd
rm -rf *.gz *.sig emacs-${EMACS_VERSION}
EOF
