#ifconfig | grep eth0 -A1 | grep "inet addr"
while [ -z `ifconfig | grep eth0 -A1 | grep "inet addr"` ]
do
    sleep 2
    ifup eth0
    #ifconfig | grep eth0 -A1 | grep "inet addr"
done

DEBIAN_FRONTEND=noninteractive apt-get update                                         2> /root/000_update.err          > /root/000_update.log
DEBIAN_FRONTEND=noninteractive apt-get install -y tasksel git                         2> /root/010_installtasksel.err  > /root/010_installtasksel.log
DEBIAN_FRONTEND=noninteractive apt-get install -y `tasksel --task-packages standard`  2> /root/020_installbase.err     > /root/020_installbase.log
if [ $? -ne 0 ]; then
DEBIAN_FRONTEND=noninteractive apt-get install -y `tasksel --task-packages standard` 2>> /root/020_installbase.err    >> /root/020_installbase.log
if [ $? -ne 0 ]; then
DEBIAN_FRONTEND=noninteractive apt-get install -y `tasksel --task-packages standard` 2>> /root/020_installbase.err    >> /root/020_installbase.log
fi
fi

if [ $? -ne 0 ]; then
    echo "Failure" | tee /root/099_result
fi

command -v nano >/dev/null 2>&1 || { echo "Failure" | tee /root/099_result; exit 1; }
command -v git  >/dev/null 2>&1 || { echo "Failure" | tee /root/099_result; exit 1; }

echo "Success" | tee /root/099_result
