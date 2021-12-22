#!/bin/sh -xe

source .scripts/metadata.sh

BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
VCS_REF=$(git rev-parse HEAD)
VERSION=$(git describe --tags)

docker buildx create --driver=docker-container --use

for VARIANT in base with-node
do
  for PLATFORM in linux/amd64 linux/arm64/v8
  do
    [ $VARIANT == "base" ] && TAG_SUFFIX="" || TAG_SUFFIX="-${VARIANT}"

    docker buildx build \
      --platform "${PLATFORM}" \
      --output type=registry \
      --build-arg "IMAGE_NAME=${IMAGE_NAME}" \
      --build-arg "IMAGE_DESCRIPTION=${IMAGE_DESCRIPTION}" \
      --build-arg "BUILD_DATE=${BUILD_DATE}" \
      --build-arg "VCS_REF=${VCS_REF}" \
      --build-arg "VERSION=${VERSION}" \
      --build-arg "VARIANT=${VARIANT}" \
      --tag "${IMAGE_NAME}:${VERSION}${TAG_SUFFIX}" \
      --tag "${IMAGE_NAME}:latest${TAG_SUFFIX}" \
      .
  done
done

docker buildx rm
