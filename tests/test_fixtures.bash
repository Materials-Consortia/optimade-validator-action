#!/usr/bin/env bash

# Set workdir to Docker default if not set already
if [ -z "${DOCKER_BATS_WORKDIR}" ]; then
    export DOCKER_BATS_WORKDIR=/code
fi

# Absolute path to entrypoint.sh
export REAL_ENTRYPOINT_SH=${DOCKER_BATS_WORKDIR}/entrypoint.sh
export ENTRYPOINT_SH=${DOCKER_BATS_WORKDIR}/tests/.entrypoint.sh

# Load BATS extensions (installed in ./tests/Dockerfile)
load "${BATS_TEST_HELPERS}/bats-support/load.bash"
load "${BATS_TEST_HELPERS}/bats-assert/load.bash"

function setup_file() {
    # Set all input parameter defaults
    export INPUT_ALL_VERSIONED_PATHS=false
    export INPUT_DOMAIN=gh_actions_host
    export INPUT_FAIL_FAST=false
    export INPUT_INDEX=false
    export INPUT_PATH=/
    export INPUT_PROTOCOL=http
    export INPUT_SKIP_OPTIONAL=false
    export INPUT_VALIDATOR_VERSION=latest
    export INPUT_VERBOSITY=1

    # Validator runs executed (with defaults)
    export TEST_BASE_RUN_VALIDATOR="optimade-validator -v ${INPUT_PROTOCOL}://${INPUT_DOMAIN}${INPUT_PATH}"
    export TEST_MAJOR_RUN_VALIDATOR="${TEST_BASE_RUN_VALIDATOR}v1"

    # Clean "cache"
    rm -f ${DOCKER_BATS_WORKDIR}/tests/.entrypoint-run_validator.txt
    rm -f ${ENTRYPOINT_SH}

    # Comment out "set -e" from entrypoint.sh in a new test entrypoint.sh
    while IFS="" read -r line || [ -n "${line}" ]; do
        if [[ "${line}" =~ ^set[[:blank:]]-e$ ]]; then
            line="# ${line}"
        fi
        printf "%s\n" "${line}" >> ${ENTRYPOINT_SH}
    done < ${REAL_ENTRYPOINT_SH}
    chmod +x ${ENTRYPOINT_SH}
}

function teardown() {
    rm -f ${DOCKER_BATS_WORKDIR}/tests/.entrypoint-run_validator.txt
}

function teardown_file() {
    rm -f ${ENTRYPOINT_SH}
}
