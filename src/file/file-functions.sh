#! /usr/bin/env bash

function downloadFile()
{
    local -r download_url="${1}"; shift
    local -r dst="${1}"; shift

    mkdir -p "${dst}"

    (cd "${dst}" && curl -LO "${download_url}")
}

function remoteCopy()
{
    local -r folder_local="${1}"; shift
    local -r remote_host="${1}"; shift
    local -r remote_dst="${1}"; shift
    
    ssh "${remote_host}" "mkdir -p ${remote_dst}" && scp -r "${folder_local}" "${remote_host}:${remote_dst}"
}

function remoteCopyFiles()
{
    local -r folder_local="${1}"; shift
    local -r remote_host="${1}"; shift
    local -r remote_dst="${1}"; shift
    
    rsync --recursive --times --compress --delete --progress "${folder_local}" "${remote_host}:${remote_dst}"
}

function remoteExtract()
{
    local -r remote_host="${1}"; shift
    local -r local_file="${1}"; shift
    local -r remote_dest="${1}"; shift
    
    ssh "${remote_host}" "mkdir -p ${remote_dest} && tar -C ${remote_dest} -xzvf -" < "${local_file}"
}
