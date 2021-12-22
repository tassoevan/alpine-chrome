#!/bin/sh -e

source .scripts/metadata.sh

rm README.md

cat >>README.md -<<'EOF'
<p align="center">
  <a href="https://rocket.chat" title="Rocket.Chat">
    <img src="https://github.com/RocketChat/Rocket.Chat.Artwork/raw/master/Logos/2020/png/logo-horizontal-red.png" alt="Rocket.Chat" />
  </a>
</p>

EOF

ALPINE_VERSION=$(docker run -it --rm --entrypoint "" "${IMAGE_NAME}:latest" cat /etc/alpine-release | awk '{gsub(/[[:space:]]+$/,""); print $0}')
CHROMIUM_VERSION=$(docker run -it --rm --entrypoint "" "${IMAGE_NAME}:latest" chromium-browser --version | awk '{gsub(/^Chromium |[[:space:]]+$/,""); print $0}')
NODE_VERSION=$(docker run -it --rm --entrypoint "" "${IMAGE_NAME}:latest-with-node" node --version | awk '{gsub(/[[:space:]]+$/,""); print $0}')

cat >>README.md -<<EOF
# \`${IMAGE_NAME}\`

> ${IMAGE_DESCRIPTION}

---

[![Docker Pulls](https://img.shields.io/docker/pulls/${IMAGE_NAME}.svg)](https://hub.docker.com/r/${IMAGE_NAME}/)
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/${IMAGE_NAME})](https://hub.docker.com/r/${IMAGE_NAME}/)
[![Docker Stars](https://img.shields.io/docker/stars/${IMAGE_NAME})](https://hub.docker.com/r/${IMAGE_NAME}/)

![Alpine Version](https://shields.io/badge/alpine-${ALPINE_VERSION}-blue?style=flat)
![Chromium Version](https://shields.io/badge/chromium-${CHROMIUM_VERSION}-blue?style=flat)
![Node Version](https://shields.io/badge/node-${NODE_VERSION}-blue?style=flat)
EOF
