#!/usr/bin/env bash
#
# Easy installation for contributing to candy
#
# Copyright 2014 Michael Weibel <michael.weibel@gmail.com>
# License: MIT
#

# Show errors in case of undefined variables
set -o nounset

clone() {
	echo -n "* Cloning '${2}'..."
	if git clone -b "$3" --progress "$1" "$2" >> install.log 2>&1
		then echo "done"
	else
		echo "failed!"
		echo "Do you have 'git' installed in your PATH?"
		echo "Please check install.log"
		echo
		echo "Aborting"
		exit 1
	fi
}

echo
echo "Welcome to the Candy Vagrant setup"
echo
echo "This script will clone the repositories 'candy' and 'candy-plugins'"
echo "and setup & start a Virtualbox with a prosody server on it."
echo
echo "In case of an error, use 'install.log' for log informations."
echo

touch install.log
echo "" > install.log

clone git://github.com/candy-chat/candy.git candy dev
clone git://github.com/candy-chat/candy-plugins.git candy-plugins master

echo -n "* Setting up vagrant (this might take a moment)..."
if vagrant up --no-provision >> install.log 2>&1
	then echo "done"
else
	echo "failed!"
	echo "Do you have 'vagrant' installed in your PATH?"
	echo "Please check install.log"
	echo
	echo "Aborting"
	exit 2
fi

echo -n "* Provisioning vagrant (this might take a moment)..."
if vagrant provision >> install.log 2>&1
	then echo "done"
else
	echo "failed!"
	echo "Please check install.log"
	echo
	echo "Aborting"
	exit 2
fi

echo
echo "Candy is now running on http://localhost:8080"
echo

exit 0