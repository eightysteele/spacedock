# syntax=docker/dockerfile:1.7-labs
# Emacs: https://www.gnu.org/software/emacs/news/NEWS.29.3

ARG EMACS_VERSION

# ------------------------------------------------------------------------------
FROM ubuntu:22.04 AS emacs-builder
# ------------------------------------------------------------------------------

ARG EMACS_VERSION

RUN bash -x <<"EOF" # install build deps
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

RUN bash -x <<"EOF" # compile and install emacs
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

# ------------------------------------------------------------------------------
FROM ubuntu:22.04 AS emacs-runtime
# ------------------------------------------------------------------------------

ARG EMACS_VERSION

RUN bash -xeu <<"EOF" # install runtime deps
apt update
apt install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    libgccjit0 \
    libgif7 \
    libgtk-3-0 \
    libice6 \
    libjansson4 \
    libjpeg8 \
    libmagickwand-6.q16-6 \
    libpng16-16 \
    librsvg2-2 \
    libsm6 \
    libtiff5 \
    libwebkit2gtk-4.0-37 \
    libwebp7 \
    libxpm4 \
    wget

apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
EOF

ARG PREFIX=/usr/local

COPY --parents --from=emacs-builder \
    ${PREFIX}/bin/emacs* ${PREFIX}/bin/ \
    ${PREFIX}/share/emacs/${EMACS_VERSION} ${PREFIX}/share/emacs/${EMACS_VERSION} \
    ${PREFIX}/libexec/emacs/${EMACS_VERSION} ${PREFIX}/libexec/emacs/${EMACS_VERSION} \
    ${PREFIX}/lib/emacs/${EMACS_VERSION} ${PREFIX}/lib/emacs/${EMACS_VERSION} \
    /

