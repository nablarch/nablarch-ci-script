#!/bin/bash                                                                                                                                                                                   
set -euo pipefail


### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/config/nablarch_env

cd ${TRAVIS_BUILD_DIR}


cp $HOME/build-script/travis-ci/config/travis-deploy.pom ./
cp $HOME/build-script/travis-ci/config/travis-server-settings.xml ./


### Encrypt Deploy password.
MASTER_PASS=$(mvn --encrypt-master-password ${NABLARCH_PASS})

cat << EOT > ~/.m2/settings-security.xml
<settingsSecurity>
  <master>${MASTER_PASS}</master>
</settingsSecurity>
EOT

ENC_PASS=$(mvn --encrypt-password ${NABLARCH_PASS})
sed -i -e "s/#DEPLOY_PASSWORD#/${ENC_PASS}/" travis-server-settings.xml


### Main Build.
# if it creates pull request, execute `gradlew build` only.
# if it merges pull request to develop branch or dilectly commit on develop branch, execute `gradlew uploadArchives`.
# Waning, TRAVIS_PULL_REQUEST variable is 'false' or pull request number, 1,2,3 and so on.
if [ "${TRAVIS_PULL_REQUEST}" == "false" -a "${TRAVIS_BRANCH}" == "develop"  ]; then

  mvn clean test site

  mvn -f travis-deploy.pom deploy
else
  mvn clean test site
fi


### Upload Project site.
mvn site:deploy \ 
    -f travis-site-deploy.pom -s travis-server-settings.xml \
      -Drepo_name="$(basename ${TRAVIS_BUILD_DIR})" -Dtimestamp="$(date +%Y%m%d%H%M%S)"
