# syntax=docker/dockerfile:1.7-labs
# emmy runtime

ARG USERNAME

# ------------------------------------------------------------------------------
FROM ubuntu:22.04 AS emmy-runtime
# ------------------------------------------------------------------------------

ARG USERNAME

COPY --from=brave-runtime / /
COPY --from=gh-runtime / /
COPY --from=emacs-runtime / /
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN bash -xeu <<"EOF" # install runtime deps
set -xeu
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

RUN chown ${USERNAME}:${USERNAME} /usr/local/bin/entrypoint.sh
USER ${USERNAME}
WORKDIR /home/${USERNAME}

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

