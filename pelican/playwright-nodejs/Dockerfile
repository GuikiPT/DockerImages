FROM --platform=$TARGETOS/$TARGETARCH node:24-bookworm-slim
LABEL author="GuikiPT"

# Set stop signal
STOPSIGNAL SIGINT

# Install system packages and Playwright dependencies AS ROOT
RUN apt update \
    && apt -y install \
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
    libnss3 \
    tini \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js global packages AS ROOT
RUN npm install --global npm@latest typescript ts-node @types/node

# Install pnpm
RUN npm install -g corepack
RUN corepack enable
RUN corepack prepare pnpm@latest --activate

# Install Playwright globally and download Chromium with all dependencies AS ROOT
RUN npm install -g playwright
RUN npx playwright install --with-deps chromium

# NOW create the container user and switch
RUN useradd -m -d /home/container container

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

# Copy entrypoint
COPY --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/entrypoint.sh"]
