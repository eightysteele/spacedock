#!/usr/bin/env bash

gen-dockerfile() {
	local name=$1
	local f=$path/Dockerfile
	echo "generating $f"
	cat <<GEN >$f
# syntax=docker/dockerfile:1.7-labs

# $name

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS ${name}-builder

COPY deps/$name/tools.sh /usr/local/bin/${name}-tools.sh
RUN bash -x <<"EOF"
${name}-tools.sh --install-build-deps
${name}-tools.sh --build
EOF

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS ${name}-runtime

COPY --from=${name}-builder / /build/

COPY deps/$name/tools.sh /usr/local/bin/${name}-tools.sh
RUN bash -x <<"EOF"
${name}-tools.sh --install-runtime-deps
${name}-tools.sh --copy-build-artifacts
rm -rf /build
EOF
GEN
}

gen-env() {
	local name=$1
	local f=$path/.env
	echo "generating $f"
	cat <<GEN >$f
# $name
GEN
}

gen-compose-yml() {
	local name=$1
	local f=$path/compose.yml
	echo "generating $f"
	cat <<GEN >$f
name: $name

include:
  - ../FOO/compose.yml

services:
  $name-builder:
    image: $name-builder:latest
    command: /usr/bin/tail -f /dev/null
    env_file:
      - .env
    build:
      context: ../../
      dockerfile: deps/$name/Dockerfile
      target: $name-builder
      tags:
        - $name-builder:latest
  $name-runtime:
    image: $name-runtime:latest
    command: /usr/bin/tail -f /dev/null
    env_file:
      - .env
    build:
      context: ../../
      dockerfile: deps/$name/Dockerfile
      target: $name-runtime
      tags:
        - $name-runtime:latest
    depends_on:
      $name-builder:
        required: true
        condition: service_started
      FOO-builder:
        required: true
        condition: service_started
GEN
}

gen-tools-sh() {
	local name=$1
	local f=$path/tools.sh
	local script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
	echo "generating $f"
	cp $script_dir/tools-template.sh $f
	chmod +x $f
}

# Main script
if [ -z "$1" ]; then
	echo "usage: $0 <dependency-name>"
	exit 1
fi

path=$1
name=$(basename "$path")

if [[ -d "$path" ]]; then
	echo "$name exists. remove and try again."
	exit 1
fi

mkdir -p deps/$name
gen-dockerfile $name
gen-env $name
gen-compose-yml $name
gen-tools-sh $name

echo "done"
