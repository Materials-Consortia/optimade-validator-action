#!/usr/bin/env bash
set -e

# Install OPTIMADE Python tools
if [ "${INPUT_VALIDATOR_VERSION}" = "latest" ]; then
    echo "Installing latest version of optimade"
    python -m pip install --no-cache -U --upgrade-strategy=eager optimade
elif echo ${INPUT_VALIDATOR_VERSION} | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    echo "Installing version ${INPUT_VALIDATOR_VERSION} of optimade"
    python -m pip install --no-cache -U optimade==${INPUT_VALIDATOR_VERSION}
elif echo ${INPUT_VALIDATOR_VERSION} | grep -Eq '^v[0-9]+\.[0-9]+\.[0-9]+$'; then
    OPTIMADE_VERSION=$(echo ${INPUT_VALIDATOR_VERSION} | cut -c 2-)
    echo "Installing version ${OPTIMADE_VERSION} of optimade"
    python -m pip install --no-cache -U optimade==${OPTIMADE_VERSION}
else
    echo "Installing branch, tag or commit ${INPUT_VALIDATOR_VERSION} of optimade (from GitHub)"
    python -m pip install --no-cache -U "https://github.com/Materials-Consortia/optimade-python-tools/tarball/${INPUT_VALIDATOR_VERSION}"
fi

# Check optimade-python-tools version is >0.10
PACKAGE_VERSION=($(python -c "from optimade import __version__; print(__version__.replace('.', ' '))"))

if [ ${PACKAGE_VERSION[0]} -eq 0 ] && [ ${PACKAGE_VERSION[1]} -lt 10 ]; then
    echo "Incompatible validator version requested ${INPUT_VALIDATOR_VERSION}, please use >=0.10."
    exit 1
fi

# Retrieve and add GitHub Actions host runner IP to known hosts
DOCKER_HOST_IP=$(cat /docker_host_ip)
echo ${DOCKER_HOST_IP} gh_actions_host >> /etc/hosts

run_validator="optimade-validator"

case ${INPUT_CREATE_OUTPUT} in
    y | Y | yes | Yes | YES | true | True | TRUE | on | On | ON)
        echo "Will create JSON output, retrievable through '\${{ steps.<step_id>.outputs.results }}'."
        echo "Verbosity level will be reset to '-1'."
        run_validator="${run_validator} --json"
        INPUT_VERBOSITY=-1
        ;;
    n | N | no | No | NO | false | False | FALSE | off | Off | OFF)
        ;;
    *)
        echo "Non-valid input for 'create_output': ${INPUT_CREATE_OUTPUT}. Will use default (false)."
        ;;
esac

if echo ${INPUT_VERBOSITY} | grep -Eq -e '[^-?0-9]'; then
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

case ${INPUT_SKIP_OPTIONAL} in
    y | Y | yes | Yes | YES | true | True | TRUE | on | On | ON)
        echo "Skipping optional tests."
        run_validator="${run_validator} --skip-optional"
        ;;
    n | N | no | No | NO | false | False | FALSE | off | Off | OFF)
        ;;
    *)
        echo "Non-valid input for 'skip_optional': ${INPUT_SKIP_OPTIONAL}. Will use default (false)."
        ;;
esac

case ${INPUT_FAIL_FAST} in
    y | Y | yes | Yes | YES | true | True | TRUE | on | On | ON)
        echo "Will exit on first failure."
        run_validator="${run_validator} --fail-fast"
        ;;
    n | N | no | No | NO | false | False | FALSE | off | Off | OFF)
        ;;
    *)
        echo "Non-valid input for 'fail_fast': ${INPUT_FAIL_FAST}. Will use default (false)."
        ;;
esac

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

# Run validator for unversioned base URL
# Echo line is for testing
echo "run_validator: ${run_validator}${INPUT_PATH}${index}" > ./tests/.entrypoint-run_validator.txt
sh -c "${run_validator}${INPUT_PATH}${index}" | tee -p exit-nopipe "unversioned.json"

# Run validator for versioned base URL(s)
if [ "${INPUT_PATH}" = "/" ]; then
    filler="v"
else
    filler="/v"
fi
API_VERSION=($(python -c "from optimade import __api_version__; versions = [__api_version__.split('-')[0].split('+')[0].split('.')[0], '.'.join(__api_version__.split('-')[0].split('+')[0].split('.')[:2]), '.'.join(__api_version__.split('-')[0].split('+')[0].split('.')[:3])]; print(' '.join(versions))"))
case ${INPUT_ALL_VERSIONED_PATHS} in
    y | Y | yes | Yes | YES | true | True | TRUE | on | On | ON)
        for version in "${API_VERSION[@]}"; do
            run_validator_version="${run_validator}${INPUT_PATH}${filler}${version}${index}"
            # Echo line is for testing
            echo "run_validator: ${run_validator_version}" >> ./tests/.entrypoint-run_validator.txt
            sh -c "${run_validator_version}" | tee "v${version}.json"
        done
        ;;
    n | N | no | No | NO | false | False | FALSE | off | Off | OFF)
        run_validator="${run_validator}${INPUT_PATH}${filler}${API_VERSION[0]}${index}"
        # Echo line is for testing
        echo "run_validator: ${run_validator}" >> ./tests/.entrypoint-run_validator.txt
        sh -c "${run_validator}" | tee "v${API_VERSION[0]}.json"
        ;;
    *)
        echo "Non-valid input for 'all versioned paths': ${INPUT_ALL_VERSIONED_PATHS}. Will use default (false)."
        run_validator="${run_validator}${INPUT_PATH}${filler}${API_VERSION[0]}${index}"
        # Echo line is for testing
        echo "run_validator: ${run_validator}" >> ./tests/.entrypoint-run_validator.txt
        sh -c "${run_validator}" | tee "v${API_VERSION[0]}.json"
        ;;
esac

# Create output 'results'
RESULTS=$(python helper.py results)
# First echo line is for testing
echo "results: ${RESULTS}"
echo "::set-output name=results::${RESULTS}"
