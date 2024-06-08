#!/usr/bin/env bash

# emacs

set -e

install-build-deps() {
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
}

build() {
	export TZ=America/Los_Angeles

	dir=emacs-${EMACS_VERSION}
	tar=${dir}.tar.gz
	sig=${dir}.tar.gz.sig
	taru=https://ftp.gnu.org/gnu/emacs/$tar
	sigu=https://ftp.gnu.org/gnu/emacs/$sig

	wget "$taru"
	wget "$sigu"

	if ! gpg --verify "$sig" "$tar"; then
		echo "gpg --verify failed"
		exit 1
	fi

	tar xf "$tar"

	pushd "$dir"
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

	rm -rf "*.gz" "*.sig" emacs-"${EMACS_VERSION}"
}

install-runtime-deps() {
	apt update

	apt install -y --no-install-recommends \
		at-spi2-core \
		ca-certificates \
		curl \
		git \
		libcanberra-gtk-module \
		libcanberra-gtk3-module \
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
}

copy-build-artifacts() {
	cp -dv \
		/build/usr/local/bin/emacs* \
		/build/usr/local/bin/ctags \
		/build/usr/local/bin/ebrowse \
		/build/usr/local/bin/etags \
		/usr/local/bin/

	pushd /build/usr/local
	cp --parents -av \
		libexec \
		/usr/local
	popd

	pushd /build/usr/local/lib
	cp --parents -av \
		emacs \
		/usr/local/lib
	popd

	cp -av \
		/build/usr/local/share/emacs \
		/usr/local/share/
}

usage() {
	echo ": $0 [--install-build-deps|--build|--install-runtime-deps|--copy-build-artifacts]"
	exit "$1"
}

args=$(getopt -o h --long install-build-deps,build,install-runtime-deps,copy-build-artifacts,help -- "$@")
if [[ $? -ne 0 ]]; then
	exit 1
fi

eval set -- "$args"
while true; do
	case "$1" in
	--install-build-deps)
		install-build-deps
		shift 1
		;;
	--build)
		build
		shift 1
		;;
	--copy-build-artifacts)
		copy-build-artifacts
		shift 1
		;;
	--install-runtime-deps)
		install-runtime-deps
		shift 1
		;;
	-h | --help)
		usage 1
		;;
	--)
		shift 1
		break
		;;
	*)
		echo "unknown option: $1"
		usage 1
		;;
	esac
done
