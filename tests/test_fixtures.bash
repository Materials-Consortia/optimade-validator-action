#!/usr/bin/env bash

# Absolute path to entrypoint.sh
export ENTRYPOINT_SH=/code/entrypoint.sh

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
    export INPUT_VALIDATOR_VERSION=d71275a38f3c0e778408f22b6a2566c1e901793a
    export INPUT_VERBOSITY=1
    export INPUT_FAIL_FAST=true
    export INPUT_SKIP_OPTIONAL=true

    rm -f /code/tests/.entrypoint-run_validator.txt
}

function teardown() {
    if [ "${TEST_FINAL_RUN_VALIDATOR}" = "default" ] || [ -z "${TEST_FINAL_RUN_VALIDATOR}" ]; then
        TEST_FINAL_RUN_VALIDATOR="optimade-validator --verbosity 1 --fail-fast --skip-optional http://gh_actions_host/v1"
    fi
    run cat /code/tests/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_FINAL_RUN_VALIDATOR}"

    rm -f /code/tests/.entrypoint-run_validator.txt
}
