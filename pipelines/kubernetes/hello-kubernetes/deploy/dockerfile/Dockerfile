# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM alpine:3.23 AS builder1

ARG TARGETOS TARGETARCH

ARG VAULT_VERSION=1.21.4

RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache curl unzip ca-certificates && \
    update-ca-certificates && \
    curl -fsSL --retry 3 https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_${TARGETOS}_${TARGETARCH}.zip -o vault.zip && \
    unzip vault.zip && chmod +x vault


FROM --platform=$BUILDPLATFORM alpine:3.23 AS builder2

WORKDIR /home/node

COPY . ./

RUN npm ci --omit=dev


FROM --platform=$BUILDPLATFORM node:25-alpine3.23

LABEL maintainer=constantin07

RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache jq ca-certificates curl && \
    update-ca-certificates

# Change UID/GID to higher number
RUN apk --no-cache add --virtual .build-deps shadow && \
    usermod --uid 10001 node && \
    groupmod --gid 10001 node && \
    chown -R 10001:10001 /home/node && \
    apk del .build-deps

# remove npm (removes many vulnerabilities)
RUN rm -rf /usr/local/lib/node_modules/npm \
           /usr/local/bin/npm \
           /usr/local/bin/npx

COPY --from=builder1 /vault /usr/local/bin/
COPY --from=builder2 --chown=node:node /home/node /home/node/

USER 10001
WORKDIR /home/node

EXPOSE 8080

HEALTHCHECK CMD --interval=10s --timeout=3s curl --fail http://localhost:8080/health || exit 1

CMD [ "node", "server.js" ]
ENTRYPOINT ["/home/node/entrypoint.sh"]
