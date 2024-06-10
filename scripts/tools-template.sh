#!/usr/bin/env bash

set -eu

install-build-deps() {
	true
}

build() {
	true
}

install-runtime-deps() {
	true
}

copy-build-artifacts() {
	true
	# copy entire directory recursively
	# cp -av \
	#   /build/usr/lib/jvm \
	#   /usr/lib/

	# cp symlinks with --no-dereference
	# cp -dv \
	#    /build/etc/alternatives/java* \
	#    /etc/alternatives/
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
