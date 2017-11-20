#!/bin/bash 
set -euo pipefail


### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/config/nablarch_env


### Setting locale.
export LC_ALL=ja_JP.UTF-8


### Main Build.
pushd nablarch-archetype-parent

mvn -s ../travis-settings.xml \
  -Durl=dav:${DEVELOP_REPO_URL}/${DEVELOP_REPO_NAME} \
  -DrepositoryId=dev-deploy \
  -Dfile=pom.xml \
  -DpomFile=pom.xml \
  -DgeneratePom=false \
  -Dpackaging=pom \
  deploy:deploy-file

popd
