ARG BASE_IMAGE=openjdk:16.0-slim

FROM alpine:3.14.2 as downloader

ARG MINECRAFT_VERSION=1.17.1

RUN apk add --no-cache \
    curl \
    jq

RUN curl -o /tmp/server.jar $(curl -s `curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq --arg version "$MINECRAFT_VERSION" -r '.versions[] | select(.id==$version).url'` | jq -r '.downloads.server.url')

FROM $BASE_IMAGE

COPY --from=downloader /tmp/server.jar /opt/minecraft/

RUN adduser --no-create-home --shell /bin/sh minecraft

RUN chown minecraft:root -R /opt/minecraft

USER minecraft
WORKDIR /opt/minecraft

ENTRYPOINT ["java"]
CMD ["-jar", "server.jar", "--nogui"]
