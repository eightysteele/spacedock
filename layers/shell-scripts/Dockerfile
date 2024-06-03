# syntax=docker/dockerfile:1.7-labs

################################################################################
FROM xdg AS shell-scripts-layer
################################################################################

COPY --from=shfmt / /
COPY --from=bashate / /
COPY --from=bash-language-server / /



