# syntax=docker/dockerfile:1.7-labs
# spok runtime

ARG USERNAME

# ------------------------------------------------------------------------------
FROM spok-layer AS spok-runtime
# ------------------------------------------------------------------------------

ARG USERNAME

RUN bash -x <<"EOF" # install spok runtime
set -eu
apt update
apt install -y --no-install-recommends \
    sudo \
    fonts-firacode
apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
EOF

RUN bash -x <<"EOF" # create user
set -eu
useradd --create-home ${USERNAME}
usermod -aG sudo ${USERNAME}
echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}
EOF

COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chown ${USERNAME}:${USERNAME} /usr/local/bin/entrypoint.sh
USER ${USERNAME}
WORKDIR /home/${USERNAME}
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
