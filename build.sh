#!/bin/bash

application_path=.
application_name=crt-singarpore-node
application_version=$1
dockerfile_path=$PWD/Dockerfile
AWSENV=stage
AWSACCOUNT=890961259456.dkr.ecr.ap-southeast-1.amazonaws.com

# validation
if [ -z "$application_version" ]; then
    echo 'A version is required.  Execute as build.sh <version>'
    exit 1
fi



#  execute build
docker build \
    --build-arg app_version=${application_version} \
    --file ${dockerfile_path} \
    --build-arg HTTP_PROXY="http://YOUR_RPOXY" \
    --build-arg HTTPS_PROXY="http://YOUR_PROXY" \
    --tag ${application_name}:${AWSENV}-${application_version} \
    --tag ${AWSACCOUNT}/${application_name}:${AWSENV}-${application_version} \
    --tag ${application_name}:${AWSENV}-latest \
    --tag ${AWSACCOUNT}/${application_name}:${AWSENV}-latest \
    ${application_path} 

docker push ${AWSACCOUNT}/${application_name}:${AWSENV}-${application_version}
docker push ${AWSACCOUNT}/${application_name}:${AWSENV}-latest
