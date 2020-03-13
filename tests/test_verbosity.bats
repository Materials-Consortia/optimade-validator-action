#!/usr/bin/env bats

load 'test_fixtures'

@test "Default verbosity" {
    VERBOSITY_DEFAULT=${INPUT_VERBOSITY}  # Use value from 'test_fixtures.bash'
    run ../entrypoint.sh
    assert_output --partial "Using verbosity level: ${VERBOSITY_DEFAULT}"
}

@test "verbosity=0" {
    VALID_VERBOSITY_VALUE=0
    export INPUT_VERBOSITY=${VALID_VERBOSITY_VALUE}
    run ../entrypoint.sh
    assert_output --partial "Using verbosity level: ${VALID_VERBOSITY_VALUE}"
}

@test "verbosity='test' (invalid value, should use default instead)" {
    INVALID_VERBOSITY_VALUE=test
    VERBOSITY_DEFAULT=${INPUT_VERBOSITY}  # Use value from 'test_fixtures.bash'
    export INPUT_VERBOSITY=${INVALID_VERBOSITY_VALUE}
    run ../entrypoint.sh
    assert_output --partial "Non-valid input for 'verbosity': ${INVALID_VERBOSITY_VALUE}. Will use default (1)." ]
    assert_output --partial "Using verbosity level: ${VERBOSITY_DEFAULT}"
}
