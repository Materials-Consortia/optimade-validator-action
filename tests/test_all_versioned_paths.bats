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

    OPTIMADE_VERSION=("v1.1" "v1.1.0")
    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_MAJOR_RUN_VALIDATOR}
run_validator: ${TEST_BASE_RUN_VALIDATOR}${OPTIMADE_VERSION[0]}
run_validator: ${TEST_BASE_RUN_VALIDATOR}${OPTIMADE_VERSION[1]}"
}

@test "all versioned paths=True & validate unversioned path=True" {
    export INPUT_ALL_VERSIONED_PATHS=True INPUT_VALIDATE_UNVERSIONED_PATH=True
    run ${ENTRYPOINT_SH}
    refute_output --partial "ERROR"

    OPTIMADE_VERSION=("v1.1" "v1.1.0")
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
    # Use OPTIMADE Python tools v0.15.5 with OPTIMADE API v1.0.1.
    # In v0.16.0 the OPTIMADE API was updated to v1.1.0.
    export INPUT_ALL_VERSIONED_PATHS=True
    export INPUT_VALIDATOR_VERSION=v0.15.5
    run ${ENTRYPOINT_SH}
    refute_output --partial "ERROR"

    OPTIMADE_VERSION=("v1" "v1.0" "v1.0.1")
    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_BASE_RUN_VALIDATOR}${OPTIMADE_VERSION[0]}
run_validator: ${TEST_BASE_RUN_VALIDATOR}${OPTIMADE_VERSION[1]}
run_validator: ${TEST_BASE_RUN_VALIDATOR}${OPTIMADE_VERSION[2]}"
}
