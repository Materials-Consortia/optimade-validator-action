load 'test_fixtures'

@test "validator_version='latest'" {
    export INPUT_VALIDATOR_VERSION=latest
    run ${ENTRYPOINT_SH}
    assert_output --partial "Installing latest version of optimade"
    refute_output --partial "ERROR"

    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_MAJOR_RUN_VALIDATOR}"
}

@test "validator_version='0.10.0'" {
    export INPUT_VALIDATOR_VERSION=0.10.0
    run ${ENTRYPOINT_SH}
    assert_output --partial "Installing version $INPUT_VALIDATOR_VERSION of optimade"
    refute_output --partial "ERROR"

    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_MAJOR_RUN_VALIDATOR}"
}

@test "validator_version='v0.10.0'" {
    export INPUT_VALIDATOR_VERSION=v0.10.0
    OUTPUT_OPTIMADE_VERSION=0.10.0
    run ${ENTRYPOINT_SH}
    assert_output --partial "Installing version $OUTPUT_OPTIMADE_VERSION of optimade"
    refute_output --partial "ERROR"

    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_MAJOR_RUN_VALIDATOR}"
}

@test "validator_version='master'" {
    export INPUT_VALIDATOR_VERSION=master
    run ${ENTRYPOINT_SH}
    assert_output --partial "Installing branch, tag or commit $INPUT_VALIDATOR_VERSION of optimade (from GitHub)"
    refute_output --partial "ERROR"

    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_MAJOR_RUN_VALIDATOR}"
}

@test "validator_version='0.0.0' (invalid value, should fail with status 1 and message)" {
    export INPUT_VALIDATOR_VERSION=0.0.0
    # For this test `set -e` is necessary, since this is what we are testing
    run ${REAL_ENTRYPOINT_SH}
    assert_output --partial "Installing version $INPUT_VALIDATOR_VERSION of optimade"
    assert_failure 1
    assert_output --partial "ERROR"

    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output --partial "No such file or directory"
}

@test "validator_version='0.9.0' (version too old, should fail with status 1 and message)" {
    export INPUT_VALIDATOR_VERSION=0.9.0
    run ${ENTRYPOINT_SH}
    assert_output --partial "Incompatible validator version requested ${INPUT_VALIDATOR_VERSION}, please use >=0.10."
    assert_failure 1
    refute_output --partial "ERROR"  # This checks if pip fails, it should not

    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output --partial "No such file or directory"
}

@test "validator_version='v0.9.0' (version too old, should fail with status 1 and message)" {
    export INPUT_VALIDATOR_VERSION=v0.9.0
    run ${ENTRYPOINT_SH}
    assert_output --partial "Incompatible validator version requested ${INPUT_VALIDATOR_VERSION}, please use >=0.10."
    assert_failure 1
    refute_output --partial "ERROR"  # This checks if pip fails, it should not

    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output --partial "No such file or directory"
}

@test "validator_version='ad68951fc6089402392c6299e8206d19a570d060' (version too old (0.8.1), should fail with status 1 and message)" {
    export INPUT_VALIDATOR_VERSION=ad68951fc6089402392c6299e8206d19a570d060
    run ${ENTRYPOINT_SH}
    assert_output --partial "Incompatible validator version requested ${INPUT_VALIDATOR_VERSION}, please use >=0.10."
    assert_failure 1
    refute_output --partial "ERROR"  # This checks if pip fails, it should not

    run cat ${DOCKER_BATS_WORKDIR}/.entrypoint-run_validator.txt
    assert_output --partial "No such file or directory"
}
