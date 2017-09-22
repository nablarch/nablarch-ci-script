#!/bin/bash
set -euo pipefail


### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/config/nablarch_env


### Confirm build enviroment.
java -version


cd ${TRAVIS_BUILD_DIR}


### Main Build.
# Test Only.
java -version
./gradlew --refresh-dependencies clean test -PnablarchRepoUsername=${NABLARCH_USER} -PnablarchRepoPassword=${NABLARCH_PASS} \
                -PnablarchRepoReferenceUrl=${DEVELOP_REPO_URL} -PnablarchRepoReferenceName=${DEVELOP_REPO_NAME} \
                -PdevelopLibUrl=${DEVELOP_REPO_URL}/${DEVELOP_REPO_NAME} --no-daemon
