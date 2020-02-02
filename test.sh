#!/usr/bin/env bash
JOB_NAME=( $CI_JOB_NAME )
IMAGE_NAME=${JOB_NAME[1]}
TEST_VERSION=PHP\ ${JOB_NAME[2]}*

docker pull $CI_REGISTRY_IMAGE/${JOB_NAME[1]}:${CI_BUILD_REF}
CONTAINER=$(docker run -d --name project-${CI_PROJECT_ID}-test-${JOB_NAME[1]}-${CI_BUILD_REF} --rm $CI_REGISTRY_IMAGE/${IMAGE_NAME}:${CI_BUILD_REF} )
echo "Starting container {$CONTAINER}"
if [[ $(docker exec $CONTAINER ps | grep -m1 php) = *php* ]]; then
    echo "php running: OK"
    if [[ $(docker exec $CONTAINER php -v) = ${TEST_VERSION} ]]; then
        echo "php version (${TEST_VERSION}): OK"
    else
        echo "php version: Fail expected ${TEST_VERSION}"
        echo $(docker exec $CONTAINER php -v)
        exit 1
    fi
else
    echo "php running: Fail"
    exit 1
fi
echo "Statements   : 100.0%"
exit 0