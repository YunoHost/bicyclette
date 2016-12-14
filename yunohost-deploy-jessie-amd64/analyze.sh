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
mv yunohost-installation.log 110_install.log 2>/dev/null
PATTERN="(fail[^2]|warning|no such|[^b]error|closed connection|unknown|traceback|unable)"

N00=`grep -o -i -E "$PATTERN" ./0*.{log,err} | wc -l`
N10=`grep -o -i -E "$PATTERN" ./1*.{log,err} | wc -l`
N20=`grep -o -i -E "$PATTERN" ./2*.{log,err} | wc -l`

grep -C2 -i -E "$PATTERN" ./0*.{log,err} > $LOG_DIR/00_init.log
grep -C2 -i -E "$PATTERN" ./1*.{log,err} > $LOG_DIR/10_install.log
grep -C2 -i -E "$PATTERN" ./2*.{log,err} > $LOG_DIR/20_postinstall.log
grep -C2 -i -E "$PATTERN" ./*.{log,err}  > $LOG_DIR/report.log

rm -f $LOG_DIR/summary.log

echo date: `basename $LOG_DIR` >> $LOG_DIR/summary.log
echo init: $N00                >> $LOG_DIR/summary.log
echo install: $N10             >> $LOG_DIR/summary.log
echo postinstall: $N20         >> $LOG_DIR/summary.log


