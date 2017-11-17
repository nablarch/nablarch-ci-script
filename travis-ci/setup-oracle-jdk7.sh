#!/bin/bash
set -euo pipefail


### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/config/nablarch_env

DOWNLOAD_USER=nablarch
DOWNLOAD_PASS=${NABLARCH_PASS}
DOWNLOAD_URL=http://ec2-52-199-35-248.ap-northeast-1.compute.amazonaws.com


### Install Oracle JDK7
curl -sS --digest --user ${DOWNLOAD_USER}:${DOWNLOAD_PASS} \
  ${DOWNLOAD_URL}/install/{jdk-7u80-linux-x64.tar.gz} -o ~/#1

pushd ~/

tar xf ./jdk-7u80-linux-x64.tar.gz


cat << 'EOT' >> ${CUR}/config/nablarch_env

export COMPILE_JAVA_HOME=~/jdk1.7.0_80
export TEST_JDK="${COMPILE_JAVA_HOME}"

EOT

popd
