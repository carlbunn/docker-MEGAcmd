ARG MEGA_DOWNLOAD_URL="https://mega.nz/linux/repo/Fedora_38/x86_64/megacmd-Fedora_38.x86_64.rpm"



FROM scratch AS rootfs

COPY ["./rootfs/", "/"]



FROM lscr.io/linuxserver/baseimage-fedora:38

ARG MEGA_DOWNLOAD_URL
RUN set -eux \
    && curl --fail "${MEGA_DOWNLOAD_URL}" --output "/tmp/megacmd.rpm" \
    && dnf --assumeyes install "/tmp/megacmd.rpm" \
    && dnf autoremove -y \
    && dnf clean all \
    && rm -rf /tmp/*

COPY --from=rootfs ["/", "/"]

LABEL maintainer="Aleksandar Puharic <aleksandar@puharic.com>" \
      org.opencontainers.image.source="https://github.com/N0rthernL1ghts/docker-MEGAcmd" \
      org.opencontainers.image.description="MEGA CMD - Fedora Build ${TARGETPLATFORM}" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.version="latest"

WORKDIR "/config/mega"