#!/bin/bash

PACKAGES="build-essential git-core curl sbcl nginx"
sudo apt-get update
sudo apt-get install -y $PACKAGES

git clone git@ssh.noahmuth.com:lisp-bootstrap.git

cd lisp-bootstrap

sbcl --eval '(load "bootstrap")'

export METADATA_HOST='http://169.254.169.254/metadata/v1'
export HOSTNAME=$(curl -s "${METADATA_HOST}/hostname")
export PUBLIC_IPV4=$(curl -s "${METADATA_HOST}/interfaces/public/0/ipv4/address")

echo "Hello from $HOSTNAME at $PUBLIC_IPV4!" > /usr/share/nginx/html/index.html
