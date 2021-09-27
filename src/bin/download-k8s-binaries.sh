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

# shellcheck source=../lib/k8s/bin-locations-functions.sh
source "../lib/k8s/bin-locations-functions.sh"

function checkArgs()
{
  if (( $# < 4 )); then
    echo "Downloads k8s binaries & uploads them to the specified 'uploadserver'"
    echo
    echo "Usage: ${0} \"<k8s-version>\" \"<crictl-version>\" \"<cni-version>\" \"<upload-server>\""
    echo "Example: ${0} \"1.19.15\" \"1.19.0\" \"0.8.2\" \"uploadserver\""
    exit 1
  fi
}

function getCNI()
{
    local -r version="${1}"; shift
    local -r dst="${1}"; shift

    local -r download_path=$(getCNIURL "${version}")
    local -r filename=$(getCNIFileName "${version}")
    
    downloadFile "${download_path}" "${dst}"
    echo "${dst}/$filename"
}

function getcrictl()
{
    local -r version="${1}"; shift
    local -r dst="${1}"; shift

    local -r download_path=$(getcrictlURL "${version}")
    local -r filename=$(getcrictlFileName "${version}")

    downloadFile "${download_path}" "${dst}"
    echo "${dst}/$filename"
}

function getkube()
{
    local -r version="${1}"; shift
    local -r dst="${1}"; shift
    local -r download_path=$(getkubeURL "${version}")
    
    downloadFile "${download_path}" "${dst}"
}

function main()
{
    local -r kube_version="${1}"; shift
    local -r crictl_version="${1}"; shift
    local -r cni_version="${1}"; shift
    local -r remote_host="${1}"; shift

    local -r enable_proxy=1
    printf -v curr_date '%(%Y%m%d_%H%M%S)T'
    local -r tmp_folder="bins_${curr_date}"
    local -r remote_parent_path="/srv/www/htdocs/kube${kube_version}"
    local -r remote_cni_path="${remote_parent_path}/cni/bin"
    local -r remote_bin_path="${remote_parent_path}/bin"

    setProxy "${enable_proxy}"
    
    local -r local_cni=$(getCNI "${cni_version}" "${tmp_folder}/cni")
    remoteExtract "${remote_host}" "${local_cni}" "${remote_cni_path}"
    
    local -r local_crictl=$(getcrictl "${crictl_version}" "${tmp_folder}/crictl")
    remoteExtract "${remote_host}" "${local_crictl}" "${remote_bin_path}"

    getkube "${kube_version}" "${tmp_folder}/kube"
    #remoteCopy "${tmp_folder}/kube/" "${remote_host}" "${remote_bin_path}"
    remoteCopyFiles "${tmp_folder}/kube/." "${remote_host}" "${remote_bin_path}"
}

main "${@}"