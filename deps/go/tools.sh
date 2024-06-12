#!/usr/bin/env bash

set -eu

install-build-deps() {
	apt-get update

	apt-get install -y --no-install-recommends \
		ca-certificates \
		build-essential \
		wget

	apt-get clean
	apt-get autoremove -y
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
}

build() {
	f=go${GO_VERSION}.linux-amd64.tar.gz
	wget https://golang.org/dl/$f
	d=$(dirname "${GOROOT}")
	tar -C $d -xzf $f
	rm $f
}

install-runtime-deps() {
	true
}

copy-build-artifacts() {
	cp -av \
		/go-build/usr/local/go \
		/usr/local/
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
