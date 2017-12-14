#!/bin/bash
set -euo pipefail


### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/config/nablarch_env


### Install Oracle JDK6
curl -sS --digest --user ${DOWNLOAD_USER}:${DOWNLOAD_PASS} \
  ${DOWNLOAD_URL}/install/{jdk-6u45-linux-x64.bin} -o ~/#1

pushd ~/

chmod +x jdk-6u45-linux-x64.bin && ./jdk-6u45-linux-x64.bin > /dev/null


cat << 'EOT' >> ${CUR}/config/nablarch_env

export COMPILE_JAVA_HOME=~/jdk1.6.0_45
export TEST_JDK="${COMPILE_JAVA_HOME}"

EOT

popd
