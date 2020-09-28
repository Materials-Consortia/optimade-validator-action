#!/usr/bin/env bats

load 'test_fixtures'

@test "create_output=True" {
    export INPUT_CREATE_OUTPUT=True
    run ${ENTRYPOINT_SH}
    assert_output --partial "Will create JSON output"
    assert_output --partial "Using verbosity level: -1"
    refute_output --partial "ERROR"
    refute_output --partial "Non-valid input for 'verbosity'"

    TEST_BASE_RUN_VALIDATOR="optimade-validator --json ${INPUT_PROTOCOL}://${INPUT_DOMAIN}${INPUT_PATH}"
    run cat ${DOCKER_BATS_WORKDIR}/tests/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_BASE_RUN_VALIDATOR}
run_validator: ${TEST_BASE_RUN_VALIDATOR}v1"
}

@test "create_output='test' (invalid value, should use default instead)" {
    export INPUT_CREATE_OUTPUT=test
    run ${ENTRYPOINT_SH}
    assert_output --partial "Non-valid input for 'create_output': ${INPUT_CREATE_OUTPUT}. Will use default (false)."
    assert_output --partial "Using verbosity level: ${INPUT_VERBOSITY}"
    refute_output --partial "ERROR"
    refute_output --partial "Non-valid input for 'verbosity'"

    run cat ${DOCKER_BATS_WORKDIR}/tests/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_BASE_RUN_VALIDATOR}
run_validator: ${TEST_MAJOR_RUN_VALIDATOR}"
}

@test "create_output=True (with validator_version that hasn't got the '--json' option)" {
    export INPUT_CREATE_OUTPUT=True
    export INPUT_VALIDATOR_VERSION=0.12.0
    run ${ENTRYPOINT_SH}
    assert_output --partial "create_output not supported for the chosen validator_version (${INPUT_VALIDATOR_VERSION})"
    assert_output --partial "Using verbosity level: 1"
    refute_output --partial "Will create JSON output"
    refute_output --partial "Using verbosity level: -1"
    refute_output --partial "ERROR"
    refute_output --partial "Non-valid input for 'verbosity'"

    run cat ${DOCKER_BATS_WORKDIR}/tests/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_BASE_RUN_VALIDATOR}
run_validator: ${TEST_MAJOR_RUN_VALIDATOR}"
}
