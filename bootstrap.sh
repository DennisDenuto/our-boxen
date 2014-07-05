#!/bin/bash
cat <<EOF
Please README
Boxen requires at least the Xcode Command Line Tools installed.
Boxen will not work with an existing rvm install.
Boxen may not play nice with a GitHub username that includes dash(-)
Boxen may not play nice with an existing rbenv install.
Boxen may not play nice with an existing chruby install.
Boxen may not play nice with an existing homebrew install.
Boxen may not play nice with an existing nvm install.
Boxen recommends installing the full Xcode.  
EOF

if [ ! $# -eq 1 ]; then
	echo
	echo
	echo "Usage: [username]"
	exit -1
fi

read -p "Continue?[y/n]" answer
if [ $answer == "n" ]; then
	exit 0
fi

USER=$1
sudo mkdir -p /opt/boxen
sudo chown ${USER}:staff /opt/boxen
git clone https://github.com/DennisDenuto/our-boxen /opt/boxen/repo
cd /opt/boxen/repo

echo "now run: ./script/boxen"
