FROM scratch AS rootfs
COPY ["./rootfs/", "/"]
FROM lscr.io/linuxserver/baseimage-ubuntu:jammy
ARG MEGA_DOWNLOAD_URL="https://mega.nz/linux/repo/xUbuntu_22.04/amd64/megacmd-xUbuntu_22.04_amd64.deb"

RUN set -eux \
    && apt-get update \
    && apt-get install -y curl cron \
    && curl --fail "${MEGA_DOWNLOAD_URL}" --output "/tmp/megacmd.deb" \
    && dpkg -i /tmp/megacmd.deb || apt-get install -fy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/*

COPY --from=rootfs ["/", "/"]

# Copy scripts
COPY check-megasync.sh /usr/local/bin/check-megasync.sh
COPY start-services.sh /usr/local/bin/start-services.sh

# Make scripts executable
RUN chmod +x /usr/local/bin/check-megasync.sh /usr/local/bin/start-services.sh

# Create cron.d directory if it doesn't exist and create cron job
RUN mkdir -p /etc/cron.d
RUN touch /etc/cron.d/megasync-monitor
RUN echo "*/10 * * * * root /usr/local/bin/check-megasync.sh >> /var/log/megasync-monitor.log 2>&1" > /etc/cron.d/megasync-monitor

# Give execution permission to the cron job
RUN chmod 0644 /etc/cron.d/megasync-monitor

# Create the log file
RUN touch /var/log/megasync-monitor.log

LABEL maintainer="Carl Bunn <carl@carlbunn.com>" \
      org.opencontainers.image.source="https://github.com/carlbunn/docker-MEGAcmd" \
      org.opencontainers.image.description="MEGA CMD - Ubuntu Build" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.version="latest"

WORKDIR "/config/mega"

# Set the startup script as the default command
CMD ["/usr/local/bin/start-services.sh"]
