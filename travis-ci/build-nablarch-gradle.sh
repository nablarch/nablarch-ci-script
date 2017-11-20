!/bin/bash
set -euo pipefail


### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/config/nablarch_env


### Confirm build enviroment.
java -version


MODE="nodeploy"

while getopts m:p: OPT
do
  case $OPT in
    "m" ) MODE=${OPTARG};;
  esac
done


GIT_COMMIT_MSG=""

if [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
  GIT_COMMIT_MSG=$(git log --pretty=format:"%s" -n 1 @^2)
fi


### Main Build.
if [ "${TRAVIS_PULL_REQUEST}" == "false" ] && [ "${TRAVIS_BRANCH}" == "develop" ] && [ "${MODE}" == "deploy" ] \
   || echo "${GIT_COMMIT_MSG}" | grep -E '^\[\[TRAVIS FORCE DEPLOY\]\]' >/dev/null ; then

  ./gradlew --refresh-dependencies clean test uploadArchives -PnablarchRepoUsername=${NABLARCH_USER} -PnablarchRepoPassword=${NABLARCH_PASS} \
                           -PnablarchRepoReferenceUrl=${DEVELOP_REPO_URL} -PnablarchRepoReferenceName=${DEVELOP_REPO_NAME} \
                           -PnablarchRepoDeployUrl=dav:${DEVELOP_REPO_URL} -PnablarchRepoName=${DEVELOP_REPO_NAME} \
                           -PdevelopLibUrl=${DEVELOP_REPO_URL}/${DEVELOP_REPO_NAME} --no-daemon

else

  ./gradlew --refresh-dependencies clean test -PnablarchRepoUsername=${NABLARCH_USER} -PnablarchRepoPassword=${NABLARCH_PASS} \
                  -PnablarchRepoReferenceUrl=${DEVELOP_REPO_URL} -PnablarchRepoReferenceName=${DEVELOP_REPO_NAME} \
                  -PnablarchRepoDeployUrl=dav:${DEVELOP_REPO_URL} -PnablarchRepoName=${DEVELOP_REPO_NAME} \
                  -PdevelopLibUrl=${DEVELOP_REPO_URL}/${DEVELOP_REPO_NAME} --no-daemon
fi
