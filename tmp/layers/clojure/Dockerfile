# syntax=docker/dockerfile:1.7-labs

ARG USERNAME

################################################################################
FROM xdg AS clojure-layer
################################################################################

ARG USERNAME

USER root

COPY --from=clojure / /
COPY --from=clj-kondo / /
COPY --from=joker / /

USER ${USERNAME} 
