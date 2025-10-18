FROM        --platform=$TARGETOS/$TARGETARCH ubuntu:noble
LABEL       author="GuikiPT"

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=America/Los_Angeles

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Set stop signal
STOPSIGNAL SIGINT

# === INSTALL Node.js and Pelican dependencies ===
RUN apt-get update && \
	# Install Node.js
	apt-get install -y curl wget gpg ca-certificates && \
	mkdir -p /etc/apt/keyrings && \
	curl -sL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
	echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" >> /etc/apt/sources.list.d/nodesource.list && \
	apt-get update && \
	apt-get install -y nodejs && \
	# Pelican runtime dependencies
	apt-get install -y --no-install-recommends \
	ffmpeg \
	iproute2 \
	git \
	sqlite3 \
	libsqlite3-dev \
	python3 \
	python3-dev \
	dnsutils \
	tzdata \
	zip \
	tar \
	build-essential \
	libtool \
	iputils-ping \
	openssh-client \
	tini && \
	# Install npm global packages
	npm install --global npm@latest typescript ts-node @types/node && \
	# Install pnpm
	npm install -g corepack && \
	corepack enable && \
	corepack prepare pnpm@latest --activate && \
	# Clean apt cache
	rm -rf /var/lib/apt/lists/* && \
	# Create the container user (Pelican template)
	useradd -m -d /home/container container

# === BAKE BROWSERS INTO IMAGE ===
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# Install Playwright and browsers
RUN mkdir /ms-playwright && \
	mkdir /ms-playwright-agent && \
	cd /ms-playwright-agent && \
	npm init -y && \
	npm install playwright && \
	npm exec --no -- playwright install --with-deps chromium && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /ms-playwright-agent && \
	rm -rf ~/.npm/ && \
	chown -R container:container /ms-playwright && \
	chmod -R 755 /ms-playwright

# Switch to container user (Pelican template)
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY --chown=container:container ./entrypoint.sh /entrypoint.sh
USER root
RUN chmod +x /entrypoint.sh
USER container

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/entrypoint.sh"]