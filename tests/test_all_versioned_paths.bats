#!/usr/bin/env bats

load 'test_fixtures'

@test "all versioned paths=False" {
    export INPUT_ALL_VERSIONED_PATHS=False
    run ${ENTRYPOINT_SH}
    refute_output --partial "ERROR"

    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_MAJOR_RUN_VALIDATOR}"
}

@test "all versioned paths=True" {
    export INPUT_ALL_VERSIONED_PATHS=True
    run ${ENTRYPOINT_SH}
    refute_output --partial "ERROR"

    OPTIMADE_VERSION=("v1.0" "v1.0.1")
    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_MAJOR_RUN_VALIDATOR}
run_validator: ${TEST_BASE_RUN_VALIDATOR}${OPTIMADE_VERSION[0]}
run_validator: ${TEST_BASE_RUN_VALIDATOR}${OPTIMADE_VERSION[1]}"
}

@test "all versioned paths=True & validate unversioned path=True" {
    export INPUT_ALL_VERSIONED_PATHS=True INPUT_VALIDATE_UNVERSIONED_PATH=True
    run ${ENTRYPOINT_SH}
    refute_output --partial "ERROR"

    OPTIMADE_VERSION=("v1.0" "v1.0.1")
    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_BASE_RUN_VALIDATOR}
run_validator: ${TEST_MAJOR_RUN_VALIDATOR}
run_validator: ${TEST_BASE_RUN_VALIDATOR}${OPTIMADE_VERSION[0]}
run_validator: ${TEST_BASE_RUN_VALIDATOR}${OPTIMADE_VERSION[1]}"
}


@test "all versioned paths=invalid_value" {
    # For an invalid value, it should fallback to the default (false)
    export INPUT_ALL_VERSIONED_PATHS=invalid_value
    run ${ENTRYPOINT_SH}
    refute_output --partial "ERROR"
    assert_output --partial "Non-valid input for 'all versioned paths': ${INPUT_ALL_VERSIONED_PATHS}. Will use default (false)."

    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_MAJOR_RUN_VALIDATOR}"
}

@test "all versioned paths=True for old spec v0.10.1" {
    # Unfortunately, we cannot test the correct parsing of `__api_version__`,
    # since we do not support OPTIMADE Python tools versions < 0.10.0.
    # The change from __api_version__ 1.0.0-rc1 to 1.0.0 happened for version 0.9.7.
    # This test will be kept here to be implemented later when/if the OPTIMADE API
    # specification moves to a version > 1.0.0 (as long as it's still supported).
    skip "Update when specification version > 1.0.0 is released and used in OPTIMADE Python tools."
    # Use OPTIMADE Python tools commit immediately prior to updating to
    # OPTIMADE specification v1.0.0-rc2.
    # The supported OPTIMADE specification version prior to v1.0.0-rc2 was v0.10.1.
    export INPUT_ALL_VERSIONED_PATHS=True
    export INPUT_VALIDATOR_VERSION=ad68951fc6089402392c6299e8206d19a570d060
    run ${ENTRYPOINT_SH}
    refute_output --partial "ERROR"

    OPTIMADE_VERSION=("v0" "v0.10" "v0.10.1")
    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_BASE_RUN_VALIDATOR}${OPTIMADE_VERSION[0]}
run_validator: ${TEST_BASE_RUN_VALIDATOR}${OPTIMADE_VERSION[1]}
run_validator: ${TEST_BASE_RUN_VALIDATOR}${OPTIMADE_VERSION[2]}"
}
