git clone https://github.com/YunoHost/install_script /root/install_script
cd /root/install_script
sleep 1
sudo ./install_yunohost -a -d testing 2> /root/100_install.err        | tee /root/100_install.log         
if [ $? -ne 0 ]; then
sudo ./install_yunohost -a -d testing 2>> /root/100_install.err        | tee -a /root/100_install.log
if [ $? -ne 0 ]; then
sudo ./install_yunohost -a -d testing 2>> /root/100_install.err        | tee -a /root/100_install.log
fi
fi
