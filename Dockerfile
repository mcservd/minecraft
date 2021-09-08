ARG MINECRAFT_VERSION=1.17.1
ARG BASE_IMAGE=openjdk:11.0.4-jre-slim

FROM busybox:1.34 as downloader

RUN curl -o minecraft.jar https://mcversions.net/download/$MINECRAFT_VERSION

FROM BASE_IMAGE

COPY --from=downloader minecraft.jar ./

ENTRYPOINT ["java"]
CMD ["-jar", "minecraft.jar"]
