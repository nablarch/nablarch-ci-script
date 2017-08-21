#!/bin/bash                                                                                                                                                                           
set -euo pipefail


### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/config/nablarch_env


#### Prepare travis build.
cp $HOME/build-script/travis-ci/config/travis-settings.xml ./
export LC_ALL=ja_JP.UTF-8


### Encrypt Deploy password.
MASTER_PASS=$(mvn --encrypt-master-password ${NABLARCH_PASS})

cat << EOT > ~/.m2/settings-security.xml
<settingsSecurity>
  <master>${MASTER_PASS}</master>
</settingsSecurity>
EOT

ENC_PASS=$(mvn --encrypt-password ${NABLARCH_PASS})
sed -i -e "s@#DEPLOY_PASSWORD#@${ENC_PASS}@" travis-settings.xml


### Set Develop Repository for Travis build.
sed -i -e "s@#DEVELOP_REPO_URL#@${DEVELOP_REPO_URL}@" travis-settings.xml


### Main Build.
mvn -s travis-settings.xml \
    -P development \
    -Ddevelop_repo_url="dav:${DEVELOP_REPO_URL}/${DEVELOP_REPO_NAME}" \
    test
