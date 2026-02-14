# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM alpine:3.23 AS builder

ARG TARGETOS TARGETARCH

ARG VAULT_VERSION=1.21.3

RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache curl unzip ca-certificates && \
    update-ca-certificates && \
    curl -fsSL --retry 3 https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_${TARGETOS}_${TARGETARCH}.zip -o vault.zip && \
    unzip vault.zip && chmod +x vault


FROM node:25-alpine3.23

LABEL maintainer=constantin07

RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache jq ca-certificates curl && \
    update-ca-certificates

# Change UID/GID to higher number
RUN apk --no-cache add --virtual .build-deps shadow && \
    usermod --uid 10001 node && \
    groupmod --gid 10001 node && \
    chown -R 10001:10001 /home/node && \
    apk del .build-deps

COPY --chown=node:node . /home/node/
COPY --from=builder /vault /usr/local/bin/

USER 10001
WORKDIR /home/node

RUN npm install

EXPOSE 8080

HEALTHCHECK CMD --interval=10s --timeout=3s curl --fail http://localhost:8080/health || exit 1

CMD [ "npm", "start" ]
ENTRYPOINT ["/home/node/entrypoint.sh"]
