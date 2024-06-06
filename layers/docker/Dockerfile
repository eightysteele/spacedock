# syntax=docker/dockerfile:1.7-labs

ARG USERNAME

################################################################################
FROM xdg AS docker-layer
################################################################################

ARG USERNAME

USER root

COPY --from=docker-language-server / /
COPY --from=hadolint / /

USER ${USERNAME}
