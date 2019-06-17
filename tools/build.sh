#!/bin/bash
set -e
version=$(sed '/^#/d' < Version | sed '/^$/d')
if [ "$CI_COMMIT_REF_NAME" == "develop"]; then
    version="$version.dev$CI_JOB_ID"
elif [ "$CI_COMMIT_REF_NAME" == "master"]; then
    version=$version
else
    version="$version.$CI_COMMIT_SHORT_SHA"
fi
# Remove the previous artifacts and the build directory
rm -rf build
mkdir build

# We are extracting the reponame from the URL
reponame=$(echo ${CI_REPOSITORY_URL##*/} | sed 's/....$//')
# Create a tar.gz package
tar -czvf $reponame.$version.tar.gz src
# Move the built tar.gz inside the build directory
mv $reponame.$version.tar.gz build
