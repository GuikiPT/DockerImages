FROM --platform=$TARGETOS/$TARGETARCH node:24-bookworm-slim
LABEL author="GuikiPT"

# Set stop signal
STOPSIGNAL SIGINT

# Install base system packages AS ROOT
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

# Install Playwright globally and browsers with system dependencies AS ROOT
RUN npm install -g playwright
RUN npx playwright install --with-deps chromium

# Create the container user
RUN useradd -m -d /home/container container

# Set up a symlink so container user can access global node_modules
RUN mkdir -p /home/container/node_modules && \
    ln -s /usr/local/lib/node_modules/playwright /home/container/node_modules/playwright && \
    chown -R container:container /home/container

# Set environment variable so Node can find globally installed modules
ENV NODE_PATH=/usr/local/lib/node_modules

# Switch to container user
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

# Copy entrypoint
COPY --chown=container:container ./entrypoint.sh /entrypoint.sh
USER root
RUN chmod +x /entrypoint.sh
USER container

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/entrypoint.sh"]
