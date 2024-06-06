# syntax=docker/dockerfile:1.7-labs
# Brave browser: https://brave.com/linux

# ------------------------------------------------------------------------------
FROM ubuntu:22.04 AS brave-builder
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF" # install brave
set -eu

apt update
apt install -y --no-install-recommends \
	ca-certificates \
	curl

curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] \
https://brave-browser-apt-release.s3.brave.com/ stable main" | \
tee /etc/apt/sources.list.d/brave-browser-release.list

apt update
apt install -y --no-install-recommends brave-browser

apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*

apt-cache depends brave-browser \
    | grep -E 'Depends|Recommends|Suggests' \
    | awk '{print $2}' \
    > /brave-runtime-deps.txt
EOF

RUN bash -x <<"EOF" # configure alternatives
set -eu
update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/brave-browser 200
update-alternatives --set x-www-browser /usr/bin/brave-browser
EOF

# ------------------------------------------------------------------------------
FROM ubuntu:22.04 AS brave-runtime
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF" # install runtime deps
set -eu

apt update
apt install -y --no-install-recommends \
	  ca-certificates \
	  fonts-liberation \
	  libasound2 \
	  libatk-bridge2.0-0 \
	  libatk1.0-0 \
	  libatspi2.0-0 \
	  libcairo2 \
	  libcups2 \
	  libcurl3-gnutls \
	  libcurl3-nss \
	  libcurl4 \
	  libdbus-1-3 \
	  libdrm2 \
	  libexpat1 \
	  libgbm1 \
    libgl1 \
	  libglib2.0-0 \
	  libgtk-3-0 \
	  libgtk-4-1 \
	  libnspr4 \
	  libnss3 \
	  libpango-1.0-0 \
	  libu2f-udev \
	  libvulkan1 \
	  libx11-6 \
	  libxcb1 \
	  libxcomposite1 \
	  libxdamage1 \
	  libxext6 \
	  libxfixes3 \
	  libxkbcommon0 \
	  libxrandr2 \
	  wget \
	  xdg-utils

apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
EOF

COPY --parents --from=brave-builder \
    /opt/brave.com \
    /usr/share/appdata/brave-browser.appdata.xml \
    /usr/share/gnome-control-center/default-apps/brave-browser.xml \
    /usr/share/menu/brave-browser.menu \
    /etc/alternatives/brave-browser \
    /usr/bin/brave-browser \
    /usr/bin/brave-browser-stable \
    /usr/bin/x-www-browser \
    /brave-runtime-deps.txt \
    /etc/alternatives \
    /var/lib/dpkg/alternatives \
    /
