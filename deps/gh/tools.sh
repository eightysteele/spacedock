#!/usr/bin/env bash

install-build-deps() {
	apt-get update

	apt-get install -y --no-install-recommends \
		ca-certificates \
		build-essential \
		wget

	apt-get clean
	apt-get autoremove -y
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*

	mkdir -p -m 755 /etc/apt/keyrings

	wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg |
		tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null

	chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg

	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] \
    https://cli.github.com/packages stable main" |
		tee /etc/apt/sources.list.d/github-cli.list >/dev/null
}

build() {
	apt update

	apt install gh -y --no-install-recommends

	apt-get clean
	apt-get autoremove -y
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
}

install-runtime-deps() {
	apt update

	apt install -y --no-install-recommends \
		git

	apt-get clean
	apt-get autoremove -y
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
}

copy-build-artifacts() {
	cp -dv \
		/build/usr/bin/gh \
		/usr/bin/

	cp -dv \
		/build/usr/share/bash-completion/completions/gh \
		/usr/share/bash-completion/completions/
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
