
command -v git >/dev/null 2>&1 || { echo "Git not installed, aborting." >> $LOG; echo "Failure" | tee /root/199_result; exit 1; }


git clone https://github.com/YunoHost/install_script /root/install_script
cd /root/install_script

sleep 1

LOG=/root/100_install.log
ERR=/root/100_install.err

./install_yunohost -a -d testing  2> $ERR  > $LOG
if [ $? -ne 0 ]; then
./install_yunohost -a -d testing 2>> $ERR >> $LOG
if [ $? -ne 0 ]; then
./install_yunohost -a -d testing 2>> $ERR >> $LOG
fi
fi

# Test yunohost is here
if [ $? -ne 0 ];
then
    echo "Failure" | tee /root/199_result
    exit 1
fi

command -v yunohost >/dev/null 2>&1 || { echo "Failure" | tee /root/199_result; exit 1; }

echo "Success" | tee /root/199_result
