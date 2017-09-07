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


# Purge local repository of 'com.nablarch'.
mvn -s travis-settings.xml ${MVN_PROFILE} \
    dependency:purge-local-repository -Dinclude=com.nablarch.* -DreResolve=false -Dverbose=true


mvn -s travis-settings.xml ${MVN_PROFILE} \
    -Ddevelop_repo_url="dav:${DEVELOP_REPO_URL}/${DEVELOP_REPO_NAME}" \
    test
