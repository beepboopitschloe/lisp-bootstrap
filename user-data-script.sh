#!/bin/bash

PACKAGES="build-essential git-core curl sbcl"
sudo apt-get update
sudo apt-get install -y $PACKAGES

git clone git@ssh.noahmuth.com:lisp-bootstrap.git

cd lisp-bootstrap

sbcl --eval '(load "bootstrap")'
