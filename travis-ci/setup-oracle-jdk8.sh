#!/bin/bash
set -euo pipefail


### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/config/nablarch_env

### Use Oracle JDK8 of TravisCI.
### In .travis.yml, Need to set `jdk --> oraclejdk8`

cat << 'EOT' >> ${CUR}/config/nablarch_env

export TEST_JDK="${JAVA_HOME}"
export COMPILE_JAVA_HOME="${JAVA_HOME}"

EOT

popd
