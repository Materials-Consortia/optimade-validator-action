#!/usr/bin/env bash

# Set all input parameter defaults
export INPUT_ALL_VERSIONED_PATHS=false
export INPUT_DOMAIN=gh_actions_host
export INPUT_INDEX=false
export INPUT_PATH=/v0
export INPUT_PROTOCOL=http
export INPUT_VALIDATOR_VERSION=latest
export INPUT_VERBOSITY=1

# Load BATS extensions (installed in ./tests/Dockerfile)
load "${BATS_TEST_HELPERS}/bats-support/load.bash"
load "${BATS_TEST_HELPERS}/bats-assert/load.bash"
