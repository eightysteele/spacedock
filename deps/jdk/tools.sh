#!/usr/bin/env bash

install-build-deps() {
	apt-get update

	apt-get install -y --no-install-recommends \
		ca-certificates \
		apt-transport-https \
		wget \
		gpg \
		gpg-agent \
		libxtst6 \
		apt-rdepends

	apt-get clean
	apt-get autoremove -y
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*

	CODENAME=$(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release)

	wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public |
		gpg --dearmor -o /usr/share/keyrings/adoptium-archive-keyring.gpg

	echo "deb [signed-by=/usr/share/keyrings/adoptium-archive-keyring.gpg] \
https://packages.adoptium.net/artifactory/deb $CODENAME main" |
		tee /etc/apt/sources.list.d/adoptium.list
}

build() {
	apt-get update

	apt-get install -y "temurin-${JDK_VERSION}-jdk"

	apt-get clean
	apt-get autoremove -y
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
}

install-runtime-deps() {
	apt update

	apt install -y --no-install-recommends \
		ca-certificates \
		java-common \
		libasound2 \
		libc6 \
		libx11-6 \
		libfontconfig1 \
		libfreetype6 \
		libxext6 \
		libxi6 \
		libxrender1 \
		libxtst6 \
		zlib1g \
		fonts-dejavu-core \
		fonts-dejavu-extra \
		rsync

	apt-get clean
	apt-get autoremove -y
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
}

copy-build-artifacts() {
	cp -av \
		/jdk-build/usr/lib/jvm \
		/usr/lib/

	cp -dv \
		/jdk-build/etc/alternatives/java* \
		/etc/alternatives/

	cp -dv \
		/jdk-build/etc/alternatives/jar* \
		/etc/alternatives/

	cp -av \
		/jdk-build/etc/ssl/certs/adoptium \
		/etc/ssl/certs/

	cp -dv \
		/jdk-build/usr/bin/java* \
		/usr/bin/

	cp -dv \
		/jdk-build/usr/bin/jar* \
		/usr/bin/
}

usage() {
	echo "Usage: $0 [--install-build-deps|--build|--install-runtime-deps|--copy-build-artifacts]"
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
	--install-runtime-deps)
		install-runtime-deps
		shift 1
		;;
	--copy-build-artifacts)
		copy-build-artifacts
		shift 1
		;;
	-h | --help)
		usage 1
		;;
	--)
		shift
		break
		;;
	*)
		echo "unknown option: $1"
		usage 1
		;;
	esac
done
