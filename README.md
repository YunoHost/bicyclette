Bicyclette
=======

Automatic tests of Yunohost deployment and features

Install
-------

You'll need a server with Ubuntu 16.10.

(This doesn't work with Debian Jessie or Ubuntu 14.04) 

```shell
# Upgrade your system
apt-get update -y
apt-get upgrade -y

# Install lxc/lxd stuff
apt install -y lxc lxd distro-info python3-pip python3-yaml git

# Clone lxctest somewhere
cd
git clone https://github.com/alexAubin/lxctest/
```

For web-stuff

```shell
apt install -y python3-pip
pip3 install ansi2html fabric 
```

Usage
-----

Check the config at the beginning of `test.sh` is okay, then :
```shell
./test.sh test-name
```

Adding / configuring tests
--------------------------

All files related to a given test should be in a dedicated folder. The main file
describing the steps of your test should be `test.yaml`. You can push files to
the container, execute commands, pull files (e.g. logs) and use scripts to 
analyze them and produce reports.
