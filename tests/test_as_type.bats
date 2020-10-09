#!/usr/bin/env bats

load 'test_fixtures'

@test "Default as_type (general run with all defaults)" {
    # There isn't a default for as_type, so it shouldn't result in --as-type being set
    run ${ENTRYPOINT_SH}
    refute_output --partial "Validating as type: "
    refute_output --partial "ERROR"

    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_BASE_RUN_VALIDATOR}
run_validator: ${TEST_MAJOR_RUN_VALIDATOR}"
}

@test "as_type='structure'" {
    VALID_AS_TYPE_VALUE=structure
    export INPUT_AS_TYPE=${VALID_AS_TYPE_VALUE}
    run ${ENTRYPOINT_SH}
    assert_output --partial "Validating as type: ${VALID_AS_TYPE_VALUE}"
    refute_output --partial "ERROR"

    TEST_BASE_RUN_VALIDATOR="optimade-validator $( for i in {1..${INPUT_VERBOSITY}}; do echo '-v '; done; )--as-type ${VALID_AS_TYPE_VALUE} ${INPUT_PROTOCOL}://${INPUT_DOMAIN}${INPUT_PATH}"
    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_BASE_RUN_VALIDATOR}
run_validator: ${TEST_BASE_RUN_VALIDATOR}v1"
}

@test "as_type='non_valid_input' (invalid value, should fail with status 1 and message)" {
    INVALID_AS_TYPE_VALUE=non_valid_input
    export INPUT_AS_TYPE=${INVALID_AS_TYPE_VALUE}
    # Don't use real entrypoint.sh here, since the error code comes from running the validator.
    run ${ENTRYPOINT_SH}
    assert_output --partial "Validating as type: ${INVALID_AS_TYPE_VALUE}"
    assert_failure 1
    assert_output --partial "${INVALID_AS_TYPE_VALUE} is not a valid type, must be one of "

    TEST_BASE_RUN_VALIDATOR="optimade-validator $( for i in {1..${INPUT_VERBOSITY}}; do echo '-v '; done; )--as-type ${INVALID_AS_TYPE_VALUE} ${INPUT_PROTOCOL}://${INPUT_DOMAIN}${INPUT_PATH}"
    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_BASE_RUN_VALIDATOR}
run_validator: ${TEST_BASE_RUN_VALIDATOR}v1"
}
