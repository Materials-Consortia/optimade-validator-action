#!/usr/bin/env bash

# Set workdir to Docker default if not set already
if [ -z "${DOCKER_BATS_WORKDIR}" ]; then
    export DOCKER_BATS_WORKDIR=/code
fi

# Absolute path to entrypoint.sh
export ENTRYPOINT_SH=${DOCKER_BATS_WORKDIR}/entrypoint.sh

# Load BATS extensions (installed in ./tests/Dockerfile)
load "${BATS_TEST_HELPERS}/bats-support/load.bash"
load "${BATS_TEST_HELPERS}/bats-assert/load.bash"

function setup() {
    # Set all input parameter defaults
    export INPUT_ALL_VERSIONED_PATHS=false
    export INPUT_DOMAIN=gh_actions_host
    export INPUT_INDEX=false
    export INPUT_PATH=/v1
    export INPUT_PROTOCOL=http
    export INPUT_VALIDATOR_VERSION=master
    export INPUT_VERBOSITY=1
    export INPUT_FAIL_FAST=false
    export INPUT_SKIP_OPTIONAL=false

    export TEST_FINAL_RUN_VALIDATOR="optimade-validator -v http://gh_actions_host/v1"

    rm -f ${DOCKER_BATS_WORKDIR}/tests/.entrypoint-run_validator.txt
}

function teardown() {
    rm -f ${DOCKER_BATS_WORKDIR}/tests/.entrypoint-run_validator.txt
}
