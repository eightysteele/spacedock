#!/usr/bin/env bash

install-build-deps() {
	apt update

	apt install -y --no-install-recommends \
		ca-certificates \
		curl

	curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

	echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] \
https://brave-browser-apt-release.s3.brave.com/ stable main" |
		tee /etc/apt/sources.list.d/brave-browser-release.list
}

build() {
	apt update

	apt install -y --no-install-recommends brave-browser

	apt-get clean
	apt-get autoremove -y
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*

	update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/brave-browser 200
	update-alternatives --set x-www-browser /usr/bin/brave-browser
}

install-runtime-deps() {
	apt update

	apt install -y --no-install-recommends \
		ca-certificates \
		fonts-liberation \
		libasound2 \
		libatk-bridge2.0-0 \
		libatk1.0-0 \
		libatspi2.0-0 \
		libcairo2 \
		libcups2 \
		libcurl3-gnutls \
		libcurl3-nss \
		libcurl4 \
		libdbus-1-3 \
		libdrm2 \
		libexpat1 \
		libgbm1 \
		libgl1 \
		libglib2.0-0 \
		libgtk-3-0 \
		libgtk-4-1 \
		libnspr4 \
		libnss3 \
		libpango-1.0-0 \
		libu2f-udev \
		libvulkan1 \
		libx11-6 \
		libxcb1 \
		libxcomposite1 \
		libxdamage1 \
		libxext6 \
		libxfixes3 \
		libxkbcommon0 \
		libxrandr2 \
		wget \
		xdg-utils

	apt-get clean
	apt-get autoremove -y
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
}

copy-build-artifacts() {
	cp -dv \
		/brave-build/etc/alternatives/brave-browser \
		/brave-build/etc/alternatives/gnome-www-browser \
		/brave-build/etc/alternatives/open \
		/brave-build/etc/alternatives/x-www-browser \
		/etc/alternatives/

	cp -av \
		/brave-build/opt/brave.com \
		/opt/

	cp -dv \
		/brave-build/usr/bin/brave-browser \
		/brave-build/usr/bin/brave-browser-stable \
		/brave-build/usr/bin/x-www-browser \
		/usr/bin/

	pushd /brave-build/usr/share
	cp --parents -av \
		appdata \
		/usr/share
	popd

	pushd /brave-build/usr/share
	cp --parents -av \
		gnome-control-center \
		/usr/share
	popd

	cp -dv \
		/brave-build/usr/share/menu/brave-browser.menu \
		/usr/share/menu/

	cp -dv \
		/brave-build/var/lib/dpkg/alternatives/brave-browser \
		/brave-build/var/lib/dpkg/alternatives/gnome-www-browser \
		/brave-build/var/lib/dpkg/alternatives/open \
		/brave-build/var/lib/dpkg/alternatives/x-www-browser \
		/var/lib/dpkg/alternatives/
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
