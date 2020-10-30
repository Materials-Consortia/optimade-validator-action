#!/usr/bin/env bash
set -e

echo -e "\n### Setting commit user ###"
git config --local user.email "dev@optimade.org"
git config --local user.name "OPTIMADE Developers"

echo -e "\n### Update version ###"
invoke setver --ver="${GITHUB_REF#refs/tags/}"

echo -e "\n### Commit update ###"
git commit -am "Release ${GITHUB_REF#refs/tags/}"

echo -e "\n### Create new full version (v<MAJOR>.<MINOR>.<PATCH>) tag ###"
TAG_MSG=.github/update_version/release_tag_msg.txt
sed -i "s|TAG_NAME|${GITHUB_REF#refs/tags/}|g" "${TAG_MSG}"
git tag -af -F "${TAG_MSG}" ${GITHUB_REF#refs/tags/}

echo -e "\n### Move/update v<MAJOR> tag ###"
MAJOR_VERSION=$( echo ${GITHUB_REF#refs/tags/v} | cut -d "." -f 1 )
TAG_MSG=.github/update_version/major_version_tag_msg.txt
sed -i "s|MAJOR|${MAJOR_VERSION}|g" "${TAG_MSG}"
git tag -af -F "${TAG_MSG}" v${MAJOR_VERSION}
