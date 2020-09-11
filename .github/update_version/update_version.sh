#!/usr/bin/env bash
set -e

echo "\n### Checkout fresh branch ###"
git checkout -b update_version

echo "\n### Setting commit user ###"
git config --local user.email "dev@optimade.org"
git config --local user.name "OPTIMADE Developers"

echo "\n### Install invoke ###"
pip install invoke

echo "\n### Update version in README ###"
invoke setver -ver "${GITHUB_REF#refs/tags/}"

echo "\n### Commit update ###"
git add README.md
git commit -m "Release ${GITHUB_REF#refs/tags/} - Update README"
