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
