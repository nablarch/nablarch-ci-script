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

MVN_PROFILE=""
while getopts p: OPT
do
  case $OPT in
    "p" ) MVN_PROFILE="-P $OPTARG";;
  esac
done


# Purge local repository of 'com.nablarch'.
mvn -s travis-settings.xml ${MVN_PROFILE} \
   -Dinclude=com.nablarch.* \
   -Dexclude=com.nablarch.example:nablarch-example-mom-testing-common* \
   -DreResolve=false \
   -Dverbose=true \
   dependency:purge-local-repository


if [ "${TRAVIS_PULL_REQUEST}" == "false" -a "${TRAVIS_BRANCH}" == "develop"  ]; then

  mvn -s travis-settings.xml ${MVN_PROFILE} \
      -Ddevelop_repo_url="dav:${DEVELOP_REPO_URL}/${DEVELOP_REPO_NAME}" \
      deploy

else

  mvn -s travis-settings.xml ${MVN_PROFILE} \
      -Ddevelop_repo_url="dav:${DEVELOP_REPO_URL}/${DEVELOP_REPO_NAME}" \
      test

fi
