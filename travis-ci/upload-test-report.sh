#!/bin/bash
set -euo pipefail

### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/config/nablarch_env


### Upload Project site.
repo_name="$(basename ${TRAVIS_BUILD_DIR})"
timestamp="$(date +%Y%m%d%H%M%S)"

mvn -s travis-settings.xml \
    -P travis \
    -Ddevelop_repo_url="dav:${DEVELOP_REPO_URL}/${DEVELOP_REPO_NAME}" \
    -Ddevelop_test_report_url="dav:${DEVELOP_REPO_URL}/${DEVELOP_TEST_REPORT_NAME}/nablarch/${repo_name}/${timestamp}" \
    -Dmaven.test.skip=true \
    -l mvn_build.log \
    site site:deploy


if [ $? -eq 0 ]; then
  echo
  echo
  echo "Save unit test report."
  echo "  ${DEVELOP_REPO_URL}/${DEVELOP_TEST_REPORT_NAME}/nablarch/${repo_name}/${timestamp}"
fi
