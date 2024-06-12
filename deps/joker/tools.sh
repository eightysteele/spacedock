#!/usr/bin/env bash

set -eu

install-build-deps() {
	apt-get update

	apt-get install -y --no-install-recommends \
		ca-certificates \
		build-essential \
		git

	apt-get clean
	apt-get autoremove -y
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
}

build() {
	git clone https://github.com/candid82/joker.git
	pushd joker
	./run.sh --version && go install
	popd
	rm -rf joker
}

install-runtime-deps() {
	true
}

copy-build-artifacts() {
	cp -dv \
		/joker-build/usr/local/go/bin/joker \
		/usr/local/go/bin/
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
