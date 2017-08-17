#!/bin/bash
set -euo pipefail


### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/nablarch_env

DOWNLOAD_USER=nablarch
DOWNLOAD_PASS=${NABLARCH_PASS}
DOWNLOAD_URL=http://ec2-52-199-35-248.ap-northeast-1.compute.amazonaws.com


### Install IBM WMQ Lib.
curl -sS --digest --user ${DOWNLOAD_USER}:${DOWNLOAD_PASS} \
  ${DOWNLOAD_URL}/install/{oracle-jdbc.zip} -o /tmp/#1

pushd /tmp

unzip oracle-jdbc.zip
pushd oracle-jdbc/

install_jar(){
  mvn install:install-file -Dfile=$1 -DgroupId=$2 \
                           -DartifactId=$3 -Dversion=$4 -Dpackaging=jar
}

install_jar ucp-11.2.0.3.0.jar com.oracle ucp 11.2.0.3.0
install_jar ojdbc6-11.2.0.4.0.jar com.oracle ojdbc6 11.2.0.4.0

popd
