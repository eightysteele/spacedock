# syntax=docker/dockerfile:1.7-labs

# https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/12.4.1/ubuntu2204/devel/Dockerfile

ARG CUDA_TOOLKIT_VERSION
ARG CUDA_IMAGE=nvcr.io/nvidia/cuda:${CUDA_TOOLKIT_VERSION}-devel-ubuntu20.04
ARG USERNAME
ARG XDG_HOME

################################################################################
FROM ${CUDA_IMAGE} AS cuda-toolkit
################################################################################

ARG USERNAME
ARG XDG_HOME

USER root

#-------------------------------------------------------------------------------
# nsight compute qt deps for x11: https://doc.qt.io/qt-6/linux-requirements.html
#-------------------------------------------------------------------------------

RUN bash -x <<"EOF"
set -eu
export TZ="America/Los_Angeles"
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
apt update
apt install -y --no-install-recommends \
    sudo
apt update
apt install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    libgl1 \
    libglvnd0 \
    libglx0 \
    libegl1 \
    libxkbcommon0 \
    libfontconfig1 \
    libglib2.0-0 \
    libxcb-cursor0 \
    libgl1 \
    libglvnd0 \
    libglx0 \
    libegl1 \
    libopengl0 \
    libxkbcommon0 \
    libxkbcommon-x11-0 \
    libxcb-icccm4 \
    libxcb-keysyms1 \
    libsm6 \
    libx11-xcb1 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-xfixes0 \
    libxcb-shape0 \
    libxkbcommon-x11-0 \
    libxcb-xinput0 \
    libxcb-cursor0 \
    libfontconfig1 \
    libdbus-1-3 libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libxtst6 \
    libasound2 \
    libopengl0 \
    libegl1 \
    libgssapi-krb5-2 \
    x11-xserver-utils \
    wget \
    gnupg \
    libxkbcommon-x11-0 \
    libxcb-xkb1 \
    libxcb1 \
    libxkbcommon0 \
    libc6 \
    libxkbfile1
apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
EOF

# ------------------------------------------------------------------------------
# recreate xdg and user (since this image isn't based on xgd image)

COPY --from=xdg ${XDG_HOME} ${XDG_HOME}

RUN bash -x <<"EOF"
set -eu
useradd --create-home ${USERNAME}
usermod -aG sudo ${USERNAME}
echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}
EOF

USER ${USERNAME}

