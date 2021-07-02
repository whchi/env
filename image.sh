#!/bin/sh

SUFFIX=$2
TAG="latest"
IMAGE_NAME="app_${SUFFIX}:${TAG}"

case "$1" in
    build)
        docker build -f Dockerfile-${2} -t $IMAGE_NAME .
        ;;

    push)
        docker push $IMAGE_NAME
        ;;
    *)
        echo $"Usage: $0 {build|push}"
        exit 1
esac
