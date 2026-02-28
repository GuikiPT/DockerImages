FROM        --platform=$TARGETOS/$TARGETARCH node:24-bookworm-slim

LABEL       author="Michael Parker" maintainer="parker@pterodactyl.io"

# add container user and set stop signal
RUN         useradd -m -d /home/container container
STOPSIGNAL SIGINT

# Install system dependencies including full Chromium/Puppeteer runtime libraries
RUN         apt update \
            && apt -y install --no-install-recommends \
                ffmpeg \
                iproute2 \
                git \
                sqlite3 \
                libsqlite3-dev \
                python3 \
                python3-dev \
                ca-certificates \
                dnsutils \
                tzdata \
                zip \
                tar \
                curl \
                build-essential \
                libtool \
                iputils-ping \
                tini \
                libatk1.0-0 \
                libatk-bridge2.0-0 \
                libatspi2.0-0 \
                libcairo2 \
                libcups2 \
                libdbus-1-3 \
                libdrm2 \
                libexpat1 \
                libfontconfig1 \
                libgbm1 \
                libglib2.0-0 \
                libgtk-3-0 \
                libnspr4 \
                libnss3 \
                libpango-1.0-0 \
                libpangocairo-1.0-0 \
                libasound2 \
                libx11-6 \
                libx11-xcb1 \
                libxcb1 \
                libxcb-dri3-0 \
                libxcomposite1 \
                libxcursor1 \
                libxdamage1 \
                libxext6 \
                libxfixes3 \
                libxi6 \
                libxkbcommon0 \
                libxrandr2 \
                libxrender1 \
                libxss1 \
                libxtst6 \
                fonts-liberation \
                fonts-noto-color-emoji \
                xdg-utils \
            && rm -rf /var/lib/apt/lists/*

RUN         npm install --global npm@latest typescript ts-node @types/node

# install pnpm
RUN         npm install -g corepack
RUN         corepack enable
RUN         corepack prepare pnpm@latest --activate

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh
ENTRYPOINT    ["/usr/bin/tini", "-g", "--"]
CMD         ["/entrypoint.sh"]
