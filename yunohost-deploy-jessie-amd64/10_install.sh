
git clone https://github.com/YunoHost/install_script /root/install_script
cd /root/install_script

sleep 1

LOG=/root/100_install.log
ERR=/root/100_install.err

sudo ./install_yunohost -a -d testing  2> $ERR  > $LOG
if [ $? -ne 0 ]; then
sudo ./install_yunohost -a -d testing 2>> $ERR >> $LOG
if [ $? -ne 0 ]; then
sudo ./install_yunohost -a -d testing 2>> $ERR >> $LOG
fi
fi

# Test yunohost is here
if [ -z `which yunohost` ];
then
    echo "Failure" | tee /root/199_result
else
    echo "Success" | tee /root/199_result
fi
