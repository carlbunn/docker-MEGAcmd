ARG MEGA_DOWNLOAD_URL="https://mega.nz/linux/repo/Fedora_38/x86_64/megacmd-Fedora_38.x86_64.rpm"

FROM scratch AS rootfs

COPY ["./rootfs/", "/"]

FROM lscr.io/linuxserver/baseimage-fedora:40

RUN set -eux \
    && curl --fail "${MEGA_DOWNLOAD_URL}" --output "/tmp/megacmd.rpm" \
    && dnf --assumeyes install "/tmp/megacmd.rpm" \
    && dnf autoremove -y \
    && dnf clean all \
    && rm -rf /tmp/*

COPY --from=rootfs ["/", "/"]

# Copy scripts
COPY check-megasync.sh /usr/local/bin/check-megasync.sh
COPY start-services.sh /usr/local/bin/start-services.sh

# Make scripts executable
RUN chmod +x /usr/local/bin/check-megasync.sh /usr/local/bin/start-services.sh

# Create cron job to check every 10 minutes
RUN echo "*/10 * * * * /usr/local/bin/check-megasync.sh >> /var/log/megasync-monitor.log 2>&1" > /etc/cron.d/megasync-monitor

# Give execution permission to the cron job
RUN chmod 0644 /etc/cron.d/megasync-monitor

# Create the log file
RUN touch /var/log/megasync-monitor.log

LABEL maintainer="Aleksandar Puharic <aleksandar@puharic.com>" \
      org.opencontainers.image.source="https://github.com/N0rthernL1ghts/docker-MEGAcmd" \
      org.opencontainers.image.description="MEGA CMD - Fedora Build ${TARGETPLATFORM}" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.version="latest"

WORKDIR "/config/mega"

# Set the startup script as the default command
CMD ["/usr/local/bin/start-services.sh"]
