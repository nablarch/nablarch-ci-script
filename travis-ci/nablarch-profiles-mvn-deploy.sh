#!/bin/bash 
set -euo pipefail


### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/config/nablarch_env


### Setting locale.
export LC_ALL=ja_JP.UTF-8


### Main Build.
MVN_PROFILE=""
while getopts p: OPT
do
  case $OPT in
    "p" ) MVN_PROFILE="-P $OPTARG";;
  esac
done


mvn_deploy() {

  pushd $1

  # Purge local repository of 'com.nablarch'.
  mvn -s ../travis-settings.xml ${MVN_PROFILE} \
     -Dinclude=com.nablarch.* \
     -DreResolve=false \
     -Dverbose=true \
     dependency:purge-local-repository

  # Deploy
  mvn -s ../travis-settings.xml ${MVN_PROFILE} \
    -Ddevelop_repo_url="dav:${DEVELOP_REPO_URL}/${DEVELOP_REPO_NAME}" \
    deploy

  popd
}

mvn_deploy nablarch-bom
mvn_deploy nablarch-profile-parent
