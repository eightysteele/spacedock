#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TAG=emacs-docker:dev
COMMAND=""
COMMAND_PATH=""

get_service() {
	local service=""
	local type=$(dirname "$COMMAND_PATH")
	local service=$(basename "$COMMAND_PATH")
	if [ "$type" == "layers" ]; then
		service="$service-layer"
	fi
	echo "$service"
}

get_env_files() {
	local env_files=""
	local type=$(dirname "$COMMAND_PATH")
	if [ "$type" == "layers" ]; then
		env_files="--env-file ../../deps/default.env --env-file override.env"
	else
		env_files="--env-file ../default.env --env-file override.env"
	fi
	echo "$env_files"
}

stop_containers() {
	echo "stoping containers..."
	if docker stop $(docker ps -q) 2>/dev/null; then
		docker rm $(docker ps -a -q)
		docker container prune -f
	fi
}

get_include_env_paths() {
	local yaml_file=$1
	local include_paths=()

	while IFS= read -r line; do
		if [[ $line =~ ^[[:space:]]*-[[:space:]]*(.*) ]]; then
			dir_path=$(dirname "${BASH_REMATCH[1]}")
			include_paths+=("$dir_path/.env")
		fi
	done < <(awk '/^include:/,/^$/' "$yaml_file")

	local result=""
	for path in "${include_paths[@]}"; do
		result+="--env-file $path "
	done
	echo "$result"
}

compose_build() {
	local service=$(get_service)
	pushd "$SCRIPT_DIR/$COMMAND_PATH"
	local cmd="docker compose --env-file ../default.env --env-file override.env -p $service build"
	printf "\n%s\n\n" "$cmd"
	$cmd
	popd
}

compose_start() {
	local service=$(get_service)
	pushd "$SCRIPT_DIR/$COMMAND_PATH"
	local cmd="docker compose --env-file ../default.env --env-file override.env -p $service start"
	printf "\n%s\n\n" "$cmd"
	$cmd
	popd
}

compose_up() {
	local service=$(get_service)
	local env_files=$(get_env_files)
	compose_config
	pushd "$SCRIPT_DIR/$COMMAND_PATH"
	local cmd="docker compose $env_files -p $service up -d --build --remove-orphans"
	printf "\n%s\n\n" "$cmd"
	$cmd
	popd
}

compose_stop() {
	service=$(get_service)
	pushd "$SCRIPT_DIR/$COMMAND_PATH"
	docker compose --env-file ../../utils/.env -p "$service" stop
	popd
}

compose_exec() {
	service=$(get_service)
	env_files=$(get_env_files)
	pushd "$SCRIPT_DIR/$COMMAND_PATH"
	cmd="docker compose $env_files exec $service /bin/bash"
	printf "\n%s\n\n" "$cmd"
	$cmd
	popd
}

compose_config() {
	service=$(get_service)
	local env_files=$(get_env_files)
	pushd "$SCRIPT_DIR/$COMMAND_PATH"
	cmd="docker compose $env_files config"
	printf "\n%s\n\n" "$cmd"
	$cmd
	popd
}

compose_rm() {
	local service=$(get_service)
	pushd "$SCRIPT_DIR/$COMMAND_PATH"
	docker compose --env-file ../../utils/.env -p "$service" rm
	popd
}

compose_ps() {
	local service=$(get_service)
	pushd "$SCRIPT_DIR/$COMMAND_PATH"
	cmd="docker compose -p $service ps -a"
	printf "\n%s\n\n" "$cmd"
	$cmd
	popd
}

interpret() {
	case "$COMMAND" in
	:start)
		compose_start "$@"
		;;
	:build)
		compose_build "$@"
		;;
	:stop)
		compose_stop "$@"
		;;
	:rm)
		compose_rm "$@"
		;;
	:exec)
		compose_exec "$@"
		;;
	:up)
		compose_up "$@"
		;;
	:ps)
		compose_ps "$@"
		;;
	:config)
		compose_config "$@"
		;;
	*)
		echo "unknown command $COMMAND"
		exit 1
		;;
	esac
}

parse() {
	args=$(getopt -o h --long build:,up:,start:,stop:,exec:,rm:,ps:,config: -- "$@")
	if [[ $? -ne 0 ]]; then
		exit 1
	fi
	eval set -- "$args"
	while [ : ]; do
		case "$1" in
		--start)
			COMMAND=:start
			COMMAND_PATH="$2"
			shift 2
			;;
		--build)
			COMMAND=:build
			COMMAND_PATH="$2"
			shift 2
			;;
		--up)
			COMMAND=:up
			COMMAND_PATH="$2"
			shift 2
			;;
		--stop)
			COMMAND=:stop
			COMMAND_PATH="$2"
			shift 2
			;;
		--exec)
			COMMAND=:exec
			COMMAND_PATH="$2"
			shift 2
			;;
		--rm)
			COMMAND=:rm
			COMMAND_PATH="$2"
			shift 2
			;;
		--ps)
			COMMAND=:ps
			COMMAND_PATH="$2"
			shift 2
			;;
		--config)
			COMMAND=:config
			COMMAND_PATH="$2"
			shift 2
			;;
		--)
			shift
			break
			;;
		*)
			echo "UNKNOWN OPTION $1"
			#usage 1
			;;
		esac
	done
}

main() {
	cd "$SCRIPT_DIR"
	if ! cd "$SCRIPT_DIR"; then
		echo "failed to change into the project root directory $SCRIPT_DIR"
		exit 1
	fi
	parse "$@"
	interpret "$@"
}

main "$@"
