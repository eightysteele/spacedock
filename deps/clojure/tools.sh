#!/usr/bin/env bash

install-build-deps() {
	apt-get update

	apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		rlwrap

	apt-get clean
	apt-get autoremove -y
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
}

build() {
	curl -L -O https://github.com/clojure/brew-install/releases/latest/download/linux-install.sh
	chmod +x linux-install.sh
	./linux-install.sh
	rm linux-install.sh
}

install-runtime-deps() {
	apt-get update

	apt-get install -y --no-install-recommends \
		rlwrap

	apt-get clean
	apt-get autoremove -y
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
}

copy-build-artifacts() {
	cp -av \
		/clojure-build/usr/local/lib/clojure \
		/usr/local/lib/

	cp -v \
		/clojure-build/usr/local/bin/clojure \
		/build/usr/local/bin/clj \
		/usr/local/bin/

	cp -av \
		/clojure-build/usr/local/share/man/man1 \
		/usr/local/share/man/
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
		shift
		break
		;;
	*)
		echo "unknown option: $1"
		usage 1
		;;
	esac
done
