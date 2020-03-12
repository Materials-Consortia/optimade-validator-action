#!/usr/bin/env bats

@test "Test passing 'latest' works" {
    export INPUT_VALIDATOR_VERSION=latest
    run ../entrypoint.sh
    [ "${lines[0]}" = "Installing latest version of optimade" ]
}

@test "Test passing valid version" {
    export INPUT_VALIDATOR_VERSION=0.6.0
    run ../entrypoint.sh
    [ "${lines[0]}" = "Installing version $INPUT_VALIDATOR_VERSION of optimade" ]
}

@test "Test passing valid version prefixed with 'v'" {
    export INPUT_VALIDATOR_VERSION=v0.6.0
    OUTPUT_OPTIMADE_VERSION=0.6.0
    run ../entrypoint.sh
    [ "${lines[0]}" = "Installing version $OUTPUT_OPTIMADE_VERSION of optimade" ]
}

@test "Test passing branch" {
    export INPUT_VALIDATOR_VERSION=master
    run ../entrypoint.sh
    [ "${lines[0]}" = "Installing branch, tag or commit $INPUT_VALIDATOR_VERSION of optimade (from GitHub)" ]
}
