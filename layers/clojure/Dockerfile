# syntax=docker/dockerfile:1.7-labs

ARG GOROOT

################################################################################
FROM xdg AS clojure-layer
################################################################################

ARG GOROOT
ENV GOBIN=${GOROOT}/bin
ENV PATH=${GOBIN}:$PATH

COPY --from=clojure / /
COPY --from=clj-kondo / /
COPY --from=joker / /
