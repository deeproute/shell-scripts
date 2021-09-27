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

# shellcheck source=../k8s/k8s-functions.sh
source "../k8s/k8s-functions.sh"

function checkArgs()
{
  if (( $# < 2 )); then
    echo "This script saves in a folder all current information like pods, events.."
    echo
    echo "Usage: ${0} cluster-context folder-path"
    echo "Example: ${0} k8slab /path/to/folder"
    exit 1
  fi
}

function main()
{
  echo "" # new line

  checkArgs "${@}"

  local -r context="${1}"; shift
  local -r folder_path="${1}"; shift

  printf -v curr_date '%(%Y%m%d_%H%M%S)T'

  local -r folder_context_path="${folder_path}/${context}_${curr_date}"
  echo "Date: ${curr_date}"
  echo "Logs at: ${folder_context_path}"

  mkdir -p "${folder_context_path}"

  getClusterInfo "${context}" > "${folder_context_path}/clusterinfo.log"
  getNodes "${context}" > "${folder_context_path}/nodes.log"
  getPods "${context}" > "${folder_context_path}/pods.log"
  getPodsWithProblems "${context}" > "${folder_context_path}/problempods.log"
  getEvents "${context}" > "${folder_context_path}/events.log"
}

main "${@}"