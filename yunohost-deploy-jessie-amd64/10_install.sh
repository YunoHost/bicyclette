git clone https://github.com/YunoHost/install_script /root/install_script
cd /root/install_script
sudo ./install_yunohost -a -d testing 2> /root/100_install.err        | tee /root/100_install.log         
