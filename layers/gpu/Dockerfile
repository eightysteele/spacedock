# syntax=docker/dockerfile:1.7-labs

ARG USERNAME

################################################################################
FROM xdg AS gpu-layer
################################################################################

ARG USERNAME

USER root

COPY --from=cuda-toolkit / /
COPY --from=llvm / /

USER ${USERNAME}
