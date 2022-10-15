# Set base image (host OS)
FROM alpine:latest

## INSTALL GETIPLAYER

# Ensure dependencies
RUN apk --update --no-cache add ffmpeg perl perl-mojolicious perl-lwp-protocol-https perl-xml-libxml jq logrotate su-exec tini wget libstdc++ bash grep openrc

# AtomicParsley pkg doesn't seem to exist for Alpine
# Install from repo
RUN wget -qnd `wget -qO - "https://api.github.com/repos/wez/atomicparsley/releases/latest" | jq -r .assets[].browser_download_url | grep Alpine` && \
    unzip AtomicParsleyAlpine.zip && \
    install -m 755 -t /usr/local/bin ./AtomicParsley && \
    rm ./AtomicParsley ./AtomicParsleyAlpine.zip

# Move to the place all our code is stored
WORKDIR /getiplayer

# Copy across all code files
COPY start.sh .
COPY update.sh .
COPY watcher.sh .

# Ensure we can run them
RUN chmod 755 ./start.sh
RUN chmod 755 ./update.sh
RUN chmod 755 ./watcher.sh

# Setup the crontab
RUN echo "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" > /root/cron.tab && \
    echo "@hourly /getiplayer/get_iplayer --refresh > /proc/1/fd/1 2>&1" >> /root/cron.tab && \
    echo "*/5 * * * * /getiplayer/watcher.sh > /proc/1/fd/1 2>&1" >> /root/cron.tab && \
    echo "@daily /getiplayer/update.sh > /proc/1/fd/1 2>&1" >> /root/cron.tab && \
    crontab /root/cron.tab && \
    rm -f /root/cron.tab

VOLUME /root/.get_iplayer
VOLUME /output
VOLUME /input

# Execute our setup script which finishes off a few actions for us
RUN /bin/bash /getiplayer/start.sh
