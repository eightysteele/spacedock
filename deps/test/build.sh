#!/usr/bin/env bash

set -xeu

apt update
apt install -y --no-install-recommends \
	ca-certificates \
	curl

curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list

apt update
apt install -y --no-install-recommends brave-browser

apt install -y --no-install-recommends \
	brave-keyring \
	ca-certificates \
	fonts-liberation \
	libasound2 \
	libatk-bridge2.0-0 \
	libatk1.0-0 \
	libatspi2.0-0 \
	libcairo2 \
	libcups2 \
	libcurl3 \
	libcurl3-gnutls \
	libcurl3-nss \
	libcurl4 \
	libdbus-1-3 \
	libdrm2 \
	libexpat1 \
	libgbm1 \
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
