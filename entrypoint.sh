#!/usr/bin/env bash

# Install OPTIMADE Python tools
if [ "${INPUT_VALIDATOR_VERSION}" = "latest" ]; then
    echo "Installing latest version of optimade"
    python -m pip install --no-cache -U --upgrade-strategy=eager optimade
elif echo ${INPUT_VALIDATOR_VERSION} | grep -Eq '^[0-9]\.[0-9]\.[0-9]$'; then
    echo "Installing version ${INPUT_VALIDATOR_VERSION} of optimade"
    python -m pip install --no-cache optimade==$1
elif echo ${INPUT_VALIDATOR_VERSION} | grep -Eq '^v[0-9]\.[0-9]\.[0-9]$'; then
    OPTIMADE_VERSION=$(echo ${INPUT_VALIDATOR_VERSION} | cut -c 2-)
    echo "Installing version ${OPTIMADE_VERSION} of optimade"
    python -m pip install --no-cache optimade==${OPTIMADE_VERSION}
else
    echo "Installing branch, tag or commit ${INPUT_VALIDATOR_VERSION} of optimade (from GitHub)"
    python -m pip install --no-cache "https://github.com/Materials-Consortia/optimade-python-tools/tarball/${INPUT_VALIDATOR_VERSION}"
fi

# Retrieve and add GitHub Actions host runner IP to known hosts
DOCKER_HOST_IP=$(cat /docker_host_ip)
echo ${DOCKER_HOST_IP} gh_actions_host >> /etc/hosts

run_validator="optimade-validator"

if echo ${INPUT_VERBOSITY} | grep -Eq '[^0-9]'; then
    # Bad value for `verbosity`
    echo "Non-valid input for 'verbosity': ${INPUT_VERBOSITY}. Will use default (1)."
    INPUT_VERBOSITY=1
fi
echo "Using verbosity level: ${INPUT_VERBOSITY}"

i=0
while [[ $i -lt $INPUT_VERBOSITY ]]
do
    run_validator="${run_validator} -v"
    ((i = i + 1))
done

if [ -n "${INPUT_AS_TYPE}" ]; then
    echo "Validating as type: ${INPUT_AS_TYPE}"
    run_validator="${run_validator} --as-type ${INPUT_AS_TYPE}"
fi

if [ -n "${INPUT_SKIP_OPTIONAL}" ]; then
    echo "Skipping optional tests."
    run_validator="${run_validator} --skip-optional"
fi

if [ -n "${INPUT_FAIL_FAST}" ]; then
    echo "Will exit on first failure."
    run_validator="${run_validator} --fail-fast"
fi

if [ ! -z "${INPUT_PORT}" ]; then
    BASE_URL="${INPUT_PROTOCOL}://${INPUT_DOMAIN}:${INPUT_PORT}"
else
    BASE_URL="${INPUT_PROTOCOL}://${INPUT_DOMAIN}"
fi
run_validator="${run_validator} ${BASE_URL}"

index=""
case ${INPUT_INDEX} in
    y | Y | yes | Yes | YES | true | True | TRUE | on | On | ON)
        index=" --index"
        ;;
    n | N | no | No | NO | false | False | FALSE | off | Off | OFF)
        ;;
    *)
        echo "Non-valid input for 'index': ${INPUT_INDEX}. Will use default (false)."
        ;;
esac


API_VERSION=($(python -c "from optimade import __api_version__; versions = [__api_version__.split('-')[0].split('+')[0].split('.')[0], '.'.join(__api_version__.split('-')[0].split('+')[0].split('.')[:2]), '.'.join(__api_version__.split('-')[0].split('+')[0].split('.')[:3])]; print(' '.join(versions))"))
case ${INPUT_ALL_VERSIONED_PATHS} in
    y | Y | yes | Yes | YES | true | True | TRUE | on | On | ON)
        for version in "${API_VERSION[@]}"; do
            if [ "${INPUT_PATH}" = "/" ]; then
                # For testing
                echo "run_validator: ${run_validator}${INPUT_PATH}v${version}${index}" >> ./tests/.entrypoint-run_validator.txt
                sh -c "${run_validator}${INPUT_PATH}v${version}${index}"
            else
                # For testing
                echo "run_validator: ${run_validator}${INPUT_PATH}/v${version}${index}" >> ./tests/.entrypoint-run_validator.txt
                sh -c "${run_validator}${INPUT_PATH}/v${version}${index}"
            fi
        done
        ;;
    n | N | no | No | NO | false | False | FALSE | off | Off | OFF)
        run_validator="${run_validator}${INPUT_PATH}${index}"
        # For testing
        echo "run_validator: ${run_validator}" > ./tests/.entrypoint-run_validator.txt
        sh -c "${run_validator}"
        ;;
    *)
        echo "Non-valid input for 'all versioned paths': ${INPUT_ALL_VERSIONED_PATHS}. Will use default (false)."
        run_validator="${run_validator}${INPUT_PATH}${index}"
        # For testing
        echo "run_validator: ${run_validator}" > ./tests/.entrypoint-run_validator.txt
        sh -c "${run_validator}"
        ;;
esac
