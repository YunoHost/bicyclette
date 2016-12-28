LOG=/root/300_basictests.log

command -v yunohost >/dev/null 2>&1 || { echo "Yunohost not installed, aborting." >> $LOG; echo "Failure" | tee /root/399_result; exit 1; }

echo "###########################################################" >> $LOG 2>&1
echo "   Checking services   " >> $LOG 2>&1
echo "###########################################################" >> $LOG 2>&1
yunohost service status | grep -v "enabled\|running" | grep -B1 "status:\|loaded:" | sed -e 's/status:/(error?)status/g' -e 's/loaded:/(error?)loaded:/g' > $LOG 2>&1

service --status-all > services-status.tmp
SERVICES_TO_CHECK="dbus networking nscd"

for SERVICE in $SERVICES_TO_CHECK
do
    STATUS=`cat services-status.tmp | grep -E " $SERVICE\$" | awk '{print $2}'`
    if [ "$STATUS" != "+" ]
    then
        echo "Error : service $SERVICE not running properly ?" >> $LOG 2>&1
        service $SERVICE status >> $LOG 2>&1
    fi
done

rm services-status.tmp >> $LOG 2>&1

echo "###########################################################" >> $LOG 2>&1
echo "   Listing domains   " >> $LOG 2>&1
echo "###########################################################" >> $LOG 2>&1
yunohost domain list >> $LOG 2>&1

echo "###########################################################" >> $LOG 2>&1
echo "   Adding bidule.test   " >> $LOG 2>&1
echo "###########################################################" >> $LOG 2>&1
yunohost domain add bidule.test --admin-password yunohost >> $LOG 2>&1

echo "###########################################################" >> $LOG 2>&1
echo "   Listing domains   " >> $LOG 2>&1
echo "###########################################################" >> $LOG 2>&1
yunohost domain list >> $LOG 2>&1

echo "###########################################################" >> $LOG 2>&1
echo "   Removing bidule.test   " >> $LOG 2>&1
echo "###########################################################" >> $LOG 2>&1
yunohost domain remove bidule.test --admin-password yunohost >> $LOG 2>&1

echo "###########################################################" >> $LOG 2>&1
echo "   Listing domains   " >> $LOG 2>&1
echo "###########################################################" >> $LOG 2>&1
yunohost domain list >> $LOG 2>&1

echo "###########################################################" >> $LOG 2>&1
echo "   Listing users   " >> $LOG 2>&1
echo "###########################################################" >> $LOG 2>&1
yunohost user list >> $LOG 2>&1

echo "###########################################################" >> $LOG 2>&1
echo "   Creating user johndoe   " >> $LOG 2>&1
echo "###########################################################" >> $LOG 2>&1
yunohost user create johndoe -f John -l Doe -m johndoe@bidule.text -q 0 -p plop --admin-password yunohost >> $LOG 2>&1

echo "###########################################################" >> $LOG 2>&1
echo "   Listing users   " >> $LOG 2>&1
echo "###########################################################" >> $LOG 2>&1
yunohost user list >> $LOG 2>&1

echo "###########################################################" >> $LOG 2>&1
echo "   Checking johndoe info   " >> $LOG 2>&1
echo "###########################################################" >> $LOG 2>&1
yunohost user info johndoe >> $LOG 2>&1

echo "###########################################################" >> $LOG 2>&1
echo "   Updating johndoe   " >> $LOG 2>&1
echo "###########################################################" >> $LOG 2>&1
yunohost user update johndoe -f John-Michel --admin-password yunohost >> $LOG 2>&1

echo "###########################################################" >> $LOG 2>&1
echo "   Deleting johndoe   " >> $LOG 2>&1
echo "###########################################################" >> $LOG 2>&1
yunohost user delete johndoe --admin-password yunohost >> $LOG 2>&1

echo "###########################################################" >> $LOG 2>&1
echo "   Listing users   " >> $LOG 2>&1
echo "###########################################################" >> $LOG 2>&1
yunohost user list >> $LOG 2>&1

echo "Success" | tee /root/399_result
