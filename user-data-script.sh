#!/bin/bash

PACKAGES="build-essential git-core curl sbcl nginx"
sudo apt-get update
sudo apt-get install -y $PACKAGES

# set up SBCL daemon
git clone https://github.com/nmuth/lisp-bootstrap.git /sbcld
cp /sbcld/sbcld.conf /etc/init/sbcld.conf

service sbcld start
