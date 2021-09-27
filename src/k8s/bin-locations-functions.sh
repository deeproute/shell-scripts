#! /usr/bin/env bash

function getCNIURL() 
{
    local -r version="${1}"; shift

    local -r filename=$(getCNIFileName "${version}")

    echo "https://github.com/containernetworking/plugins/releases/download/v${version}/$filename"
}

function getCNIFileName() 
{
    local -r version="${1}"; shift

    echo "cni-plugins-linux-amd64-v${version}.tgz"
}

function getkubeURL() 
{
    local -r version="${1}"; shift
    
    echo "https://storage.googleapis.com/kubernetes-release/release/v${version}/bin/linux/amd64/{kubeadm,kubelet,kubectl}"
}

function getcrictlURL() 
{
    local -r version="${1}"; shift
    
    local -r filename=$(getcrictlFileName "${version}")

    echo "https://github.com/kubernetes-sigs/cri-tools/releases/download/v${version}/$filename"
}

function getcrictlFileName() 
{
    local -r version="${1}"; shift

    echo "crictl-v${version}-linux-amd64.tar.gz"
}