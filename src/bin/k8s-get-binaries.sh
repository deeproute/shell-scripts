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
    echo "Downloads k8s binaries to the specified folder"
    echo
    echo "Usage: ${0} \"<k8s-version>\" \"<crictl-version>\" \"<cni-version>\" \"<path>\""
    echo "Example: ${0} \"1.19.15\" \"1.19.0\" \"0.8.2\" \"~/k8s-binaries-1.19.15\""
    exit 1
  fi
}

function downloadCNI()
{
    local -r version="${1}"; shift
    local -r dst="${1}"; shift

    local -r download_path=$(getCNIURL "${version}")
    
    downloadFile "${download_path}" "${dst}"
}

function downloadCrictl()
{
    local -r version="${1}"; shift
    local -r dst="${1}"; shift

    local -r download_path=$(getcrictlURL "${version}")

    downloadFile "${download_path}" "${dst}"
}

function downloadKube()
{
    local -r version="${1}"; shift
    local -r dst="${1}"; shift
    local -r download_path=$(getkubeURL "${version}")
    
    downloadFile "${download_path}" "${dst}"
}

function main()
{
    checkArgs "${@}"

    local -r kube_version="${1}"; shift
    local -r crictl_version="${1}"; shift
    local -r cni_version="${1}"; shift
    local -r local_path="${1}"; shift

    downloadCNI "${cni_version}" "${local_path}/cni"
    downloadCrictl "${crictl_version}" "${local_path}/kube"
    downloadKube "${kube_version}" "${local_path}/kube"

    cd "${local_path}"/cni
    tar xvf ./*.tgz
    rm ./*.tgz
    
    cd "${local_path}"/kube/
    tar xvf ./*.tar.gz
    rm ./*.tgz
}

main "${@}"