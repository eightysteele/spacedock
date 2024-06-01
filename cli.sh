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

	# Read the YAML file and extract lines under the "include:" attribute
	while IFS= read -r line; do
		if [[ $line =~ ^[[:space:]]*-[[:space:]]*(.*) ]]; then
			# Extract the directory path and replace the filename with .env
			dir_path=$(dirname "${BASH_REMATCH[1]}")
			include_paths+=("$dir_path/.env")
		fi
	done < <(awk '/^include:/,/^$/' "$yaml_file")

	# Return the single string of paths with --env-file prefix
	local result=""
	for path in "${include_paths[@]}"; do
		result+="--env-file $path "
	done
	echo "$result"
}

compose_build() {
	local service=$(get_service)
	pushd "$SCRIPT_DIR/$COMMAND_PATH"
	docker compose --env-file ../../utils/.env -p "$service" build
	popd
}

compose_start() {
	local service=$(get_service)
	pushd "$SCRIPT_DIR/$COMMAND_PATH"
	docker compose --env-file ../../utils/.env -p "$service" start "$service"
	popd
}

# docker compose --env-file ../../utils/.env up -d --build --remove-orphans clojure-layer
compose_up() {
	local service=$(get_service)
	stop_containers
	pushd "$SCRIPT_DIR/$COMMAND_PATH"
	local env_files=$(get_include_env_paths "compose.yml")
	local cmd="docker compose --project-name $service $env_files --env-file .env up -d --build --remove-orphans"
	printf "\n%s\n" "$cmd"
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
	pushd "$SCRIPT_DIR/$COMMAND_PATH"
	local env_files=$(get_include_env_paths "compose.yml")
	cmd="docker compose "$env_files" --env-file .env exec "$service" /bin/bash"
	printf "\n%s\n" "$cmd"
	$cmd
	popd
}

compose_config() {
	service=$(get_service)
	pushd "$SCRIPT_DIR/$COMMAND_PATH"
	local env_files=$(get_include_env_paths "compose.yml")
	cmd="docker compose $env_files --env-file .env config"
	printf "\n%s\n" "$cmd"
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
	docker compose --env-file ../../utils/.env -p "$service" ps
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
