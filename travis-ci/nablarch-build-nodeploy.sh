#!/bin/bash
set -euo pipefail


### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/nablarch_env

cd ${TRAVIS_BUILD_DIR}


### Main Build.
# Test Only.
./gradlew clean test -PnablarchRepoUsername=${NABLARCH_USER} -PnablarchRepoPassword=${NABLARCH_PASS} \
                -PnablarchRepoReferenceUrl=${DEVELOP_REPO_URL} -PnablarchRepoReferenceName=${DEVELOP_REPO_NAME} \
                -PdevelopLibUrl=${DEVELOP_REPO_URL}/${DEVELOP_REPO_NAME} --no-daemon
