FROM alpine:3.17 AS builder

ARG VAULT_VERSION=1.12.2

RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache curl unzip && \
    update-ca-certificates && \
    curl -fsSL --retry 3 https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -o vault.zip && \
    unzip vault.zip && chmod +x vault


FROM node:19-alpine3.17

RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache jq ca-certificates curl && \
    update-ca-certificates

COPY --chown=node:node . /home/node/
COPY --from=builder /vault /usr/local/bin/

USER node
WORKDIR /home/node

RUN npm install

EXPOSE 8080

HEALTHCHECK CMD --interval=10s --timeout=3s curl --fail http://localhost:8080/health || exit 1

CMD [ "npm", "start" ]
ENTRYPOINT ["/home/node/entrypoint.sh"]
