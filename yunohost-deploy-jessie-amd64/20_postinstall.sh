sleep 1
LOG=/root/200_postinstall.log
ERR=/root/200_postinstall.err
sudo yunohost tools postinstall --domain plop.netlib.re --password yunohost --ignore-dyndns --debug 2> $ERR > $LOG

# Test yunohost is here
if [ -z `yunohost domain list | grep plop.netlib.re` ];
then
    echo "Failure" | tee /root/299_result
else
    echo "Success" | tee /root/299_result
fi
