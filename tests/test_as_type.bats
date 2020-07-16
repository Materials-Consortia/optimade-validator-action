#!/usr/bin/env bats

load 'test_fixtures'

@test "Default as_type" {
    # There isn't a default for as_type, so it shouldn't result in --as_type being set
    run ${ENTRYPOINT_SH}
    refute_output --partial "Validating as type: "

    TEST_FINAL_RUN_VALIDATOR=default
}

@test "as_type='structure'" {
    VALID_AS_TYPE_VALUE=structure
    export INPUT_AS_TYPE=${VALID_AS_TYPE_VALUE}
    run ${ENTRYPOINT_SH}
    assert_output --partial "Validating as type: ${VALID_AS_TYPE_VALUE}"

    TEST_FINAL_RUN_VALIDATOR="optimade_validator --verbosity ${INPUT_VERBOSITY} --as-type ${VALID_AS_TYPE_VALUE} ${INPUT_PROTOCOL}://${INPUT_DOMAIN}${INPUT_PATH}"
}

@test "as_type='non_valid_input' (invalid value, should fail with status 1 and message)" {
    INVALID_AS_TYPE_VALUE=non_valid_input
    export INPUT_AS_TYPE=${INVALID_AS_TYPE_VALUE}
    run ${ENTRYPOINT_SH}
    assert_output --partial "Validating as type: ${INVALID_AS_TYPE_VALUE}"
    assert_failure 1
    assert_output --partial "${INVALID_AS_TYPE_VALUE} is not a valid type, must be one of "

    TEST_FINAL_RUN_VALIDATOR="optimade_validator --verbosity ${INPUT_VERBOSITY} --as-type ${INVALID_AS_TYPE_VALUE} ${INPUT_PROTOCOL}://${INPUT_DOMAIN}${INPUT_PATH}"
}
