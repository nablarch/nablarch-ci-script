#!/bin/bash
set -euo pipefail


### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/config/nablarch_env

DOWNLOAD_USER=nablarch
DOWNLOAD_PASS=${NABLARCH_PASS}
DOWNLOAD_URL=http://ec2-52-199-35-248.ap-northeast-1.compute.amazonaws.com


### Install IBM WMQ Lib.
curl -sS --digest --user ${DOWNLOAD_USER}:${DOWNLOAD_PASS} \
  ${DOWNLOAD_URL}/install/{ibm-wmq-lib-7.5.zip} -o /tmp/#1

pushd /tmp

unzip ibm-wmq-lib-7.5.zip
pushd ibm-wmq-lib-7.5/

install_jar(){
  mvn install:install-file -Dfile=$1 -DgroupId=$2 \
                           -DartifactId=$3 -Dversion=$4 -Dpackaging=jar
}

install_jar com.ibm.mq.commonservices.jar com.ibm com.ibm.mq.commonservices 7.5
install_jar com.ibm.mq.headers.jar com.ibm com.ibm.mq.headers 7.5
install_jar com.ibm.mq.jmqi.jar com.ibm com.ibm.mq.jmqi 7.5
install_jar com.ibm.mq.pcf.jar com.ibm com.ibm.mq.pcf 7.5
install_jar com.ibm.mq.jar com.ibm com.ibm.mq 7.5
install_jar connector.jar javax.resource connector 1.0

popd
