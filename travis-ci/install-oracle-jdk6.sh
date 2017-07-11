#!/bin/bash
set -euo pipefail


### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/nablarch_env

DOWNLOAD_USER=nablarch
DOWNLOAD_PASS=${NABLARCH_PASS}
DOWNLOAD_URL=http://ec2-52-199-35-248.ap-northeast-1.compute.amazonaws.com


### Install Oracle JDK6
curl -sS --digest --user ${DOWNLOAD_USER}:${DOWNLOAD_PASS} \
  ${DOWNLOAD_URL}/install/{jdk-6u45-linux-x64.bin} -o ~/#1

pushd ~/

chmod +x jdk-6u45-linux-x64.bin && ./jdk-6u45-linux-x64.bin > /dev/null


cat << 'EOT' >> ${CUR}/nablarch_env

export JAVA_HOME=~/jdk1.6.0_45
export PATH="${JAVA_HOME}/bin/:${PATH}"
EOT

popd
