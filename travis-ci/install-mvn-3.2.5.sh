#!/bin/bash
set -euo pipefail


### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/config/nablarch_env

DOWNLOAD_USER=nablarch
DOWNLOAD_PASS=${NABLARCH_PASS}
DOWNLOAD_URL=http://ec2-52-199-35-248.ap-northeast-1.compute.amazonaws.com


### Install Maven 3.2.5
curl -sS --digest --user ${DOWNLOAD_USER}:${DOWNLOAD_PASS} \
  ${DOWNLOAD_URL}/install/{apache-maven-3.2.5-bin.zip} -o /tmp/#1

unzip /tmp/apache-maven-3.2.5-bin.zip -d ~/

pushd ~/

cat << 'EOT' >> ${CUR}/config/nablarch_env

# Maven 3.2.5
export MAVEN_HOME=~/apache-maven-3.2.5
export PATH="${MAVEN_HOME}/bin/:${PATH}"
EOT

popd
