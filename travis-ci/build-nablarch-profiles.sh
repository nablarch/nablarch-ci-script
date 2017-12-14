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


mvn_install() {

  pushd $1

  # Install
  mvn -s ../travis-settings.xml ${MVN_PROFILE} install

  popd
}

mvn_install nablarch-bom
mvn_install nablarch-profile-parent
