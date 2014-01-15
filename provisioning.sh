#!/usr/bin/env bash
#
# Vagrant provisioning script
#
# Copyright 2014 Michael Weibel <michael.weibel@gmail.com>
# License: MIT
#

# Add prosody repository & key
echo "deb http://packages.prosody.im/debian precise main" > /etc/apt/sources.list.d/prosody.list
wget https://prosody.im/files/prosody-debian-packages.key -O- | sudo apt-key add -

apt-get update

# Install nginx for static file serving
apt-get install -y nginx
# Install prosody
apt-get install -y liblua5.1-bitop prosody lua-event

# Link candy folders
ln -fs /vagrant/candy /usr/share/nginx/www/candy
ln -fs /vagrant/candy-plugins /usr/share/nginx/www/candy-plugins
cp /vagrant/candy-index.html /usr/share/nginx/www/index.html

# Prosody Websockets module installation
wget -O /usr/lib/prosody/modules/mod_websocket.lua http://prosody-modules.googlecode.com/hg/mod_websocket/mod_websocket.lua

# Setup prosody config
cp /vagrant/prosody.cfg.lua /etc/prosody/prosody.cfg.lua

# Setup nginx default host config
cp /vagrant/nginx-default.conf /etc/nginx/sites-available/default

/etc/init.d/nginx restart
/etc/init.d/prosody restart