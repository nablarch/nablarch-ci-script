#!/bin/bash
set -euo pipefail


### Import nablarch env.
CUR=$(cd $(dirname $0); pwd)
source ${CUR}/config/nablarch_env


UPLOAD_USER=nablarch
UPLOAD_PASS=${NABLARCH_PASS}
UPLOAD_URL=${DEVELOP_REPO_URL}


# Upload Unit test report.
function uploadDir() {

  local readonly _remote_base_dir=${1}
  local readonly _local_upload_dir=${2}

  if [ ! -e ${_local_upload_dir} ]; then
    echo "Error, Directory ${_local_upload_dir} is not found."
    return 1
  fi

  ### Firstly, create base directory.
    # ex. create /test-report/nablarch/nablarch-core/12/
  (
   IFS='/'
   local tmp_dir=""
   for it in ${_remote_base_dir}; do
     tmp_dir="${tmp_dir}/${it}"
     curl -sS --digest --user ${UPLOAD_USER}:${UPLOAD_PASS} -X MKCOL \
      "${UPLOAD_URL}/test-report${tmp_dir}" > /dev/null
   done
  )

  ### Create all directory recursive. 
    # ex. create /test-report/nablarch/nablarch-core/12/subdir1, subdir2,...
  for vd in $(find ${_local_upload_dir} -type d -printf "%d %p\n" | \
              sort -k1n | awk '{print $2}' | \
              sed "s#${_local_upload_dir}##"); do
  
    if [ -z "${vd}" ]; then
         continue
    fi
  
    curl -sS --digest --user ${UPLOAD_USER}:${UPLOAD_PASS} -X MKCOL \
      ${UPLOAD_URL}/test-report/${_remote_base_dir}/${vd} > /dev/null
  done
  
  ### Finally, upload all files.
  pushd ${_local_upload_dir} > /dev/null

  for vf in $(find . -type f -printf "%p\n" | \
              sed "s#\./##"); do
  
    if [ -z "${vf}" ]; then
         continue
    fi
  
    curl -sS --digest --user ${UPLOAD_USER}:${UPLOAD_PASS} --upload-file ${vf} \
      ${UPLOAD_URL}/test-report/${_remote_base_dir}/${vf} > /dev/null
  done

  popd > /dev/null
}


set +e
upload_base_dir="${TRAVIS_REPO_SLUG}/${TRAVIS_BUILD_NUMBER}_`date +%Y%m%d_%H%M%S`"

for upload_local_dir in $(find -wholename '*build/reports/tests' -printf '%P\n')
do
  sub_dir=$(echo ${upload_local_dir} | sed -e 's#[/]*build/reports/tests##')

  if [ -n "${sub_dir}" ]; then
    # Multi Module Project
    uploadDir "${upload_base_dir}/${sub_dir}" "${TRAVIS_BUILD_DIR}/${upload_local_dir}"
  else
    # Single Module
    uploadDir "${upload_base_dir}" "${TRAVIS_BUILD_DIR}/${upload_local_dir}"
    break
  fi
done

set -e


if [ $? -eq 0 ]; then
  echo
  echo
  echo "Save unit test report."
  echo "  ${UPLOAD_URL}/test-report/${upload_base_dir}"
fi
