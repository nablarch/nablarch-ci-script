#!/bin/bash
set -euo pipefail


### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/config/nablarch_env

### Install kaptcha.
curl -sS --digest --user ${DOWNLOAD_USER}:${DOWNLOAD_PASS} \
  ${DOWNLOAD_URL}/install/{kaptcha-2.3.2.zip} -o /tmp/#1

pushd /tmp

unzip kaptcha-2.3.2.zip
mvn install:install-file -Dfile=kaptcha-2.3.2.jar -DgroupId=com.google.code \
                         -DartifactId=kaptcha -Dversion=2.3.2 -Dpackaging=jar

popd
