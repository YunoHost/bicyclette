#ifconfig | grep eth0 -A1 | grep "inet addr"
while [ -z `ifconfig | grep eth0 -A1 | grep "inet addr"` ]
do
    sleep 2
    ifup eth0
    #ifconfig | grep eth0 -A1 | grep "inet addr"
done

apt-get update                                         2> /root/000_update.err          > /root/000_update.log          
apt-get install -y tasksel sudo git                    2> /root/010_installtasksel.err  > /root/010_installtasksel.log  
apt-get install -y `tasksel --task-packages standard`  2> /root/020_installbase.err     > /root/020_installbase.log  
if [ $? -ne 0 ]; then
apt-get install -y `tasksel --task-packages standard` 2>> /root/020_installbase.err    >> /root/020_installbase.log  
if [ $? -ne 0 ]; then
apt-get install -y `tasksel --task-packages standard` 2>> /root/020_installbase.err    >> /root/020_installbase.log  
fi
fi

# Test nano is here (should have been installed from tasksel standard)
if [ -z `which nano` ];
then
    echo "Failure" | tee /root/099_result
else
    echo "Success" | tee /root/099_result
fi
