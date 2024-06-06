#!/usr/bin/env bash

# setup environment
export PATH=$__PATH:$PATH
export SPACEMACSDIR=${__SPACEMACSDIR}
export XDG_CONFIG_HOME=${__XDG_CONFIG_HOME}
export DISPLAY=${__DISPLAY}

# authenticate gh
if ! gh auth status; then
	gh auth login
fi
git config --global --add safe.directory "*"

# pull the latest spacemacs config
pushd "$SPACEMACSDIR" || exit 1
echo "pulling $SPACEMACSDIR"
git pull
popd || exit 1

# start emacs daemon
if pgrep -af "^emacs.*--daemon$" >/dev/null; then
	echo "emacs daemon is running."
else
	echo "starting emacs daemon..."
	yes | emacs --daemon
fi

# clone repos
CODE_DIR="/code"
cd "$CODE_DIR" || exit 1
if [ ! -d "$CODE_DIR/emmy" ]; then
	gh repo clone eightysteele/emmy
fi
if [ ! -d "$CODE_DIR/spacedock" ]; then
	gh repo clone eightysteele/spacedock
fi
if [ ! -d "$CODE_DIR/Gen.clj" ]; then
	gh repo clone eightysteele/Gen.clj
fi
if [ ! -d "$CODE_DIR/priors" ]; then
	gh repo clone eightysteele/priors
fi

# get org repo into the volume
org_repo="$XDG_CONFIG_HOME/org-roam-data"
org_volume="$XDG_CONFIG_HOME/emacs/org-roam/"
if [ -d "$org_volume/org-roam-data" ]; then
	pushd "$org_volume/org-roam-data" || exit 1
	git pull
	popd || exit 1
elif [ -d "$org_repo" ]; then
	echo "first run, moving $org_repo into $org_volume"
	mv "$org_repo" "$org_volume"/
fi

/bin/bash
