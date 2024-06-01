# syntax=docker/dockerfile:1.7-labs

# Installs jdk: https://adoptium.net/installation/linux/

ARG JDK_MAJOR_VERSION

################################################################################
FROM xdg AS jdk
################################################################################

ARG JDK_MAJOR_VERSION

RUN bash -x <<"EOF"
set -eu
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    apt-transport-https \
    wget \
    gpg \
    gpg-agent \
    libxtst6
apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
EOF

RUN bash -x <<"EOF"
set -eu
# adds the adoptium apt repo
CODENAME=$(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release)
wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor -o /usr/share/keyrings/adoptium-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/adoptium-archive-keyring.gpg] https://packages.adoptium.net/artifactory/deb $CODENAME main" | tee /etc/apt/sources.list.d/adoptium.list
apt-get update
apt-get install -y temurin-${JDK_MAJOR_VERSION}-jdk
apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
EOF
