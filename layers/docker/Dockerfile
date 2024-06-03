# syntax=docker/dockerfile:1.7-labs

################################################################################
FROM xdg AS docker-layer
################################################################################

COPY --from=docker-language-server / /
COPY --from=hadolint / /
