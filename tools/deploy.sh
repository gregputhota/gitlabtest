#!/bin/bash
set -e
# Artifact version being choosen from gitlab is based on the COMMIT ID. Care 
# should be taken to trigger the pipeline for the respective SHA COMMIT
# Untar it and deploy it to the target env based on the environment selected
version=$(sed '/^#/d' < Version | sed '/^$/d')
if [ "$CI_COMMIT_REF_NAME" == "develop"]; then
    version="$version.dev$CI_JOB_ID"
elif [ "$CI_COMMIT_REF_NAME" == "master"]; then
    version=$version
else
    version="$version.$CI_COMMIT_SHORT_SHA"
fi
# CI_REPOSITORY_URL will have the value https://gitlab-ci-token:xxxxxxxxxxxxxxxxxxxx@gitlab.com/gitproject/sample.git
# We are extracting the reponame from the URL
reponame=$(echo ${CI_REPOSITORY_URL##*/} | sed 's/....$//')
artifact="$reponame.$version.tar.gz"
 
# Retrieve Hostname from the env variable CI_ENVIRONMENT_NAME
#hosts="$(cat deploy_target.yml | shyaml get-value $CI_ENVIRONMENT_NAME | awk '{print $2}')"
#for host in $hosts; do
#    scp -o "StrictHostKeyChecking no"  build/$artifact ubuntu@"$host":/home/ubuntu/deploy
#    ssh -o "StrictHostKeyChecking no" ubuntu@"$host" "cd /home/ubuntu/deploy&&tar -xzvf /home/ubuntu/deploy/$artifact&&cp -R /home/ubuntu/deploy/src/*.* /var/www/html&&rm -rf /home/ubuntu/deploy/$artifact /home/ubuntu/deploy/src| echo $?"
#done
scp -o "StrictHostKeyChecking no"  build/$artifact ubuntu@host:/home/ubuntu/deploy
ssh -o "StrictHostKeyChecking no" ubuntu@host "cd /home/ubuntu/deploy&&tar -xzvf /home/ubuntu/deploy/$artifact&&cp -R /home/ubuntu/deploy/odin/* /var/www/html&&rm -rf /home/ubuntu/deploy/$artifact /home/ubuntu/deploy/odin| echo $?"
