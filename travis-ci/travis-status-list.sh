#!/bin/bash

# For CentOS.

if [ $# -lt 1 ]; then
  echo "Error!!"
  echo
  echo "Usage:"
  echo " $0 <YOUR GITHUB_ACCESS_TOKEN> "
  echo
  exit 1
fi

GITHUB_ACCESS_TOKEN=${1}


### Exist ruby?
if [ ! `which ruby > /dev/null 2>&1` ]; then
    yum install -y ruby ruby-devel > /dev/null
fi

### Exist travis cli?
if [ ! `which travis > /dev/null 2>&1` ]; then
    gem install travis> /dev/null
fi

unset no_proxy
unset NO_PROXY

travis login --github-token ${GITHUB_ACCESS_TOKEN} > /dev/null

while read repo_name; do

  echo -n ${repo_name}
  echo -n ','
  travis status -r nablarch/${repo_name} | sed -e 's/^.*(passed|failed)/$1/'

done < <(travis repos -am 'nablarch/*' | sed -e 's/^nablarch\///g')

travis logout > /dev/null
