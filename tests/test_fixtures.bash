# Set workdir to Docker default if not set already
if [ -z "${DOCKER_BATS_WORKDIR}" ]; then
    if [ -n "${CI}" ]; then
        export DOCKER_BATS_WORKDIR=${GITHUB_WORKSPACE}
    else
        export DOCKER_BATS_WORKDIR=/code
    fi
fi

# Load BATS extensions (installed in ./tests/Dockerfile)
if [ -z "${BATS_LIB_PATH}" ]; then
    export BATS_LIB_PATH=${BATS_TEST_HELPERS}
fi
bats_load_library bats-support
bats_load_library bats-assert

function setup() {
    # Set all input parameter defaults
    export INPUT_ALL_VERSIONED_PATHS=false
    export INPUT_VALIDATE_UNVERSIONED_PATH=false
    export INPUT_DOMAIN=gh_actions_host
    export INPUT_FAIL_FAST=false
    export INPUT_INDEX=false
    export INPUT_CREATE_OUTPUT=false
    export INPUT_PATH=/
    export INPUT_PROTOCOL=http
    export INPUT_SKIP_OPTIONAL=false
    export INPUT_MINIMAL=false
    export INPUT_VALIDATOR_VERSION=latest
    export INPUT_VERBOSITY=1

    # Validator runs executed (with defaults)
    export TEST_BASE_RUN_VALIDATOR="optimade-validator -v ${INPUT_PROTOCOL}://${INPUT_DOMAIN}${INPUT_PATH}"
    export TEST_MAJOR_RUN_VALIDATOR="${TEST_BASE_RUN_VALIDATOR}v1"

    # Clean "cache"
    rm -f ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
}

function teardown() {
    rm -f ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
}
