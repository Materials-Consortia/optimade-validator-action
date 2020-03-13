#!/usr/bin/env bats

load 'test_fixtures'

@test "validator_version='latest'" {
    export INPUT_VALIDATOR_VERSION=latest
    run ../entrypoint.sh
    assert_output --partial "Installing latest version of optimade"
}

@test "validator_version='0.6.0'" {
    export INPUT_VALIDATOR_VERSION=0.6.0
    run ../entrypoint.sh
    assert_output --partial "Installing version $INPUT_VALIDATOR_VERSION of optimade"
}

@test "validator_version='v0.6.0'" {
    export INPUT_VALIDATOR_VERSION=v0.6.0
    OUTPUT_OPTIMADE_VERSION=0.6.0
    run ../entrypoint.sh
    assert_output --partial "Installing version $OUTPUT_OPTIMADE_VERSION of optimade"
}

@test "validator_version='master'" {
    export INPUT_VALIDATOR_VERSION=master
    run ../entrypoint.sh
    assert_output --partial "Installing branch, tag or commit $INPUT_VALIDATOR_VERSION of optimade (from GitHub)"
}
