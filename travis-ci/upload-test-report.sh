#!/bin/bash
set -euo pipefail

### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/config/nablarch_env


### Upload Project site.
repo_name="$(basename ${TRAVIS_BUILD_DIR})"
timestamp="$(date +%Y%m%d%H%M%S)"


MVN_PROFILE=""

while getopts p: OPT
do
  case $OPT in
    "p" ) MVN_PROFILE="-P $OPTARG";;
  esac
done

mvn -s travis-settings.xml ${MVN_PROFILE} \
    -Ddevelop_repo_url="dav:${DEVELOP_REPO_URL}/${DEVELOP_REPO_NAME}" \
    -Ddevelop_test_report_url="dav:${DEVELOP_TEST_REPORT_URL}/nablarch/${repo_name}/${timestamp}" \
    -Dmaven.test.skip=true \
    -l mvn_build.log \
    site site:deploy


if [ $? -eq 0 ]; then
  echo
  echo
  echo "Save unit test report."
  echo "  ${DEVELOP_TEST_REPORT_URL}/nablarch/${repo_name}/${timestamp}/"
fi
