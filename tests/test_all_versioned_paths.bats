#!/usr/bin/env bats

load 'test_fixtures'

@test "all_versioned_paths=False" {
    export INPUT_ALL_VERSIONED_PATHS=False
    run ${ENTRYPOINT_SH}
    refute_output --partial "ERROR"

    run cat ${DOCKER_BATS_WORKDIR}/tests/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_BASE_RUN_VALIDATOR}
run_validator: ${TEST_MAJOR_RUN_VALIDATOR}"
}

@test "all_versioned_paths=True" {
    export INPUT_ALL_VERSIONED_PATHS=True
    run ${ENTRYPOINT_SH}
    refute_output --partial "ERROR"

    OPTIMADE_VERSION=("v1.0" "v1.0.0")
    run cat ${DOCKER_BATS_WORKDIR}/tests/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_BASE_RUN_VALIDATOR}
run_validator: ${TEST_MAJOR_RUN_VALIDATOR}
run_validator: ${TEST_BASE_RUN_VALIDATOR}${OPTIMADE_VERSION[0]}
run_validator: ${TEST_BASE_RUN_VALIDATOR}${OPTIMADE_VERSION[1]}"
}

@test "all_versioned_paths=invalid_value" {
    # For an invalid value, it should fallback to the default (false)
    export INPUT_ALL_VERSIONED_PATHS=invalid_value
    run ${ENTRYPOINT_SH}
    refute_output --partial "ERROR"

    run cat ${DOCKER_BATS_WORKDIR}/tests/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_BASE_RUN_VALIDATOR}
run_validator: ${TEST_MAJOR_RUN_VALIDATOR}"
}

@test "all_versioned_paths=True for old spec v0.10.1" {
    # Use OPTIMADE Python tools commit immediately prior to updating to
    # OPTIMADE specification v1.0.0-rc2.
    # The supported OPTIMADE specification version prior to v1.0.0-rc2 was v0.10.1.
    export INPUT_ALL_VERSIONED_PATHS=True
    export INPUT_VALIDATOR_VERSION=ad68951fc6089402392c6299e8206d19a570d060
    run ${ENTRYPOINT_SH}
    refute_output --partial "ERROR"

    OPTIMADE_VERSION=("v0" "v0.10" "v0.10.1")
    run cat ${DOCKER_BATS_WORKDIR}/tests/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_BASE_RUN_VALIDATOR}
run_validator: ${TEST_BASE_RUN_VALIDATOR}${OPTIMADE_VERSION[0]}
run_validator: ${TEST_BASE_RUN_VALIDATOR}${OPTIMADE_VERSION[1]}
run_validator: ${TEST_BASE_RUN_VALIDATOR}${OPTIMADE_VERSION[2]}"
}
