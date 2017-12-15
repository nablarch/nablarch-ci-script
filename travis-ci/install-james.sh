#!/bin/bash
set -euo pipefail


### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/config/nablarch_env

### Install James
pushd ~/

curl -sS --digest --user ${DOWNLOAD_USER}:${DOWNLOAD_PASS} \
  ${DOWNLOAD_URL}/install/{james-2.3.2.1.tar.gz} -o ./#1
tar -zxf james-2.3.2.1.tar.gz

popd

