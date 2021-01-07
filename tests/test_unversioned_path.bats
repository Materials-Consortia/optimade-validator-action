#!/usr/bin/env bats

load 'test_fixtures'

@test "validate_unversioned_path=False" {
    export INPUT_VALIDATE_UNVERSIONED_PATH=False
    run ${ENTRYPOINT_SH}
    refute_output --partial "ERROR"

    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_BASE_RUN_VALIDATOR}
run_validator: ${TEST_MAJOR_RUN_VALIDATOR}"
}

@test "validate_unversioned_path=True" {
    export INPUT_VALIDATE_UNVERSIONED_PATH=True
    run ${ENTRYPOINT_SH}
    refute_output --partial "ERROR"

    OPTIMADE_VERSION=("v1.0" "v1.0.0")
    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_BASE_RUN_VALIDATOR}
run_validator: ${TEST_BASE_RUN_VALIDATOR}
run_validator: ${TEST_MAJOR_RUN_VALIDATOR}
}

@test "validate_unversioned_path=invalid_value" {
    # For an invalid value, it should fallback to the default (false)
    export INPUT_VALIDATE_UNVERSIONED_PATH=invalid_value
    run ${ENTRYPOINT_SH}
    refute_output --partial "ERROR"

    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_BASE_RUN_VALIDATOR}
run_validator: ${TEST_MAJOR_RUN_VALIDATOR}"
}
