load 'test_fixtures'

@test "minimal=true" {
    export INPUT_MINIMAL="true"
    run ${ENTRYPOINT_SH}
    assert_output --partial "Running a minimal test set"
    refute_output --partial "ERROR"
    refute_output --partial "Non-valid input for 'minimal'"

    TEST_BASE_RUN_VALIDATOR="optimade-validator -v --minimal ${INPUT_PROTOCOL}://${INPUT_DOMAIN}${INPUT_PATH}"
    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_BASE_RUN_VALIDATOR}v1"
}

@test "minimal=invalid" {
    export INPUT_MINIMAL="invalid"
    run ${ENTRYPOINT_SH}
    assert_output --partial "Non-valid input for 'minimal': ${INPUT_MINIMAL}. Will use default (false)."

    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_MAJOR_RUN_VALIDATOR}"
}
