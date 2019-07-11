#!/bin/bash

set -e
set -u
set -o pipefail

DSS_VERSION=${DSS_VERSION:-5.1.4}
GRAALVM_VERSION=${GRAALVM_VERSION:-19.1.0}

DOCKER_USER_NAME=${DOCKER_USER_NAME:-"neomatrix369"}

IMAGE_NAME=${IMAGE_NAME:-dataiku-dss}
IMAGE_VERSION=${IMAGE_VERSION:-${DSS_VERSION}}
DSS_DOCKER_FULL_TAG_NAME="${DOCKER_USER_NAME}/${IMAGE_NAME}"

EXPOSED_PORT=${EXPOSED_PORT:-10000}

WORKDIR=/home/dataiku

CUSTOM_ENTRY_POINT=""
RUN_PERFORMANCE_SCRIPT=${RUN_PERFORMANCE_SCRIPT:-false}
if [[ "${DEBUG:-}" = "true" ]]; then
   CUSTOM_ENTRY_POINT="${CUSTOM_ENTRY_POINT:-} --entrypoint /bin/bash"
fi

set -x
time docker run --rm                                            \
                --interactive --tty                             \
                -p ${EXPOSED_PORT}:10000                        \
                --workdir ${WORKDIR}                            \
                --env JDK_TO_USE=${JDK_TO_USE:-}                \
                --env DSS_VERSION=${DSS_VERSION}                \
                --env JAVA_OPTS=${JAVA_OPTS:-}                  \
                --env DSS_PORT=10000                            \
                --env HOME=${WORKDIR}                           \
                --env DSS_DATADIR=${WORKDIR}/dss                \
                --user dataiku                                  \
                ${CUSTOM_ENTRY_POINT}                           \
                ${DSS_DOCKER_FULL_TAG_NAME}:${IMAGE_VERSION}
set +x