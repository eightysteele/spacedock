#!/usr/bin/env bash

set -e

FOO_SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ROOT=$(dirname "$FOO_SCRIPT_DIR")
COMMAND=""
COMMAND_PATH=""

get_project() {
	local type=$(dirname "$COMMAND_PATH")
	local project=$(basename "$COMMAND_PATH")
	if [ "$type" == "layers" ]; then
		project="$project-layer"
	elif [ "$type" == "." ]; then
		project="spok"
	fi
	echo "$project"
}

get_service() {
	shift 2
	echo "$1"
}

get_command() {
	shift 3
	command="${1:-/bin/bash}"
	echo "$command"
}

get_env_files() {
	local env_files=""
	local type=$(dirname "$COMMAND_PATH")
	if [ "$type" == "layers" ]; then
		env_files="--env-file ../../deps/default.env --env-file ../../layers/default.env --env-file override.env"
	elif [ "$type" == "." ]; then
		env_files="--env-file spok.env"
	else
		env_files="--env-file ../../spok.env --env-file .env"
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
	local service=$(get_project)
	pushd "$ROOT/$COMMAND_PATH"
	local cmd="docker compose --env-file ../default.env --env-file override.env -p $service build"
	printf "\n%s\n\n" "$cmd"
	$cmd
	popd
}

compose_start() {
	local project=$(get_project)
	local service=$(get_service "$@")
	local env_files=$(get_env_files)
	pushd "$ROOT/$COMMAND_PATH"
	local cmd="docker compose $env_files -p $project start $project-$service"
	printf "\n%s\n\n" "$cmd"
	$cmd
	popd
}

copy_tools() {
	local paths="$1"
	echo "paths: $paths"
	for path in $paths; do
		local basename=$(basename "$path")
		local src="../$basename/tools.sh"
		local dest="$basename-tools.sh"
		echo "copying $src to $dest"
		if ! cp "$src" "$dest" 2>/dev/null; then
			echo "skipped $src..."
		fi
	done
}

copy-spok-tools() {
	local paths="$1"
	echo "paths: $paths"
	for path in $paths; do
		local basename=$(basename "$path")
		local src="$path/tools.sh"
		for p in $paths; do
			if [[ $path != $p ]]; then
				local dest="$p/$basename-tools.sh"
				echo "copying $src to $dest"
				#if ! cp "$src" "$dest" 2>/dev/null; then
			#		echo "skipped $src..."
			#	fi
			fi
		done
	done
}

get-dep-paths() {
	local dir="deps"
	local dir_list=""

	# Check if the directory exists
	if [[ -d "$dir" ]]; then
		# Loop through each file in the directory
		for file in "$dir"/*; do
			# Check if the file is a directory
			if [[ -d "$file" ]]; then
				# Append the directory name to the list
				dir_list+="deps/${file##*/} "
			fi
		done
	else
		echo "Directory does not exist."
		return 1
	fi

	# Trim the trailing space and return the list
	echo "${dir_list% }"
}

delete-tools-files() {
	rm -f ./*-tools.sh
	echo "Deleted all *-tools.sh files in the current directory."
}

get-spok-deps() {
	local dep_paths=$(get-dep-paths)
	copy-spok-tools "$dep_paths"
}

delete-spok-deps() {
	local dep_paths=$(get-dep-paths)
	echo "PATHS $dep_paths"
	for path in $dep_paths; do
		local basename=$(basename "$path")
		local src="$path/tools.sh"
		for p in $dep_paths; do
			if [[ $path != $p ]]; then
				local dest="$p/$basename-tools.sh"
				echo "deleting $dest"
				#if ! cp "$src" "$dest" 2>/dev/null; then
				#		echo "skipped $src..."
				#	fi
			fi
		done
	done
}

get_deps() {
	shift 1
	pushd "$1"
	shift 2
	copy_tools "$@"
	popd
}

compose_up() {
	get_deps "$@"
	local service=$(get_service "$@")
	local project=$(get_project)
	local env_files=$(get_env_files)
	echo "$deps"
	pushd "$ROOT/$COMMAND_PATH"
	local cmd="docker compose --progress plain $env_files -p $project up -d --build --remove-orphans $project-$service"
	printf "\n%s\n\n" "$cmd"
	$cmd
	delete-tools-files
	popd
}

compose_run() {
	xhost +local:docker
	local service=$(get_service "$@")
	local project=$(get_project)
	local env_files=$(get_env_files)
	get-spok-deps
	local cmd="docker compose -f spok.yml $env_files -p $project run --build --remove-orphans $project-$service"
	printf "\n%s\n\n" "$cmd"
	#$cmd
	delete-spok-deps
}

compose_stop() {
	local service=$(get_service "$@")
	local project=$(get_project)
	local env_files=$(get_env_files)
	pushd "$ROOT/$COMMAND_PATH"
	cmd="docker compose $env_files -p $project stop $project-$service"
	printf "\n%s\n\n" "$cmd"
	$cmd
	popd
}

compose_exec() {
	xhost +local:docker
	command=$(get_command "$@")
	service=$(get_service "$@")
	project=$(get_project)
	env_files=$(get_env_files)
	pushd "$ROOT/$COMMAND_PATH"
	cmd="docker compose -p $project $env_files exec $project-$service $command"
	printf "\n%s\n\n" "$cmd"
	$cmd
	popd
}

compose_config() {
	project=$(get_project)
	local env_files=$(get_env_files)
	pushd "$ROOT/$COMMAND_PATH"
	cmd="docker compose -p $project $env_files config"
	printf "\n%s\n\n" "$cmd"
	$cmd
	popd
}

compose_rm() {
	local service=$(get_project)
	local env_files=$(get_env_files)
	pushd "$ROOT/$COMMAND_PATH"
	cmd="docker compose $env_files rm $service"
	printf "\n%s\n\\n" "$cmd"
	$cmd
	popd
}

compose_ps() {
	local service=$(get_project)
	local env_files=$(get_env_files)
	pushd "$ROOT/$COMMAND_PATH"
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
	:run)
		compose_run "$@"
		;;
	*)
		echo "unknown command $COMMAND"
		exit 1
		;;
	esac
}

parse() {
	args=$(getopt -o h --long build:,up:,start:,stop:,exec:,rm:,ps:,config:,run: -- "$@")
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
		--run)
			COMMAND=:run
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
	cd "$ROOT"
	if ! cd "$ROOT"; then
		echo "failed to change into the project root directory $ROOT"
		exit 1
	fi
	parse "$@"
	interpret "$@"
}

main "$@"
