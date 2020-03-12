# GitHub Action - OPTiMaDe validator

This action runs `optimade_validator` from the `optimade` package found in the [`optimade-python-tools` repository](https://github.com/Materials-Consortia/optimade-python-tools) on either a locally running server or a public server.

## Example usage

To run `optimade_validator` for an index meta-database at `http://gh_actions_host:5001/v0` do the following:  
Within the same job, first, start a server, e.g., using the `docker-compose.yml` setup from this repository, and then add the step

```yml
uses: Materials-Consortia/optimade-python-tools@master
with:
  port: 5001
  path: /v0
  index: yes
```

To run `optimade_validator` for a regular OPTiMaDe _deployed_ implementation, testing all possible versioned base URLs:

- `https://example.org:443/optimade/example/v0`
- `https://example.org:443/optimade/example/v0.10`
- `https://example.org:443/optimade/example/v0.10.1`

```yml
uses: Materials-Consortia/optimade-python-tools@master
with:
  protocol: https
  domain: example.org
  port: 443
  path: /optimade/example
  all versioned paths: True
```

## Inputs

### `protocol`

**Optional** Protocol for the OPTiMaDe URL.  
**Default**: `http`

### `domain`

**Optional** Domain for the OPTiMaDe URL (defaults to the GitHub Actions runner host).  
**Default**: `gh_actions_host`

### `port`

**Optional** Port for the OPTiMaDe URL.  
**Default**: `5000`

### `path`

**Optional** Path for the OPTiMaDe (versioned) base URL - MUST start with `/`  
_Note_: If `all versioned paths` is `true`, this MUST be un-versioned, e.g., `/optimade` or `/`, otherwise it MUST be versioned, e.g., the default value.  
**Default**: `/v0`

### `all versioned paths`

**Optional** Whether to test all possible versioned base URLs:

- /vMAJOR
- /vMAJOR.MINOR
- /vMAJOR.MINOR.PATCH

If this is `'true'`, the input `'path'` MUST exempt the version part (e.g., `'/optimade'` instead of `'/optimade/v0'`).  
If this is `'false'`, the input `'path'` MUST include the version part (e.g., `'/optimade/v0'` instead of `'/optimade'`).  
**Default**: `false`

### `index`

**Optional** Whether or not this is an index meta-database.  
**Default**: `false`

### `validator version`

**Required** Full version of an OPTiMaDe Python tools release to PyPI, e.g., `'0.6.0'` or `'0.3.4'`, which hosts the `optimade_validator`.
It can also be a branch, tag, or git commit to use from the GitHub repository, e.g., `'master'`, `'v0.6.0'` or `'5a5e903'`.
See [the pip documentation](https://pip.pypa.io/en/latest/reference/pip_install/#git) for more information of what is allowed here.
Finally, it may also be `'latest'` (default), which is understood to be the latest official release of the `optimade` package on PyPI.
Note, for the latest development version, choose `'master'`.
**Default**: `latest`

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
