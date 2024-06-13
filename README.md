<!-- markdownlint-disable MD033 -->
# GitHub Action - OPTIMADE validator

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-v2-undefined.svg?logo=github&logoColor=white&style=flat)](https://github.com/marketplace/actions/optimade-validator)

This action runs `optimade-validator` from the `optimade` package found in the [`optimade-python-tools` repository](https://github.com/Materials-Consortia/optimade-python-tools) on either a locally running server or a public server.

All minor and patch updates to v2 will be folded into the `v2` tag, so that using the action `@v2` is recommended, since it results in using the latest v2.minor.patch.

Latest versions:

| Used tag | Effective version |
| :---: | :---: |
| `v2` | [`v2.7.0`](https://github.com/Materials-Consortia/optimade-validator-action/releases/tag/v2.7.0) |
| `v1` | [`v1.2.0`](https://github.com/Materials-Consortia/optimade-validator-action/releases/tag/v1.2.0) |

## Example usage

To run `optimade-validator` for an index meta-database at `http://gh_actions_host:5001/` do the following:  
Within the same job, first, start a server, e.g., using the [`ghcr.io/materials-consortia/optimade` container image](https://github.com/Materials-Consortia/optimade-python-tools/pkgs/container/optimade) as a service, and then add the step

```yml
uses: Materials-Consortia/optimade-validator-action@v2
with:
  port: 5001
  path: /
  index: yes
```

> **Note**: The service should be used with a set `OPTIMADE_BASE_URL`:
>
> ```yml
> services:
>   optimade_index:
>     image: ghcr.io/materials-consortia/optimade
>     ports:
>       - 5001:5000
>     env:
>       OPTIMADE_BASE_URL: http://gh_actions_host:5001
> ```

To run `optimade-validator` for a regular OPTIMADE _deployed_ implementation, testing all possible versioned base URLs, for example:

- `https://example.org:443/optimade/example/v1`
- `https://example.org:443/optimade/example/v1.0`
- `https://example.org:443/optimade/example/v1.0.0`

```yml
uses: Materials-Consortia/optimade-validator-action@v2
with:
  protocol: https
  domain: example.org
  port: 443
  path: /optimade/example
  all versioned paths: True
```

> **Note**: This will also run `optimade-validator` for the unversioned base URL.

By default, the validator follows the [OPTIMADE specification](https://github.com/Materials-Consortia/OPTIMADE/blob/master/optimade.rst).
This means it will always check the mandatory base URLs:

- Unversioned base URL (`/`)
- Major-versioned base URL (`/vMAJOR`, e.g. `/v1`)

The major version number will be determined based on the validator version used, i.e., the supported OPTIMADE API version in the [OPTIMADE Python tools repository](https://github.com/Materials-Consortia/optimade-python-tools/blob/master/optimade/__init__.py#L2).
This can be chosen using the input `validator version`.

## Inputs

| Input | Description | Usage | Default | Action version |
| :---: |    :---     | :---: |  :---:  |      :---:     |
| `all versioned paths` | Whether to test the optional versioned base URLs:<br><br>/vMAJOR<br>/vMAJOR.MINOR<br>/vMAJOR.MINOR.PATCH<br><br>If `false`, only the mandatory /vMAJOR URL will be tested. | Optional | `false` | `v1+` |
| `validate unversioned path` | Whether to validate the input URL as a full OPTIMADE implementation without appending any version.<br><br>This action assumes that the 'path' parameter will contain an unversioned URL. As it is not mandatory to run a full OPTIMADE implementation from the unversioned URL, by default, this action will not perform any validation of this URL, beyond checking the mandatory `/versions` endpoint. | Optional | `false` | `v2.3+` |
| `as type` | Validate the request URL with the provided type, rather than scanning the entire implementation.<br>Example values: `structures`, `reference`. For a full list of values see the [OPTIMADE Python tools documentation](https://www.optimade.org/optimade-python-tools/api_reference/validator/validator/#optimade.validator.validator.ImplementationValidator.__init__).<br>It is expected that `path` points to the exact endpoint to be validated. You must include any versions or similar if desired, as the `path` will be used as given.<br>**NB**: This input takes precedence over `all versioned paths`, `validate unversioned path`, and `index`, meaning these will be _ignored_ if `as type` is defined. | Optional | - | `v1+` |
| `domain` | Domain for the OPTIMADE URL (defaults to the GitHub Actions runner host). | Optional | `gh_actions_host` | `v1+` |
| `fail fast` | Whether or not to exit and return a non-zero error code on first failure. | Optional | `false` | `v2+` |
| `index` | Whether or not this is an index meta-database. | Optional | `false` | `v1+` |
| `path` | Path to append to the domain to reach the OPTIMADE unversioned base URL - MUST start with `/`.<br>The path MUST NOT include the versioned part of the base URL. Rather, it MUST point to the unversioned base URL of your OPTIMADE implementation (**except** if `as type` is defined, then `path` should define the full path to the endpoint to be validated, including also the versioned part if desired, e.g., `/v1.0/structures`). | Optional | `/` | `v1+` |
| `port` | Port for the OPTIMADE URL. | Optional | `5000` | `v1+` |
| `protocol` | Protocol for the OPTIMADE URL. | Optional | `http` | `v1+` |
| `skip optional` | Whether or not to skip tests for optional features. | Optional | `false` | `v2+` |
| `minimal` | Whether or not to reduce the validation to a minimal test set that only checks responses and not filters. | Optional | `false` | `v2.4.1+` |
| `validator version` | Full version of an OPTIMADE Python tools release to PyPI, e.g., `'v0.6.0'` or `'0.3.4'`, which hosts the `optimade-validator`. It can also be a branch, tag, or git commit to use from the GitHub repository, e.g., `'master'` or `'5a5e903'`.<br>See [the pip documentation](https://pip.pypa.io/en/latest/reference/pip_install/#git) for more information of what is allowed here.<br>Finally, it may also be `'latest'` (default), which is understood to be the latest official release of the `optimade` package on PyPI.<br>Note, for the latest development version, choose `'master'`. | **Required** | `latest` | `v1+` |
| `verbosity` | The verbosity of the output.<br>`0`: minimalistic, `1`: informational, `2`+: debug | Optional | `1` | `v1+` |

## Running test suite (developers)

The test suite is based on [BATS](https://github.com/bats-core/bats-core) and should be run in [Docker](https://github.com/bats-core/bats-core#running-bats-in-docker).
The reason to run in Docker, is that the `entrypoint.sh` file will install the `optimade` package.
And to not pollute your local environment, it is safer to run it in a Docker container.

Furthermore, for each test run, the `optimade` package will be installed in a virtual environment within the Docker file, since changing the `optimade` version is part of the test suite.

Steps to setup your test environment:

1. Git clone this repository to your local environment
1. Install Docker (this depends on your OS, see [the Docker documentation](https://docs.docker.com/install/))
1. Ensure you are a member of the GitHub organization [Materials-Consortia](https://github.com/Materials-Consortia).
  This is necessary to pull the base image for the Docker image for testing.
1. Build the Docker image for testing (based on a Unix system):

  ```sh
  docker login ghcr.io
  # You will be prompted for your GitHub username and password

  cd /path/to/optimade-validator-action
  docker build --tag optimade_bats ./tests
  ```

Now you can run

```sh
docker run --rm -it -v "$(pwd):/code" --workdir /code optimade_bats ./tests
```

or

```sh
./run_tests.sh
```

This is a file that contains the previous line and runs it, for posterity.
Furthermore, it takes two arguments.

One is the Docker tag.
So if you named the built Docker image something different from `optimade_bats`, you can pass the name to `run_tests.sh` and it will work, e.g.,

```sh
./run_tests.sh my_custom_image_name
```

will run the tests with image `my_custom_image_name` instead of `optimade_bats`.

Another is the relative or absolute path to the `.bats` files directory or a single `.bats` file, e.g.,

```sh
./run_tests.sh ./tests/test_verbosity.bats
```

will run the tests in the `test_verbosity.bats` file under the `tests` directory relative to where you're running the `run_tests.sh` file.

## Concerning action versions and `optimade-python-tools`

Since this action installs [`optimade-python-tools`](https://github.com/Materials-Consortia/optimade-python-tools) and runs the validator from this repository, the versions of this Action relies on different versions of the `optimade` package in the `optimade-python-tools` repository.

To keep it simple, this overview will only consider the major versions of this Action:

| Action version | `optimade` package versions | Supported OPTIMADE API specification version(s) |
| :---: | :---: | :---: |
| [`v2`](https://github.com/Materials-Consortia/optimade-validator-action/releases/tag/v2.0.0) | [`v0.10.0`](https://github.com/Materials-Consortia/optimade-python-tools/releases/v0.10.0)+ | [`v1.0.0`](https://github.com/Materials-Consortia/OPTIMADE/blob/v1.0.0/optimade.rst) - [latest](https://github.com/Materials-Consortia/OPTIMADE/blob/master/optimade.rst) |
| [`v1`](https://github.com/Materials-Consortia/optimade-validator-action/releases/tag/v1.2.0) | [`v0.7.0`](https://github.com/Materials-Consortia/optimade-python-tools/releases/v0.7.0) - [`v0.9.8`](https://github.com/Materials-Consortia/optimade-python-tools/releases/v0.9.8) | [`v0.10.0`](https://github.com/Materials-Consortia/OPTIMADE/blob/v0.10.0/optimade.md) - [`v1.0.0-rc2`](https://github.com/Materials-Consortia/OPTIMADE/blob/v1.0.0-rc2/optimade.rst) |
