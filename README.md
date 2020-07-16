# GitHub Action - OPTIMADE validator

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-v1-undefined.svg?logo=github&logoColor=white&style=flat)](https://github.com/marketplace/actions/optimade-validator)

This action runs `optimade-validator` from the `optimade` package found in the [`optimade-python-tools` repository](https://github.com/Materials-Consortia/optimade-python-tools) on either a locally running server or a public server.

All minor and patch updates to v1 will be folded into the `v1` tag, so that using the action `@v1` is recommended, since it results in using the latest v1.minor.patch.

Latest versions:

| Used tag | Effective version |
| :---: | :---: |
| `v1` | [`v1.1.0`](https://github.com/Materials-Consortia/optimade-validator-action/releases/tag/v1.1.0)

## Example usage

To run `optimade-validator` for an index meta-database at `http://gh_actions_host:5001/v0` do the following:  
Within the same job, first, start a server, e.g., using the `docker-compose.yml` setup from this repository, and then add the step

```yml
uses: Materials-Consortia/optimade-validator-action@v1
with:
  port: 5001
  path: /v0
  index: yes
```

To run `optimade-validator` for a regular OPTIMADE _deployed_ implementation, testing all possible versioned base URLs:

- `https://example.org:443/optimade/example/v0`
- `https://example.org:443/optimade/example/v0.10`
- `https://example.org:443/optimade/example/v0.10.1`

```yml
uses: Materials-Consortia/optimade-validator-action@v1
with:
  protocol: https
  domain: example.org
  port: 443
  path: /optimade/example
  all versioned paths: True
```

## Inputs

| Input | Description | Usage | Default |
| :---: |    :---     | :---: |  :---:  |
| `all_versioned_paths` | Whether to test all possible versioned base URLs:<br><br>/vMAJOR<br>/vMAJOR.MINOR<br>/vMAJOR.MINOR.PATCH<br><br>If this is `'true'`, the input `'path'` MUST exempt the version part (e.g., `'/optimade'` instead of `'/optimade/v0'`).<br>If this is `'false'`, the input `'path'` MUST include the version part (e.g., `'/optimade/v0'` instead of `'/optimade'`) | Optional | `false`
| `as_type` | Validate the request URL with the provided type, rather than scanning the entire implementation<br>Example values: 'structures', 'reference'. For a full list of values see `optimade-python-tools`. | Optional | -
| `domain` | Domain for the OPTIMADE URL (defaults to the GitHub Actions runner host) | Optional | `gh_actions_host`
| `fail_fast` | Whether or not to exit and return a non-zero error code on first failure. | Optional | `false`
| `index` | Whether or not this is an index meta-database | Optional | `false`
| `path` | Path for the OPTIMADE (versioned) base URL - MUST start with `/`<br>_Note_: If `all versioned paths` is `true`, this MUST be un-versioned, e.g., `/optimade` or `/`, otherwise it MUST be versioned, e.g., the default value | Optional | `/v0`
| `port` | Port for the OPTIMADE URL | Optional | `5000`
| `protocol` | Protocol for the OPTIMADE URL | Optional | `http`
| `skip_optional` | Whether or not to skip tests for optional features. | Optional | `false`
| `validator_version` | Full version of an OPTIMADE Python tools release to PyPI, e.g., `'v0.6.0'` or `'0.3.4'`, which hosts the `optimade-validator`. It can also be a branch, tag, or git commit to use from the GitHub repository, e.g., `'master'` or `'5a5e903'`.<br>See [the pip documentation](https://pip.pypa.io/en/latest/reference/pip_install/#git) for more information of what is allowed here.<br>Finally, it may also be `'latest'` (default), which is understood to be the latest official release of the `optimade` package on PyPI.<br>Note, for the latest development version, choose `'master'`. | **Required** | `latest`
| `verbosity` | The verbosity of the output.<br>`0`: minimalistic, `1`: informational, `2`+: debug | Optional | `1`

## Running test suite (developers)

The test suite is based on [BATS](https://github.com/bats-core/bats-core) and should be run in [docker](https://github.com/bats-core/bats-core#running-bats-in-docker).
The reason to run in docker, is that the `entrypoint.sh` file will install the `optimade` package.
And to not pollute your local environment, it is safer to run it in a docker container.

Steps to setup your test environment:

1. Git clone this repository to your local environment
1. Install docker (this depends on your OS, see [the docker documentation](https://docs.docker.com/install/))
1. Run in a terminal (based on a Unix system):

   ```sh
   cd /path/to/optimade-validator-action
   docker build --tag optimade_bats ./tests
   ```

Now you can run

```sh
docker run -i -v "$(pwd):/code" --workdir /code/tests optimade_bats .
```

or

```sh
./run_tests.sh
```

This is a file that contains the previous line and runs it, for posterity.
Furthermore, it takes one argument: the docker tag.
So if you named the built docker image something different from `optimade_bats`, you can pass the name to `run_tests.sh` and it will work, e.g.,

```sh
./run_tests.sh my_custom_image_name
```

will run the tests with image `my_custom_image_name` instead of `optimade_bats`.
