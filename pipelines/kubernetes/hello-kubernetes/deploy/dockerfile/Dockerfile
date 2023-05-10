FROM --platform=$BUILDPLATFORM alpine:3.18 AS builder

ARG TARGETOS TARGETARCH

ARG VAULT_VERSION=1.13.1

RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache curl unzip && \
    update-ca-certificates && \
    curl -fsSL --retry 3 https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_${TARGETOS}_${TARGETARCH}.zip -o vault.zip && \
    unzip vault.zip && chmod +x vault


FROM node:20-alpine3.17

LABEL maintainer=constantin07

RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache jq ca-certificates curl && \
    update-ca-certificates

# Change UID/GID to higher number
RUN apk --no-cache add --virtual .build-deps shadow && \
    usermod --uid 10000 node && \
    groupmod --gid 10000 node && \
    chown -R 10000:10000 /home/node && \
    apk del .build-deps

COPY --chown=node:node . /home/node/
COPY --from=builder /vault /usr/local/bin/

USER 10000
WORKDIR /home/node

RUN npm install

EXPOSE 8080

HEALTHCHECK CMD --interval=10s --timeout=3s curl --fail http://localhost:8080/health || exit 1

CMD [ "npm", "start" ]
ENTRYPOINT ["/home/node/entrypoint.sh"]
