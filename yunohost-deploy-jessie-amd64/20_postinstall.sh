sleep 1
sudo yunohost tools postinstall --domain plop.netlib.re --password yunohost --ignore-dyndns --debug 2> /root/200_postinstall.err    | tee /root/200_postinstall.log
