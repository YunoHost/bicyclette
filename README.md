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

Configure the web stuff
-----------------------

I work with a symlink like :

```shell
ln -s /path/to/bicyclette/www /var/www/bicyclette
```

Install nginx and add the following configuration (replace `bicyclette.netlib.re` with your domain name) :

```
server 
{
    listen 80;
    listen [::]:80;
    server_name bicyclette.netlib.re;

    access_log /var/log/nginx/bicyclette.netlib.re-access.log;
    error_log /var/log/nginx/bicyclette.netlib.re-error.log;

    location / 
    {
        alias /var/www/bicyclette/;
        index index.html;

        try_files $uri $uri/ index.html;
    }
    
    location /logs 
    { 
		    alias /var/www/bicyclette/logs/;
		    autoindex on;

        types 
        {
            text/plain sh err log;
        }
	  }
}
```

Reload nginx, and try to access your domain (after you ran at least one test)

Usage
-----

Check the config at the beginning of `test.sh` is okay, then :
```shell
./test.sh test-name
```

Publishing to the web site is done automatically at the end of `test.sh`. If you want to manually re-publish, just run :
```shell
./publish.py
```

Adding / configuring tests
--------------------------

All files related to a given test should be in a dedicated folder. The main file
describing the steps of your test should be `test.yaml`. You can push files to
the container, execute commands, pull files (e.g. logs) and use scripts to 
analyze them and produce reports.

Cron job
--------

```
0,15,30,45 * * * * root /home/bicyclette/cron.sh
```
