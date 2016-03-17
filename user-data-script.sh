#!/bin/bash

LOGFILE=/var/log/user-data-script.log
ERRFILE=/var/log/user-data-script.err.log

PACKAGES="build-essential git-core curl sbcl nginx"
sudo apt-get update > $LOGFILE 2>$ERRFILE
sudo apt-get install -y $PACKAGES > $LOGFILE 2> $ERRFILE

# set up SBCL daemon
git clone https://github.com/nmuth/lisp-bootstrap.git /sbcld > $LOGFILE 2> $ERRFILE
cp /sbcld/sbcld.conf /etc/init/sbcld.conf > $LOGFILE 2>$ERRFILE

service sbcld start > $LOGFILE 2>$ERRFILE
