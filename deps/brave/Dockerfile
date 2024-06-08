# syntax=docker/dockerfile:1.7-labs
# brave https://brave.com/linux

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS brave-builder

ADD tools.sh /usr/local/bin/tools.sh
RUN tools.sh --install-build-deps
RUN tools.sh --build

#-------------------------------------------------------------------------------
FROM ubuntu:22.04 AS brave-runtime

COPY --from=brave-builder / /build/
ADD tools.sh /usr/local/bin/tools.sh
RUN tools.sh --install-runtime-deps
RUN tools.sh --copy-build-artifacts
RUN rm -rf /build

# COPY --from=brave-builder \
#     --parents \
#     /etc/alternatives/brave-browser \
#     /etc/alternatives/gnome-www-browser \
#     /etc/alternatives/open \
#     /etc/alternatives/x-www-browser \
#     /opt/brave.com \
#     /usr/bin/brave-browser \
#     /usr/bin/brave-browser-stable \
#     /usr/bin/x-www-browser \
#     /usr/share/appdata/brave-browser.appdata.xml \
#     /usr/share/gnome-control-center/default-apps/brave-browser.xml \
#     /usr/share/menu/brave-browser.menu \
#     /var/lib/dpkg/alternatives/brave-browser \
#     /var/lib/dpkg/alternatives/gnome-www-browser \
#     /var/lib/dpkg/alternatives/open \
#     /var/lib/dpkg/alternatives/x-www-browser \
#     /
