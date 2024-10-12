# Changelog

## [Unreleased](https://github.com/Materials-Consortia/optimade-validator-action/tree/HEAD)

[Full Changelog](https://github.com/Materials-Consortia/optimade-validator-action/compare/v2.9.0...HEAD)

## Upgrade Python 3.9 -> 3.10

Use Python 3.10 in the action as well as in all CI workflows.

Also, update dependencies and dev tools (pre-commit hooks) to the latest versions.

## [v2.9.0](https://github.com/Materials-Consortia/optimade-validator-action/tree/v2.9.0) (2024-10-12)

[Full Changelog](https://github.com/Materials-Consortia/optimade-validator-action/compare/v2...v2.9.0)

## Upgrade Python 3.9 -> 3.10

Use Python 3.10 in the action as well as in all CI workflows.

Also, update dependencies and dev tools (pre-commit hooks) to the latest versions.

**Merged pull requests:**

- Bump Python to 3.10 [\#160](https://github.com/Materials-Consortia/optimade-validator-action/pull/160) ([ml-evs](https://github.com/ml-evs))
- Update pre-commit requirement from ~=3.8 to ~=4.0 in the python group [\#159](https://github.com/Materials-Consortia/optimade-validator-action/pull/159) ([dependabot[bot]](https://github.com/apps/dependabot))
- Update pylint requirement from ~=3.2 to ~=3.3 in the python group [\#158](https://github.com/Materials-Consortia/optimade-validator-action/pull/158) ([dependabot[bot]](https://github.com/apps/dependabot))
- \[pre-commit.ci\] pre-commit autoupdate [\#157](https://github.com/Materials-Consortia/optimade-validator-action/pull/157) ([pre-commit-ci[bot]](https://github.com/apps/pre-commit-ci))
- \[pre-commit.ci\] pre-commit autoupdate [\#156](https://github.com/Materials-Consortia/optimade-validator-action/pull/156) ([pre-commit-ci[bot]](https://github.com/apps/pre-commit-ci))
- Update pre-commit requirement from ~=3.7 to ~=3.8 in the python group [\#155](https://github.com/Materials-Consortia/optimade-validator-action/pull/155) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2](https://github.com/Materials-Consortia/optimade-validator-action/tree/v2) (2024-07-03)

[Full Changelog](https://github.com/Materials-Consortia/optimade-validator-action/compare/v2.8.0...v2)

## [v2.8.0](https://github.com/Materials-Consortia/optimade-validator-action/tree/v2.8.0) (2024-07-03)

[Full Changelog](https://github.com/Materials-Consortia/optimade-validator-action/compare/v2.7.0...v2.8.0)

**Implemented enhancements:**

- Use Dependabot `groups` [\#148](https://github.com/Materials-Consortia/optimade-validator-action/issues/148)
- Update usage of `set-output` GH Actions command [\#123](https://github.com/Materials-Consortia/optimade-validator-action/issues/123)

**Fixed bugs:**

- Issue with BATS docker image [\#142](https://github.com/Materials-Consortia/optimade-validator-action/issues/142)
- Docker-compose references should be removed [\#106](https://github.com/Materials-Consortia/optimade-validator-action/issues/106)

**Closed issues:**

- Use the OPTIMADE bot user for CI jobs [\#149](https://github.com/Materials-Consortia/optimade-validator-action/issues/149)
- Use BATS Docker image from ghcr.io [\#146](https://github.com/Materials-Consortia/optimade-validator-action/issues/146)

**Merged pull requests:**

- \[pre-commit.ci\] pre-commit autoupdate [\#154](https://github.com/Materials-Consortia/optimade-validator-action/pull/154) ([pre-commit-ci[bot]](https://github.com/apps/pre-commit-ci))
- Bump docker/build-push-action from 5 to 6 in the gh-actions group [\#153](https://github.com/Materials-Consortia/optimade-validator-action/pull/153) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump the python group with 3 updates [\#152](https://github.com/Materials-Consortia/optimade-validator-action/pull/152) ([dependabot[bot]](https://github.com/apps/dependabot))
- Update CI/CD and dependabot [\#150](https://github.com/Materials-Consortia/optimade-validator-action/pull/150) ([CasperWA](https://github.com/CasperWA))
- Use the newly created bats image on ghcr.io [\#147](https://github.com/Materials-Consortia/optimade-validator-action/pull/147) ([CasperWA](https://github.com/CasperWA))
- Build BATS Docker image locally [\#143](https://github.com/Materials-Consortia/optimade-validator-action/pull/143) ([CasperWA](https://github.com/CasperWA))
- Use the `optimade` container image as a service [\#107](https://github.com/Materials-Consortia/optimade-validator-action/pull/107) ([CasperWA](https://github.com/CasperWA))

## [v2.7.0](https://github.com/Materials-Consortia/optimade-validator-action/tree/v2.7.0) (2022-05-16)

[Full Changelog](https://github.com/Materials-Consortia/optimade-validator-action/compare/v2.6.0...v2.7.0)

**Fixed bugs:**

- GH GraphQL type issue in auto-merge workflow [\#94](https://github.com/Materials-Consortia/optimade-validator-action/issues/94)

**Closed issues:**

- Failure to install optimade package deps [\#98](https://github.com/Materials-Consortia/optimade-validator-action/issues/98)

**Merged pull requests:**

- Update frequency for dependencies update PRs [\#105](https://github.com/Materials-Consortia/optimade-validator-action/pull/105) ([CasperWA](https://github.com/CasperWA))
- Use `ID!` type instead of `String!` [\#95](https://github.com/Materials-Consortia/optimade-validator-action/pull/95) ([CasperWA](https://github.com/CasperWA))
- Use Python tools logic for checking PR body [\#87](https://github.com/Materials-Consortia/optimade-validator-action/pull/87) ([CasperWA](https://github.com/CasperWA))
- Add steps to install `pre-commit` [\#83](https://github.com/Materials-Consortia/optimade-validator-action/pull/83) ([CasperWA](https://github.com/CasperWA))
- Fix workflow and python-version task [\#81](https://github.com/Materials-Consortia/optimade-validator-action/pull/81) ([CasperWA](https://github.com/CasperWA))
- Bump CasperWA/push-protected from 2.4.0 to 2.5.0 [\#74](https://github.com/Materials-Consortia/optimade-validator-action/pull/74) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.6.0](https://github.com/Materials-Consortia/optimade-validator-action/tree/v2.6.0) (2021-08-20)

[Full Changelog](https://github.com/Materials-Consortia/optimade-validator-action/compare/v2.5.0...v2.6.0)

**Fixed bugs:**

- Default gh\_actions\_host domain is no longer valid? [\#70](https://github.com/Materials-Consortia/optimade-validator-action/issues/70)

**Merged pull requests:**

- Update Dockerfile to fix `ip` binary issue [\#71](https://github.com/Materials-Consortia/optimade-validator-action/pull/71) ([CasperWA](https://github.com/CasperWA))
- Update dependencies + update to OPTIMADE API v1.1.0 [\#69](https://github.com/Materials-Consortia/optimade-validator-action/pull/69) ([CasperWA](https://github.com/CasperWA))
- Update GH actions [\#64](https://github.com/Materials-Consortia/optimade-validator-action/pull/64) ([CasperWA](https://github.com/CasperWA))

## [v2.5.0](https://github.com/Materials-Consortia/optimade-validator-action/tree/v2.5.0) (2021-03-10)

[Full Changelog](https://github.com/Materials-Consortia/optimade-validator-action/compare/v2.4.0...v2.5.0)

**Merged pull requests:**

- Added validator --minimal option to action [\#60](https://github.com/Materials-Consortia/optimade-validator-action/pull/60) ([ml-evs](https://github.com/ml-evs))

## [v2.4.0](https://github.com/Materials-Consortia/optimade-validator-action/tree/v2.4.0) (2021-02-11)

[Full Changelog](https://github.com/Materials-Consortia/optimade-validator-action/compare/v2.3.0...v2.4.0)

**Fixed bugs:**

- as\_type seems to be used incorrectly [\#56](https://github.com/Materials-Consortia/optimade-validator-action/issues/56)

**Merged pull requests:**

- Fix `as type` implementation [\#57](https://github.com/Materials-Consortia/optimade-validator-action/pull/57) ([CasperWA](https://github.com/CasperWA))
- Fix `validate unversioned path` naming [\#55](https://github.com/Materials-Consortia/optimade-validator-action/pull/55) ([CasperWA](https://github.com/CasperWA))

## [v2.3.0](https://github.com/Materials-Consortia/optimade-validator-action/tree/v2.3.0) (2021-01-11)

[Full Changelog](https://github.com/Materials-Consortia/optimade-validator-action/compare/v2.2.2...v2.3.0)

**Fixed bugs:**

- Option to disable validation of unversioned paths [\#52](https://github.com/Materials-Consortia/optimade-validator-action/issues/52)

**Merged pull requests:**

- Add 'validate\_unversioned\_path' option, which is false by default [\#53](https://github.com/Materials-Consortia/optimade-validator-action/pull/53) ([ml-evs](https://github.com/ml-evs))
- Bump CasperWA/push-protected from v1 to v2.1.0 [\#51](https://github.com/Materials-Consortia/optimade-validator-action/pull/51) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump python from 3.8 to 3.9.0 [\#47](https://github.com/Materials-Consortia/optimade-validator-action/pull/47) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.2.2](https://github.com/Materials-Consortia/optimade-validator-action/tree/v2.2.2) (2020-10-11)

[Full Changelog](https://github.com/Materials-Consortia/optimade-validator-action/compare/v2.2.1...v2.2.2)

**Fixed bugs:**

- Action crashes when run through marketplace [\#48](https://github.com/Materials-Consortia/optimade-validator-action/issues/48)

**Merged pull requests:**

- Move test files to root folder [\#49](https://github.com/Materials-Consortia/optimade-validator-action/pull/49) ([ml-evs](https://github.com/ml-evs))
- Remove Docker container after test runs [\#46](https://github.com/Materials-Consortia/optimade-validator-action/pull/46) ([CasperWA](https://github.com/CasperWA))

## [v2.2.1](https://github.com/Materials-Consortia/optimade-validator-action/tree/v2.2.1) (2020-09-28)

[Full Changelog](https://github.com/Materials-Consortia/optimade-validator-action/compare/v2.2.0...v2.2.1)

**Fixed bugs:**

- Python helper.py script not included in Dockerfile [\#43](https://github.com/Materials-Consortia/optimade-validator-action/issues/43)

**Merged pull requests:**

- Ensure `helper.py` script can be called [\#44](https://github.com/Materials-Consortia/optimade-validator-action/pull/44) ([CasperWA](https://github.com/CasperWA))

## [v2.2.0](https://github.com/Materials-Consortia/optimade-validator-action/tree/v2.2.0) (2020-09-28)

[Full Changelog](https://github.com/Materials-Consortia/optimade-validator-action/compare/v2.1.0...v2.2.0)

**Implemented enhancements:**

- Add support for `-j/--json` [\#41](https://github.com/Materials-Consortia/optimade-validator-action/issues/41)

**Merged pull requests:**

- Add `create_outputs` and `results` output [\#42](https://github.com/Materials-Consortia/optimade-validator-action/pull/42) ([CasperWA](https://github.com/CasperWA))

## [v2.1.0](https://github.com/Materials-Consortia/optimade-validator-action/tree/v2.1.0) (2020-09-17)

[Full Changelog](https://github.com/Materials-Consortia/optimade-validator-action/compare/v2.0.1...v2.1.0)

**Implemented enhancements:**

- Validator action should fail nicely for validator versions below 0.10 [\#35](https://github.com/Materials-Consortia/optimade-validator-action/issues/35)
- Unversioned base URLs are not tested [\#31](https://github.com/Materials-Consortia/optimade-validator-action/issues/31)

**Fixed bugs:**

- Publish workflow \(still\) not working [\#39](https://github.com/Materials-Consortia/optimade-validator-action/issues/39)
- Cannot install double digit version [\#38](https://github.com/Materials-Consortia/optimade-validator-action/issues/38)
- Publish workflow not working [\#32](https://github.com/Materials-Consortia/optimade-validator-action/issues/32)

**Merged pull requests:**

- Properly import sys in tasks.py [\#40](https://github.com/Materials-Consortia/optimade-validator-action/pull/40) ([CasperWA](https://github.com/CasperWA))
- Attempt to disallow optimade versions\<0.10 [\#37](https://github.com/Materials-Consortia/optimade-validator-action/pull/37) ([ml-evs](https://github.com/ml-evs))
- Test unversioned base URLs [\#34](https://github.com/Materials-Consortia/optimade-validator-action/pull/34) ([CasperWA](https://github.com/CasperWA))
- Use actions/checkout@v2 in publish workflow [\#33](https://github.com/Materials-Consortia/optimade-validator-action/pull/33) ([CasperWA](https://github.com/CasperWA))

## [v2.0.1](https://github.com/Materials-Consortia/optimade-validator-action/tree/v2.0.1) (2020-09-16)

[Full Changelog](https://github.com/Materials-Consortia/optimade-validator-action/compare/v2.0.0...v2.0.1)

**Implemented enhancements:**

- Add Actions workflow for updating/releasing version [\#20](https://github.com/Materials-Consortia/optimade-validator-action/issues/20)

**Fixed bugs:**

- Passing in version as `X.Y.Z` fails [\#26](https://github.com/Materials-Consortia/optimade-validator-action/issues/26)
- Validator can fail without returning with a non-zero exit code [\#25](https://github.com/Materials-Consortia/optimade-validator-action/issues/25)

**Closed issues:**

- Remove `master` from CI [\#22](https://github.com/Materials-Consortia/optimade-validator-action/issues/22)

**Merged pull requests:**

- New workflow for updating version [\#30](https://github.com/Materials-Consortia/optimade-validator-action/pull/30) ([CasperWA](https://github.com/CasperWA))
- Add dependabot configuration file [\#29](https://github.com/Materials-Consortia/optimade-validator-action/pull/29) ([CasperWA](https://github.com/CasperWA))
- Fail run upon error [\#28](https://github.com/Materials-Consortia/optimade-validator-action/pull/28) ([CasperWA](https://github.com/CasperWA))
- Use proper variable for version installation [\#27](https://github.com/Materials-Consortia/optimade-validator-action/pull/27) ([CasperWA](https://github.com/CasperWA))

## [v2.0.0](https://github.com/Materials-Consortia/optimade-validator-action/tree/v2.0.0) (2020-07-17)

[Full Changelog](https://github.com/Materials-Consortia/optimade-validator-action/compare/v1.2.0...v2.0.0)

**Implemented enhancements:**

- Get API version from the install OPTIMADE Python tools [\#18](https://github.com/Materials-Consortia/optimade-validator-action/issues/18)

**Closed issues:**

- Correct redirect for Marketplace badge [\#16](https://github.com/Materials-Consortia/optimade-validator-action/issues/16)

**Merged pull requests:**

- Release of optimade-validator-action v2 [\#23](https://github.com/Materials-Consortia/optimade-validator-action/pull/23) ([ml-evs](https://github.com/ml-evs))
- Updated validator flags [\#21](https://github.com/Materials-Consortia/optimade-validator-action/pull/21) ([ml-evs](https://github.com/ml-evs))

## [v1.2.0](https://github.com/Materials-Consortia/optimade-validator-action/tree/v1.2.0) (2020-06-25)

[Full Changelog](https://github.com/Materials-Consortia/optimade-validator-action/compare/v1.1.0...v1.2.0)

**Closed issues:**

- Update capitalization of OPTIMADE name [\#14](https://github.com/Materials-Consortia/optimade-validator-action/issues/14)
- Add Marketplace badge to README [\#13](https://github.com/Materials-Consortia/optimade-validator-action/issues/13)

**Merged pull requests:**

- Use \_\_api\_version\_\_ from install OPTIMADE Python tools [\#19](https://github.com/Materials-Consortia/optimade-validator-action/pull/19) ([CasperWA](https://github.com/CasperWA))
- Add GitHub Marketplace badge and update OPTIMADE capitalization [\#15](https://github.com/Materials-Consortia/optimade-validator-action/pull/15) ([CasperWA](https://github.com/CasperWA))

## [v1.1.0](https://github.com/Materials-Consortia/optimade-validator-action/tree/v1.1.0) (2020-03-13)

[Full Changelog](https://github.com/Materials-Consortia/optimade-validator-action/compare/v1...v1.1.0)

## [v1](https://github.com/Materials-Consortia/optimade-validator-action/tree/v1) (2020-03-13)

[Full Changelog](https://github.com/Materials-Consortia/optimade-validator-action/compare/v1.0.0...v1)

**Implemented enhancements:**

- Add arguments from optimade\_validator [\#7](https://github.com/Materials-Consortia/optimade-validator-action/issues/7)

**Closed issues:**

- Update README to point at v1 [\#6](https://github.com/Materials-Consortia/optimade-validator-action/issues/6)

**Merged pull requests:**

- Release v1.1.0 [\#12](https://github.com/Materials-Consortia/optimade-validator-action/pull/12) ([CasperWA](https://github.com/CasperWA))
- Add verbosity and as\_type input parameters [\#11](https://github.com/Materials-Consortia/optimade-validator-action/pull/11) ([CasperWA](https://github.com/CasperWA))

## [v1.0.0](https://github.com/Materials-Consortia/optimade-validator-action/tree/v1.0.0) (2020-03-12)

[Full Changelog](https://github.com/Materials-Consortia/optimade-validator-action/compare/dc41da992a05991be44a229a6d6f2ff4dfd79084...v1.0.0)

**Implemented enhancements:**

- Add ability to choose the validator version [\#1](https://github.com/Materials-Consortia/optimade-validator-action/issues/1)

**Closed issues:**

- Fix CI tests [\#2](https://github.com/Materials-Consortia/optimade-validator-action/issues/2)

**Merged pull requests:**

- Update README to reflect v1 release [\#8](https://github.com/Materials-Consortia/optimade-validator-action/pull/8) ([CasperWA](https://github.com/CasperWA))
- Update README [\#5](https://github.com/Materials-Consortia/optimade-validator-action/pull/5) ([CasperWA](https://github.com/CasperWA))
- Add parameter to choose optimade-python-tools version, branch, tag or commit [\#4](https://github.com/Materials-Consortia/optimade-validator-action/pull/4) ([CasperWA](https://github.com/CasperWA))
- \[BLOCKING\] Clone optimade-python-tools and run docker-compose [\#3](https://github.com/Materials-Consortia/optimade-validator-action/pull/3) ([CasperWA](https://github.com/CasperWA))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
