#!/bin/sh

PHP_VERSION="7.3.11"
IMAGE_NAME="whcdc/php-fpm:${PHP_VERSION}"

case "$1" in
    build)
        docker build -t $IMAGE_NAME .
        ;;

    push)
        docker push $IMAGE_NAME
        ;;
    *)
        echo $"Usage: $0 {build|push}"
        exit 1
esac
