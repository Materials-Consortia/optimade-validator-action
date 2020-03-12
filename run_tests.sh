#!/bin/sh

DOCKER_BATS_IMAGE_NAME=optimade_bats

if [ -n "$1" ]; then
    DOCKER_BATS_IMAGE_NAME=$1
fi

docker run -i -v "$(pwd):/code" --workdir /code/tests $DOCKER_BATS_IMAGE_NAME .
