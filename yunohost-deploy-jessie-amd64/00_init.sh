ifconfig | grep eth0 -A1 | grep "inet addr"
while [ -z `ifconfig | grep eth0 -A1 | grep "inet addr"` ]
do
    sleep 2
    ifup eth0
    ifconfig | grep eth0 -A1 | grep "inet addr"
done

apt-get update                       2> /root/000_update.err         | tee /root/000_update.log          
apt-get install -y tasksel sudo git  2> /root/010_installtasksel.err | tee /root/010_installtasksel.log  
tasksel install standard ssh-server  2> /root/020_installbase.err    | tee /root/020_installbase.log  
if [ $? -ne 0 ]; then
tasksel install standard ssh-server  2>> /root/020_installbase.err   | tee -a /root/020_installbase.log  
if [ $? -ne 0 ]; then
tasksel install standard ssh-server  2>> /root/020_installbase.err   | tee -a /root/020_installbase.log  
fi
fi
