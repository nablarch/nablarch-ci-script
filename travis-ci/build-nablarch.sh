#!/bin/bash 
set -euo pipefail


### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/config/nablarch_env


### Setting locale.
export LC_ALL=ja_JP.UTF-8


### Main Build.
# if it creates pull request, execute `mvn test` only.
# if it merges pull request to develop branch or dilectly commit on develop branch, execute `mvn deploy`.
# Waning, TRAVIS_PULL_REQUEST variable is 'false' or pull request number, 1,2,3 and so on.


MODE="no_deploy"
MVN_PROFILE=""

while getopts m:p: OPT
do
  case $OPT in
    "m" ) MODE=${OPTARG};;
    "p" ) MVN_PROFILE="-P $OPTARG";;
  esac
done


if [ "${TRAVIS_PULL_REQUEST}" == "false" \
       -a "${TRAVIS_BRANCH}" == "develop" \
       -a "${MODE}" == "deploy" ]; then

  mvn -s travis-settings.xml ${MVN_PROFILE} \
      -Ddevelop_repo_url="dav:${DEVELOP_REPO_URL}/${DEVELOP_REPO_NAME}" \
      deploy

else

  mvn -s travis-settings.xml ${MVN_PROFILE} \
      -Ddevelop_repo_url="dav:${DEVELOP_REPO_URL}/${DEVELOP_REPO_NAME}" \
      test

fi
