#!/bin/bash

TARGET=$1
LXCTEST="python3 /root/lxctest/lxctest/__main__.py"
LOG_DIR="`pwd`/logs/"

if [ -z $TARGET ]; then
    echo "You need to specify a target."
    exit -1;
fi
if [ ! -d $TARGET ]; then
    echo "This target doesn't exists."
    exit -1;
fi

cd $TARGET

$LXCTEST --logdir $LOG_DIR test.yaml

cd ..
./publish.sh
