#!/bin/bash
__DEV_MODE=1
__COMPOSE_COMMAND=${__DEV_MODE:+tail -f /dev/null}
__COMPOSE_COMMAND=${__COMPOSE_COMMAND:-}
__COMPOSE_DEPENDENCY_CONDITION=${__DEV_MODE:+service_started}
__COMPOSE_DEPENDENCY_CONDITION=${__COMPOSE_DEPENDENCY_CONDITION:-service_completed_successfully}
__XDG_HOME=/opt/xdg
__CABAL_HOME=/opt/xdg/.config/.cabal

echo "command ${__COMPOSE_COMMAND}"
echo "command ${__COMPOSE_DEPENDENCY_CONDITION}"
echo "devmode ${__DEV_MODE}"
