#!/usr/bin/env bats

load 'test_fixtures'

@test "validator_version='latest'" {
    export INPUT_VALIDATOR_VERSION=latest
    run ${ENTRYPOINT_SH}
    assert_output --partial "Installing latest version of optimade"

    run cat ${DOCKER_BATS_WORKDIR}/tests/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_FINAL_RUN_VALIDATOR}"
}

@test "validator_version='0.6.0'" {
    export INPUT_VALIDATOR_VERSION=0.6.0
    run ${ENTRYPOINT_SH}
    assert_output --partial "Installing version $INPUT_VALIDATOR_VERSION of optimade"

    run cat ${DOCKER_BATS_WORKDIR}/tests/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_FINAL_RUN_VALIDATOR}"
}

@test "validator_version='v0.6.0'" {
    export INPUT_VALIDATOR_VERSION=v0.6.0
    OUTPUT_OPTIMADE_VERSION=0.6.0
    run ${ENTRYPOINT_SH}
    assert_output --partial "Installing version $OUTPUT_OPTIMADE_VERSION of optimade"

    run cat ${DOCKER_BATS_WORKDIR}/tests/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_FINAL_RUN_VALIDATOR}"
}

@test "validator_version='master'" {
    export INPUT_VALIDATOR_VERSION=master
    run ${ENTRYPOINT_SH}
    assert_output --partial "Installing branch, tag or commit $INPUT_VALIDATOR_VERSION of optimade (from GitHub)"

    run cat ${DOCKER_BATS_WORKDIR}/tests/.entrypoint-run_validator.txt
    assert_output "run_validator: ${TEST_FINAL_RUN_VALIDATOR}"
}
