#! /usr/bin/env bash

function getClusterInfo()
{
    local -r context="${1}"; shift
    kubectl --context "${context}" cluster-info
}

function getNodes()
{
    local -r context="${1}"; shift
    kubectl --context "${context}" get no -owide
}

function getPods()
{
    local -r context="${1}"; shift
    kubectl --context "${context}" get pods -A -owide
}

function getPodsWithProblems()
{
    local -r context="${1}"; shift
    kubectl --context "${context}" get po -A -owide | gawk 'match($3, /([0-9])+\/([0-9])+/, a) {if (a[1] < a[2] && $4 != "Completed") print $0}'
}

function getEvents()
{
    local -r context="${1}"; shift
    kubectl --context "${context}" get ev -A
}