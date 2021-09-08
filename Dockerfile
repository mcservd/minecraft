ARG MINECRAFT_VERSION=1.17.1
ARG BASE_IMAGE=openjdk:11.0.4-jre-slim

FROM alpine:3.14.2 as downloader

RUN apk add --no-cache \
    curl \
    jq

RUN curl -o /tmp/server.jar $(curl -s `curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq '.versions[] |  select(.id=="$MINECRAFT_VERSION").url'` | jq '.downloads.server.url')

FROM $BASE_IMAGE

COPY --from=downloader /tmp/server.jar ./

ENTRYPOINT ["java"]
CMD ["-jar", "minecraft.jar"]
