
cd /home/bicyclette/

LAST_COMMIT_WEB=`curl -s "https://api.github.com/repos/yunohost/yunohost/commits/testing" \
                  | python3 -c "import sys, json; print(json.load(sys.stdin)['sha'])"`

LAST_COMMIT_KNOWN=`cat .last_commit 2>/dev/null`

if [ "$LAST_COMMIT_WEB" != "$LAST_COMMIT_KNOWN" ]; then
    echo $LAST_COMMIT_WEB > .last_commit
    ./test.sh yunohost-deploy-jessie-amd64 > /dev/null 2>&1 &
fi

