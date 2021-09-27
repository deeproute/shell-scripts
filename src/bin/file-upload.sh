#! /usr/bin/env bash

# abort on nonzero exitstatus
set -o errexit

# When arrays are empty, an "unbound variable" error occurs.
# This shouldn't happen in bash 4.4 but most of our linux'es have bash before 4.4.
# Only solution is to do the hack below
# https://stackoverflow.com/questions/7577052/bash-empty-array-expansion-with-set-u
# To avoid hacks like this it was disabled.

# abort on unbound variable
#set -o nounset

# don't hide errors within pipes
set -o pipefail

# shellcheck source=../lib/file/file-functions.sh
source "../lib/file/file-functions.sh"

function checkArgs()
{
  if (( $# < 3 )); then
    echo "Uploads files to the specified 'uploadserver'"
    echo
    echo "Usage: ${0} <local-path> <remote-host> <remote-path>"
    echo "Example: ${0} ~/k8s-binaries-1.19.15 test-server /srv/www/htdocs/kube1.19.15"
    exit 1
  fi
}

function main()
{
    checkArgs "${@}"

    local -r local_path="${1}"; shift
    local -r remote_host="${1}"; shift
    local -r remote_path="${1}"; shift
    
    # local -r remote_parent_path="/srv/www/htdocs/kube${kube_version}"
    # local -r remote_cni_path="${remote_parent_path}/cni/bin"
    # local -r remote_bin_path="${remote_parent_path}/bin"
    
    # local -r local_cni=$(getCNI "${cni_version}" "${tmp_folder}/cni")
    # remoteExtract "${remote_host}" "${local_cni}" "${remote_cni_path}"
    
    # local -r local_crictl=$(getcrictl "${crictl_version}" "${tmp_folder}/crictl")
    # remoteExtract "${remote_host}" "${local_crictl}" "${remote_bin_path}"

    # getkube "${kube_version}" "${tmp_folder}/kube"
    #remoteCopy "${tmp_folder}/kube/" "${remote_host}" "${remote_bin_path}"
    # remoteCopyFiles "${tmp_folder}/kube/." "${remote_host}" "${remote_bin_path}"

    remoteCopyFiles "${local_path}/." "${remote_host}" "${remote_path}"
}

main "${@}"