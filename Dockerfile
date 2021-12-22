ARG IMAGE_NAME
ARG IMAGE_DESCRIPTION
ARG GIT_REPO="https://github.com/${IMAGE_NAME}"
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION="latest"
ARG VARIANT=base

FROM alpine:3.15.0 AS alpine-chromium-base

LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/${IMAGE_NAME}"
LABEL org.opencontainers.image.source="${GIT_REPO}"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.revision="${VCS_REF}"
LABEL org.opencontainers.image.vendor="Rocket.Chat Technologies Corp."
LABEL org.opencontainers.image.title="alpine-chromium"
LABEL org.opencontainers.image.description="${IMAGE_DESCRIPTION}"
LABEL org.opencontainers.image.documentation="${GIT_REPO}/blob/master/README.md"
LABEL org.opencontainers.image.authors="Rocket.Chat (https://rocket.chat/)"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.ref.name="${VERSION}"

# Add Chromium and text-rendering dependencies
RUN apk add --no-cache \
      chromium \
      harfbuzz \
      nss \
      freetype \
      ttf-freefont \
    && \
    rm -rf /var/cache/* && \
    mkdir /var/cache/apk

# Add user `chrome` (without password)
RUN adduser -D chrome

# Create the working directory
RUN mkdir -p /usr/src/app && chown -R chrome:chrome /usr/src/app
WORKDIR /usr/src/app

# Run processes with `chrome` user
USER chrome

ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_PATH=/usr/lib/chromium/

# Autorun chromium headless with no GPU
ENTRYPOINT ["chromium-browser", "--headless", "--disable-gpu", "--disable-software-rasterizer", "--disable-dev-shm-usage"]

FROM alpine-chromium-base as alpine-chromium-with-node

LABEL org.opencontainers.image.ref.name=${VERSION}-with-node

USER root
RUN apk add --no-cache \
        tini \
        make \
        gcc \
        g++ \
        python3 \
        git \
        nodejs \
        npm \
        yarn \
    && \
    rm -rf /var/cache/* && \
    mkdir /var/cache/apk

USER chrome
ENTRYPOINT ["tini", "--"]

FROM alpine-chromium-$VARIANT
