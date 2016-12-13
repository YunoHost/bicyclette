#!/bin/bash

if [ -z $LOG_DIR ]; then
    LOG_DIR=$1
fi

PULLED_DIR=`ls -d $LOG_DIR/*/`
if [ -z $PULLED_DIR ]; then
    echo "No directory found for pulled files (?)" | tee $LOG_DIR/report.log
    exit
fi

cd $PULLED_DIR
grep -r -C2 -i -E "(warning|no such|[^b]error|closed connection|unknown|traceback|unable)" ./*.{log,err} > $LOG_DIR/report.log
