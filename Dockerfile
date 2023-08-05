ARG MEGA_DOWNLOAD_URL="https://mega.nz/linux/MEGAsync/Fedora_38/x86_64/megasync-Fedora_38.x86_64.rpm"



FROM scratch AS rootfs

COPY ["./rootfs/", "/"]



FROM lscr.io/linuxserver/baseimage-fedora:38

ARG MEGA_DOWNLOAD_URL
RUN set -eux \
    && curl "${MEGA_DOWNLOAD_URL}" --output "/tmp/megacmd.rpm" \
    && dnf --assumeyes install "/tmp/megacmd.rpm" \
    && dnf autoremove -y \
    && dnf clean all \
    && rm -rf /tmp/*

COPY --from=rootfs ["/", "/"]

WORKDIR "/config/mega"