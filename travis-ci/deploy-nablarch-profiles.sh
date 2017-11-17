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

  # Deploy
  mvn -s ../travis-settings.xml ${MVN_PROFILE} \
    -Ddevelop_repo_url="dav:${DEVELOP_REPO_URL}/${DEVELOP_REPO_NAME}" \
    deploy

  popd
}

mvn_deploy nablarch-bom
mvn_deploy nablarch-profile-parent
