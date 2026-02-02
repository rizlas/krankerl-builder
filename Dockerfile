FROM php:8.2-cli

RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    gnupg \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install krankerl
WORKDIR /tmp
RUN curl -L -o krankerl.deb https://github.com/ChristophWurst/krankerl/releases/download/v0.14.0/krankerl_0.14.0_amd64.deb \
    && dpkg -i krankerl.deb \
    && rm krankerl.deb

RUN groupadd -g 1000 krankerl && useradd -m -u 1000 -g 1000 krankerl

RUN mkdir -p /workspace /opt/build && chown -R krankerl:krankerl /workspace /opt/build

# Workspace
WORKDIR /workspace

VOLUME ["/opt/build"]

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown krankerl:krankerl /entrypoint.sh

USER krankerl

ENTRYPOINT ["/entrypoint.sh"]
