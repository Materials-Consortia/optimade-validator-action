## Setup suite (setup/teardown) to run before all files and tests

# Set workdir to Docker default if not set already
if [ -z "${DOCKER_BATS_WORKDIR}" ]; then
    export DOCKER_BATS_WORKDIR=/code
fi

# Absolute path to entrypoint.sh
export REAL_ENTRYPOINT_SH=${DOCKER_BATS_WORKDIR}/entrypoint.sh
export ENTRYPOINT_SH=${DOCKER_BATS_WORKDIR}/tests/.entrypoint.sh

function setup_suite() {
    # Clean up any previous test entrypoint.sh
    rm -f ${ENTRYPOINT_SH}

    # Create BATS test entrypoint.sh at ${ENTRYPOINT_SH}
    while IFS="" read -r line || [ -n "${line}" ]; do
        if [[ "${line}" =~ ^set[[:blank:]]-e$ ]]; then
            # Comment out "set -e" from entrypoint.sh in a new test entrypoint.sh
            line="# ${line}"
        fi
        if [[ "${line}" =~ ^.*helper\.py.*$ ]]; then
            line="${line/\/helper\.py/helper.py}"
        fi
        printf "%s\n" "${line}" >> ${ENTRYPOINT_SH}
    done < ${REAL_ENTRYPOINT_SH}
    chmod +x ${ENTRYPOINT_SH}
}

function teardown_suite() {
    rm -f ${ENTRYPOINT_SH}
}
