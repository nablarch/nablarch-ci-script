#!/bin/bash 
set -euo pipefail


### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/config/nablarch_env


cp $HOME/build-script/travis-ci/config/travis-settings.xml ./


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
sed -i -e "s@#DEVELOP_REPO_URL#@${DEVELOP_REPO_URL}/${DEVELOP_REPO_NAME}@" travis-settings.xml

