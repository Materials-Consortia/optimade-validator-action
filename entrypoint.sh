#!/bin/sh

# Install OPTiMaDe Python tools
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

run_validator="optimade_validator"

if echo ${INPUT_VERBOSITY} | grep -Eq '[^0-9]'; then
    # Bad value for `verbosity`
    echo "Non-valid input for 'verbosity': ${INPUT_VERBOSITY}. Will use default (1)."
    INPUT_VERBOSITY=1
fi
echo "Using verbosity level: ${INPUT_VERBOSITY}"
run_validator="${run_validator} --verbosity ${INPUT_VERBOSITY}"

if [ -n "${INPUT_AS_TYPE}" ]; then
    echo "Validating as type: ${INPUT_AS_TYPE}"
    run_validator="${run_validator} --as_type ${INPUT_AS_TYPE}"
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

case ${INPUT_ALL_VERSIONED_PATHS} in
    y | Y | yes | Yes | YES | true | True | TRUE | on | On | ON)
        for version in '0' '0.10' '0.10.1'; do
            if [ "${INPUT_PATH}" = "/" ]; then
                sh -c "${run_validator}${INPUT_PATH}v${version}${index}"
            else
                sh -c "${run_validator}${INPUT_PATH}/v${version}${index}"
            fi
        done
        ;;
    n | N | no | No | NO | false | False | FALSE | off | Off | OFF)
        run_validator="${run_validator}${INPUT_PATH}${index}"
        sh -c "${run_validator}"
        ;;
    *)
        echo "Non-valid input for 'all versioned paths': ${INPUT_ALL_VERSIONED_PATHS}. Will use default (false)."
        run_validator="${run_validator}${INPUT_PATH}${index}"
        sh -c "${run_validator}"
        ;;
esac
