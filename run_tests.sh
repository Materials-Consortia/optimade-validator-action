#!/usr/bin/env bash

DOCKER_BATS_IMAGE_NAME=optimade_bats
DOCKER_BATS_TEST_PATH=./tests

if [ -n "$1" ]; then
    if echo "$1" | grep -Eq '*[/\.]+.*'; then
        # TEST PATH
        DOCKER_BATS_TEST_PATH=$1
        if [ -n "$2" ]; then
            # Assume IMAGE NAME
            DOCKER_BATS_IMAGE_NAME=$2
        fi
    else
        # IMAGE NAME
        DOCKER_BATS_IMAGE_NAME=$1
        if [ -n "$2" ]; then
            # Assume TEST PATH
            DOCKER_BATS_TEST_PATH=$2
        fi
    fi
fi

if [ "${CI}" == "true" ]; then
    docker run --rm -i -v "$(pwd):/code" --workdir /code ${DOCKER_BATS_IMAGE_NAME} ${DOCKER_BATS_TEST_PATH}
else
    docker run --rm -it -v "$(pwd):/code" --workdir /code ${DOCKER_BATS_IMAGE_NAME} ${DOCKER_BATS_TEST_PATH}
fi
