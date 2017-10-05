#!/bin/bash                                                                                                                                                                           
set -euo pipefail


### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/config/nablarch_env


### Setting locale.
export LC_ALL=ja_JP.UTF-8


### Install nablarch-example-mom-testing-common.
pushd /tmp
git clone -b develop https://github.com/nablarch/nablarch-example-mom-testing-common.git

pushd nablarch-example-mom-testing-common
mvn -s ${TRAVIS_BUILD_DIR}/travis-settings.xml \
    -P travis \
    -Ddevelop_repo_url="${DEVELOP_REPO_URL}" \
    install

popd
popd
