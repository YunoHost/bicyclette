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
IGNORE_PATTERN="(start and stop actions are no longer supported|liberror|fail2ban)"
MATCH_PATTERN="(fail|warning|no such|error|closed connection|unknown|traceback|unable)"

N00=`grep -v -E "$IGNORE_PATTERN" ./0*.{log,err} | grep -o -i -E "$MATCH_PATTERN" | wc -l`
N10=`grep -v -E "$IGNORE_PATTERN" ./1*.{log,err} | grep -o -i -E "$MATCH_PATTERN" | wc -l`
N20=`grep -v -E "$IGNORE_PATTERN" ./2*.{log,err} | grep -o -i -E "$MATCH_PATTERN" | wc -l`

grep -v -E "$IGNORE_PATTERN" ./0*.{log,err} | grep -C2 -i -E "$MATCH_PATTERN" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" > $LOG_DIR/00_init.log
grep -v -E "$IGNORE_PATTERN" ./1*.{log,err} | grep -C2 -i -E "$MATCH_PATTERN" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" > $LOG_DIR/10_install.log
grep -v -E "$IGNORE_PATTERN" ./2*.{log,err} | grep -C2 -i -E "$MATCH_PATTERN" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" > $LOG_DIR/20_postinstall.log
grep -v -E "$IGNORE_PATTERN" ./2*.{log,err} | grep -C2 -i -E "$MATCH_PATTERN" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" > $LOG_DIR/report.log

rm -f $LOG_DIR/summary.log

cat << EOF > $LOG_DIR/summary.log
{
    "init"        : { "errors" : $N00, "result": "`cat 099_result`" },
    "install"     : { "errors" : $N10, "result": "`cat 199_result`" },
    "postinstall" : { "errors" : $N20, "result": "`cat 299_result`" }
}
EOF

