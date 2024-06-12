#!/usr/bin/env bash

set -eu

emacs-daemon-running() {
	if pgrep -af "^emacs.*--daemon$" >/dev/null; then
		return 0
	else
		return 1
	fi
}

emacs-daemon-start() {
	yes | emacs --daemon
}

bootstrap() {
	if [ ! -d "$XDG_CONFIG_HOME" ]; then
		echo "creating $XDG_CONFIG_HOME"
		mkdir "$XDG_CONFIG_HOME"
	fi

	cd "$XDG_CONFIG_HOME"

	if ! gh auth status; then
		gh auth login
	fi

	if [ ! -d "emacs" ]; then
		gh repo clone "${SPOK_GH_SPACEMACS}" emacs
		mkdir emacs/org-roam
		gh repo clone "${SPOK_GH_ORG_ROAM_DATA}" emacs/org-roam/"${SPOK_GH_ORG_ROAM_DATA}"
	fi

	if [ ! -d "${SPOK_GH_SPACEMACS_D}" ]; then
		gh repo clone "${SPOK_GH_SPACEMACS_D}" spacemacs.d
	fi

	if [ ! -d "code" ]; then
		mkdir "code"
	fi
	pushd "code"
	IFS=','
	for value in $SPOK_GH_REPOS; do
		if [ ! -d "$value" ]; then
			gh repo clone "$value"
		fi
	done
	popd

}

main() {
	bootstrap
	if ! emacs-daemon-running; then
		emacs-daemon-start
	fi
	cd ~
}

main "$@"

/bin/bash
