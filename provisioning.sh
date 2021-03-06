#!/usr/bin/env bash
#
# Vagrant provisioning script
#
# Copyright 2014 Michael Weibel <michael.weibel@gmail.com>
# License: MIT
#

#
# Install Prosody XMPP server
#
echo "deb http://packages.prosody.im/debian precise main" > /etc/apt/sources.list.d/prosody.list
wget https://prosody.im/files/prosody-debian-packages.key -O- | sudo apt-key add -
apt-get update

apt-get install -y liblua5.1-bitop prosody lua-event

# Install Websockets module
wget -O /usr/lib/prosody/modules/mod_websocket.lua http://prosody-modules.googlecode.com/hg/mod_websocket/mod_websocket.lua

# Place config
cp /vagrant/prosody.cfg.lua /etc/prosody/prosody.cfg.lua

/etc/init.d/prosody restart

#
# Install nginx for static file serving
#
apt-get install -y nginx
cp /vagrant/nginx-default.conf /etc/nginx/sites-available/default
/etc/init.d/nginx restart

ln -fs /vagrant/candy /usr/share/nginx/html/candy
ln -fs /vagrant/candy-plugins /usr/share/nginx/html/candy-plugins
ln -fs /vagrant/candy-index.html /usr/share/nginx/html/index.html

#
# Candy development dependencies
#
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install -y nodejs

cd /vagrant/candy
npm install -g

#
# Selenium & PhantomJS for testing
#
apt-get install -y openjdk-7-jre
mkdir /usr/lib/selenium/
cd /usr/lib/selenium/
wget http://selenium-release.storage.googleapis.com/2.42/selenium-server-standalone-2.42.2.jar
mkdir -p /var/log/selenium/
chmod a+w /var/log/selenium/
cp /vagrant/selenium.init.sh /etc/init.d/selenium
chmod 755 /etc/init.d/selenium
/etc/init.d/selenium start
update-rc.d selenium defaults
apt-get install -y phantomjs
