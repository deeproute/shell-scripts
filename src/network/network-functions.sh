#! /usr/bin/env bash

setProxy()
{
    local -r enable_proxy="${1}"; shift

    if [[ "${enable_proxy}" ]] ; then
        export HTTP_PROXY=http://proxylb.internal.epo.org:8080
        export HTTPS_PROXY=$HTTP_PROXY
        export NO_PROXY=.internal.epo.org,localhost,127.0.0.1
        export http_proxy=$HTTP_PROXY
        export https_proxy=$HTTP_PROXY
        export no_proxy=$NO_PROXY
    fi
}

